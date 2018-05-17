//
//  ReactNativeViewController.swift
//  AirQualityDashboard
//
//  Created by Chris Ballinger on 5/16/18.
//

import Foundation
import React
import Anchorage

class ReactNativeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("Hello")
        let mockData:NSDictionary = ["scores":
            [
                ["name":"Alex", "value":"42"],
                ["name":"Joel", "value":"10"]
            ]
        ]
        guard let bundle = Bundle.main.url(forResource: "main", withExtension: "jsbundle"),
            let rootView = RCTRootView(
            bundleURL: bundle,
            moduleName: "RNHighScores",
            initialProperties: mockData as [NSObject : AnyObject],
            launchOptions: nil
            ) else { return }
        view.addSubview(rootView)
        rootView.edgeAnchors == view.edgeAnchors
    }

}
