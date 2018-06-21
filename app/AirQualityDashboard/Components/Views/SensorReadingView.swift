//
//  SensorReadingView.swift
//  AirQualityDashboard
//
//  Created by Chris Ballinger on 5/18/18.
//

import Foundation
import BLEAirQuality
import Anchorage
import React

public struct SensorReading {
    var pm2_5: Measurement<UnitConcentrationMass>?
    var pm10: Measurement<UnitConcentrationMass>?
}

public class SensorReadingView: UIView {
    fileprivate var reactView: RCTRootView?
}

extension SensorReading: ReactRepresentable {
    static let formatter: MeasurementFormatter = {
        let f = MeasurementFormatter()
        f.unitStyle = .short
        f.unitOptions = .providedUnit
        return f
    }()
    var propsDictionary: [AnyHashable: Any] {
        var readings: [[String: String]] = []
        if let pm2_5 = self.pm2_5 {
            readings.append(["name": "PM2.5", "value": "\(SensorReading.formatter.string(from: pm2_5))"])
        }
        if let pm10 = self.pm10 {
            readings.append(["name": "PM10", "value": "\(SensorReading.formatter.string(from: pm10))"])
        }
        let props = ["readings": readings]
        return props
    }
}

extension SensorReading: ViewRepresentable {
    public typealias View = SensorReadingView

    public func makeView() -> SensorReadingView {
        let view = SensorReadingView()
        guard let reactView = ReactBridge.shared.makeView(module: .airQuality, initialProperties: propsDictionary) else {
            fatalError("Could not initialize React view")
        }
        view.addSubview(reactView)
        reactView.edgeAnchors == view.edgeAnchors
        view.reactView = reactView
        return view
    }

    public func configure(view: SensorReadingView) {
        update(view: view)
    }

    public func update(view: UIView) {
        guard let sensorView = view as? SensorReadingView,
            let reactView = sensorView.reactView else {
                return
        }
        reactView.update(self)
    }

}
