//
//  SoundViewController.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import UIKit

class SoundViewController: UIViewController {
    @IBOutlet private weak var soundCollectionView: UICollectionView!
    @IBOutlet private weak var noDataView: UIView!
    @IBOutlet private weak var noInternetView: NoInternetView!
    @IBOutlet private weak var backTapableView: TapableView!

    // MARK: - Lazy
    lazy private var loadingView: LoadingView! = {
        return self.initLoadingView()
    }()

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
        self.viewModel.input.viewWillAppear.onNext(())
    }

    // MARK: - Config
    func config() {
        configViewModelInput()
        configViewModelOutput()
        configRoutingOutput()
        configUI()
    }

    func configViewModelInput() {
        self.backTapableView.rx.tap
            .bind(to: self.viewModel.input.didTapBackTapalbeView)
            .disposed(by: self.disposeBag)
    }

    func configViewModelOutput() {
        self.viewModel.output.updateNoInternetView
            .subscribe(onNext: { [unowned self] isConnectedInternet in
                DispatchQueue.main.async {
                    self.updateNoInterNetMode(isConnectedInternet: isConnectedInternet)
                }
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.updateNoDataView
            .subscribe(onNext: { [unowned self] isShowNoDataView in
                DispatchQueue.main.async {
                    self.soundCollectionView.alpha = isShowNoDataView ? 0 : 1
                }
            })
            .disposed(by: self.disposeBag)

        self.viewModel.output.reloadData
            .subscribe(onNext: { [unowned self] in
                DispatchQueue.main.async {
                    self.soundCollectionView.reloadData()
                }
            })
            .disposed(by: self.disposeBag)

        self.viewModel.output.updateLoadingView
            .subscribe(onNext: { [unowned self] isStart in
                DispatchQueue.main.async {
                    self.loadingView.updateAnimating(isStart: isStart)
                    self.loadingView.alpha = isStart ? 1 : 0
                }
            })
            .disposed(by: self.disposeBag)
    }

    func configRoutingOutput() {
        self.viewModel.routing.dimiss
            .subscribe(onNext: { [unowned self] in
                self.coordinator?.stop()
            })
            .disposed(by: self.disposeBag)
    }

    func configUI() {
        self.configSoundCollectionView()
    }

    private func configSoundCollectionView() {
        self.soundCollectionView.registerCell(type: SoundItemCell.self)
        self.soundCollectionView.delegate = self
        self.soundCollectionView.dataSource = self
    }

    private func configNoInternetView() {
        self.noInternetView.delegate = self
    }

    // MARK: - Init
    private func initLoadingView() -> LoadingView {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        self.view.addSubview(view)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        ])

        return view
    }

    // MARK: - Helper
    private func updateNoInterNetMode(isConnectedInternet: Bool) {
        UIView.animate(withDuration: 0.13) {
            self.noInternetView.alpha = isConnectedInternet ? 0 : 1
        }
    }
}

// MARK: - DataSource
extension SoundViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItem()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.soundCollectionView.dequeueCell(type: SoundItemCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        let itemViewModel = self.viewModel.itemAt(index: indexPath.row)
        cell.bindData(viewModel: itemViewModel)
        return cell
    }
}


// MARK: - Delegate
extension SoundViewController: UICollectionViewDelegate {
}

extension SoundViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.viewModel.cellSize()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.viewModel.spacing()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.viewModel.spacing()
    }
}

extension SoundViewController: NoInternetViewDelegate {
    func noInternetViewDidTapTryAgainTapable(_ view: NoInternetView) {
        self.viewModel.input.didTapTryAgain.onNext(())
    }
}
