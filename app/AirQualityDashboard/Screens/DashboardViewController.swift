//
//  ReactNativeViewController.swift
//  AirQualityDashboard
//
//  Created by Chris Ballinger on 5/16/18.
//

import Foundation
import React
import Anchorage

class DashboardViewController: UIViewController {

    var sensorReading = SensorReadingViewState() {
        didSet {
            guard let sensorReadingView = self.sensorReadingView else {
                return
            }
            sensorReading.update(view: sensorReadingView)
        }
    }

    private var sensorReadingView: SensorReadingView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let sensorReadingView = sensorReading.makeView()
        sensorReading.update(view: sensorReadingView)
        view.addSubview(sensorReadingView)
        view.edgeAnchors == sensorReadingView.edgeAnchors
        self.sensorReadingView = sensorReadingView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sensorReadingView?.reactView?.bounds = view.bounds
    }

}
