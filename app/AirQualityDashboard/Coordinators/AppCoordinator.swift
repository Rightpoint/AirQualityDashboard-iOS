//
//  AppCoordinator.swift
//  AirQualityDashboard
//
//  Created by Eliot Williams on 3/24/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import UIKit
import Services

class AppCoordinator: Coordinator {

    private let window: UIWindow
    fileprivate let rootController: DashboardViewController
    var childCoordinator: Coordinator?

    init(window: UIWindow) {
        self.window = window
        let rootController = DashboardViewController()
        rootController.view.backgroundColor = .white
        self.rootController = rootController
    }

    func start(animated: Bool, completion: VoidClosure?) {
        // Configure window/root view controller
        window.setRootViewController(rootController, animated: false, completion: {
            self.window.makeKeyAndVisible()

            // Spin off auth coordinator
            let dashboardCoordinator = DashboardCoordinator(self.rootController)
            self.childCoordinator = dashboardCoordinator
            dashboardCoordinator.start(animated: false, completion: completion)
        })
    }

    func cleanup(animated: Bool, completion: VoidClosure?) {
        completion?()
    }

}
