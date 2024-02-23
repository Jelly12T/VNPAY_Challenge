//
//  SelectTopicsCoordinator.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 23/02/2024.
//

import UIKit

final class SelectTopicsCoordinator: Coordinator {
    var window: UIWindow!
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

        self.window.rootViewController = self.controller
        self.window.makeKeyAndVisible()
    }

    override func stop(completion: (() -> Void)? = nil) {
        if self.window.rootViewController == self {
            self.window.rootViewController = nil
        }

        super.stop(completion: completion)
    }
}
