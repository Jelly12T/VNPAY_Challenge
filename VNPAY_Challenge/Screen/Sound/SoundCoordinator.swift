//
//  SoundCoordinator.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import UIKit

final class SoundCoordinator: Coordinator {
    private var listTopicSelected: [String]
    private var navigationController: UINavigationController

    init(listTopicSelected: [String], navigationController: UINavigationController) {
        self.listTopicSelected = listTopicSelected
        self.navigationController = navigationController
        super.init()
    }

    lazy var controller: SoundViewController = {
        let viewModel = SoundViewModel(listTopicSelected: self.listTopicSelected)
        let controller = SoundViewController(viewModel: viewModel, coordinator: self)
        return controller
    }()

    override func start() {
        super.start()
        
        navigationController.pushViewController(controller, animated: true)
    }

    override func stop(completion: (() -> Void)? = nil) {
        if navigationController.topViewController == controller {
            navigationController.popViewController(animated: true)
        }

        super.stop(completion: completion)
    }
}
