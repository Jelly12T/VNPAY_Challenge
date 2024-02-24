//
//  SelectTopicsCoordinator.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 23/02/2024.
//

import UIKit

final class SelectTopicsCoordinator: Coordinator {
    var window: UIWindow!
    private var soundCoordinator: SoundCoordinator?

    init(window: UIWindow!) {
        self.window = window
    }

    lazy var controller: SelectTopicsViewController = {
        let viewModel = SelectTopicsViewModel()
        let controller = SelectTopicsViewController(viewModel: viewModel, coordinator: self)
        return controller
    }()

    override func start() {
        super.start()

        let navigation = UINavigationController(rootViewController: self.controller)
        self.window.rootViewController = navigation
        self.window.makeKeyAndVisible()
    }

    override func stop(completion: (() -> Void)? = nil) {
        if self.window.rootViewController == self {
            self.window.rootViewController = nil
        }

        super.stop(completion: completion)
    }

    // MARK: - Route TO Other Screen
    func routeToSound() {

        guard let navigationController = self.controller.navigationController else {
            return
        }

        let coordinator = SoundCoordinator(navigationController: navigationController)
        coordinator.start()
        self.addChild(coordinator)
        self.soundCoordinator = coordinator
    }
}
