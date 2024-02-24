//
//  SoundViewController.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import UIKit

class SoundViewController: UIViewController {
    var viewModel: SoundViewModel
    weak var coordinator: SoundCoordinator?

    init(viewModel: SoundViewModel, coordinator: SoundCoordinator) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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

    }
}
