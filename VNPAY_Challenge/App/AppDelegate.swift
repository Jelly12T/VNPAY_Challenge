//
//  AppDelegate.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 23/02/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        self.configAppCoordinator()
        self.configAppearance()
        self.configMonitorNetwork()
        return true
    }

    // MARK: - Config
    private func configAppearance() {
        UIView.appearance().isExclusiveTouch = true
        UIView.appearance().isMultipleTouchEnabled = false

        if #available(iOS 13.0, *) {
            UIView.appearance().overrideUserInterfaceStyle = .light
        }
    }

    private func configAppCoordinator() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        self.appCoordinator = AppCoordinator(window: self.window!)
        self.appCoordinator.start()
    }

    func configMonitorNetwork() {
        MonitorNetwork.shared.configMonitorNetwork()
    }
}

