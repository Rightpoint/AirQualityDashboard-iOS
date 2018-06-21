//
//  ContentCoordinator.swift
//  AirQualityDashboard
//
//  Created by Eliot Williams on 3/27/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import UIKit
import Services
import BLEAirQuality

class DashboardCoordinator {

    #if targetEnvironment(simulator)
    var count = Measurement.fromSensor(microgramsPerCubicMeter: 0.0)
    let one = Measurement.fromSensor(microgramsPerCubicMeter: 1.0)
    #endif

    private let sensor = SensorManager()
    private var peripherals = Set<Peripheral>()
    private var timer: Timer?

    let baseController: DashboardViewController
    var childCoordinator: Coordinator?

    init(_ baseController: DashboardViewController) {
        self.baseController = baseController
    }

    private func readingUpdated(reading: Reading) {
        switch reading.type {
        case .pm2_5:
            baseController.sensorReading.pm2_5 = reading.value
        case .pm10:
            baseController.sensorReading.pm10 = reading.value
        }
    }
}

extension DashboardCoordinator: Coordinator {

    func start(animated: Bool, completion: VoidClosure?) {
        sensor.scanBlock = { [weak self] (peripheral) in
            debugPrint("found peripheral \(peripheral)")
            self?.peripherals.insert(peripheral)
        }
        sensor.startScan()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            self?.updateReadings()
        })
        completion?()
    }

    func cleanup(animated: Bool, completion: VoidClosure?) {
        timer?.invalidate()
        timer = nil
        sensor.stopScan()
        completion?()
    }
}

private extension DashboardCoordinator {
    func updateReadings() {
        let readingBlock: ReadingBlock = { [weak self] (reading, error) in
            guard let reading = reading else {
                if let error = error {
                    debugPrint("Error getting reading... \(error)")
                }
                return
            }
            self?.readingUpdated(reading: reading)
        }

        #if targetEnvironment(simulator)
        // Measurement's don't work with += operator
        // swiftlint:disable:next shorthand_operator
        count = count + one
        self.baseController.sensorReading.pm2_5 = count
        self.baseController.sensorReading.pm10 = count + one
        #else
        // For now just use first peripheral we find
        guard let peripheral = self.peripherals.first else {
            return
        }
        self.sensor.fetchReading(from: peripheral, type: .pm2_5, completion: readingBlock)
        self.sensor.fetchReading(from: peripheral, type: .pm10, completion: readingBlock)
        #endif
    }
}
