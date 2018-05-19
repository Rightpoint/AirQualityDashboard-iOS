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

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("Hello")
        let mockData:NSDictionary = ["scores":
            [
                ["name":"Alex", "value":"42"],
                ["name":"Joel", "value":"10"]
            ]
        ]
        let url = URL(string: "http://localhost:8081/index.bundle?platform=ios")!
        // let url = Bundle.main.url(forResource: "main", withExtension: "jsbundle")
        guard let rootView = RCTRootView(
            bundleURL: url,
            moduleName: "RNHighScores",
            initialProperties: mockData as [NSObject : AnyObject],
            launchOptions: nil
            ) else { return }
        view.addSubview(rootView)
        rootView.edgeAnchors == view.edgeAnchors
    }

}
