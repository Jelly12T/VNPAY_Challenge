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
    private var selectTopicsCoordinator: SelectTopicsCoordinator?

    // MARK: - Init
    init(window: UIWindow) {
        self.window = window
        super.init()

        self.routeToSplash()
    }

    override func childDidStop(_ child: Coordinator) {
        super.childDidStop(child)

        if child is SplashCoordinator {
            self.splashCoordinator = nil
            self.routeToSelectTopics()
        }

        if child is SelectTopicsCoordinator {
            self.selectTopicsCoordinator = nil
        }
    }

    // MARK: Route to other screen
    func routeToSplash() {
        let coordinator = SplashCoordinator(window: self.window)
        coordinator.start()
        self.addChild(coordinator)
        self.splashCoordinator = coordinator
    }

    func routeToSelectTopics() {
        let coordinator = SelectTopicsCoordinator(window: self.window)
        coordinator.start()
        self.addChild(coordinator)
        self.selectTopicsCoordinator = coordinator
    }
}

