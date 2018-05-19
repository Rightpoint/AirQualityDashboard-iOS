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
            self?.peripherals.insert(peripheral)
        }
        sensor.startScan()

        let readingBlock: ReadingBlock = { [weak self] (reading, error) in
            guard let reading = reading else {
                if let error = error {
                    debugPrint("Error getting reading... \(error)")
                }
                return
            }
            self?.readingUpdated(reading: reading)
        }

        var count: Float = 0.0

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            /// DEBUG
            count += 1
            self?.baseController.sensorReading.pm2_5 = count
            self?.baseController.sensorReading.pm10 = count + 1
            return

            // For now just use first peripheral we find
            guard let peripheral = self?.peripherals.first else {
                return
            }
            self?.sensor.fetchReading(from: peripheral, type: .pm2_5, completion: readingBlock)
            self?.sensor.fetchReading(from: peripheral, type: .pm10, completion: readingBlock)
        })
        completion?()
    }

    func cleanup(animated: Bool, completion: VoidClosure?) {
        sensor.stopScan()
        completion?()
    }
}
