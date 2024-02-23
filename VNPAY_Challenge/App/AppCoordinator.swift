//
//  AppCoordinator.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 23/02/2024.
//

import UIKit

class AppCoordinator: Coordinator {
    private var window: UIWindow!
    private var splashCoordinator: SplashCoordinator?

    // MARK: - Init
    init(window: UIWindow) {
        self.window = window
        super.init()

        self.routeToSplash()
    }

    // MARK: Route to other screen
    func routeToSplash() {
        let coordinator = SplashCoordinator(window: self.window)
        coordinator.start()
        self.addChild(coordinator)
        self.splashCoordinator = coordinator
    }

}

