//
//  SplashViewController.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 23/02/2024.
//

import UIKit
import RxSwift

class SplashViewController: UIViewController {
    var viewModel: SplashViewModel
    weak var coordinator: SplashCoordinator?

    init(viewModel: SplashViewModel, coordinator: SplashCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    func config() {
        configViewModelInput()
        configViewModelOutput()
        configRoutingOutput()
    }

    func configViewModelInput() {

    }

    func configViewModelOutput() {
        
    }

    func configRoutingOutput() {
        self.viewModel.routing.stopSplash
            .subscribe(onNext: { [unowned self] in
                self.coordinator?.stop()
            })
            .disposed(by: self.disposeBag)
    }
}
