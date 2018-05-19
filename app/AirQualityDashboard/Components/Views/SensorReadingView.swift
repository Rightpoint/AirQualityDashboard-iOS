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

public struct SensorReadingViewState {
    var pm2_5: Float?
    var pm10: Float?
}

public class SensorReadingView: UIView {
    var reactView: RCTRootView?
}

private extension SensorReadingViewState {
    var reactDictionary: [AnyHashable: Any] {
        var pm2_5String = "???"
        var pm10String = "???"
        if let pm2_5 = self.pm2_5 {
            pm2_5String = "\(pm2_5)"
        }
        if let pm10 = self.pm10 {
            pm10String = "\(pm10)"
        }
        return ["scores":
            [
                ["name": "PM2.5", "value": pm2_5String],
                ["name": "PM10", "value": pm10String],
            ],
        ]
    }
}

extension SensorReadingViewState: ViewRepresentable {
    public typealias View = SensorReadingView

    public func makeView() -> SensorReadingView {
        let view = SensorReadingView()
        guard let reactView = ReactBridge.shared.makeView(module: .highScores, initialProperties: reactDictionary) else {
            fatalError("Could not initialize React view")
        }
        reactView.frame = CGRect(x: 0, y: 0, width: 320, height: 500)
        view.addSubview(reactView)
        view.edgeAnchors == reactView.edgeAnchors
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
        reactView.appProperties = reactDictionary
    }

}
