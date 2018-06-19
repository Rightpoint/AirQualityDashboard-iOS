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
            sensorReading.update(view: sensorReadingView)
        }
    }

    private lazy var sensorReadingView: SensorReadingView = {
        return sensorReading.makeView()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sensorReadingView)
        sensorReadingView.edgeAnchors == view.edgeAnchors
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        sensorReadingView?.reactView?.bounds = view.bounds
    }

}
