//
//  SelectTopicsViewController.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 23/02/2024.
//

import UIKit
import RxSwift

class SelectTopicsViewController: UIViewController {
    @IBOutlet private weak var blurView: UIView!
    @IBOutlet private weak var startTapableView: TapableView!
    @IBOutlet private weak var notificationView: UIView!
    @IBOutlet private weak var selectTopicsCollectionView: UICollectionView!

    var viewModel: SelectTopicsViewModel
    weak var coordinator: SelectTopicsCoordinator?

    init(viewModel: SelectTopicsViewModel, coordinator: SelectTopicsCoordinator) {
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
        configUI()
    }

    func configViewModelInput() {
        self.startTapableView.rx.tap
            .bind(to: self.viewModel.input.didTapStartButton)
            .disposed(by: self.disposeBag)
    }

    func configViewModelOutput() {
        self.viewModel.output.updateSelectedCellAtIndex
            .subscribe(onNext: { [unowned self] index in
                guard let cell = self.selectTopicsCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? SelectTopicCell else {
                    return
                }

                cell.updateSelectedItem(viewModel: self.viewModel.itemAt(index: index))
            })
            .disposed(by: self.disposeBag)

        self.viewModel.output.updateErrorsView
            .subscribe(onNext: { [unowned self] isError in
                self.updateNotificationView(isError: isError)
            })
            .disposed(by: self.disposeBag)

        self.viewModel.output.updateEnableStartButton
            .subscribe(onNext: { [unowned self] isEnable in
                self.updateStartTapableView(isEnable: isEnable)
            })
            .disposed(by: self.disposeBag)

    }

    func configRoutingOutput() {
        self.viewModel.routing.routeToSound
            .subscribe(onNext: { [unowned self] listTopicSelected in
                self.coordinator?.routeToSound(listTopicSelected: listTopicSelected)
            })
            .disposed(by: self.disposeBag)
    }

    private func configUI() {
        self.configTopicCollecionView()
    }

    func configTopicCollecionView() {
        self.selectTopicsCollectionView.registerCell(type: SelectTopicCell.self)
        self.selectTopicsCollectionView.dataSource = self
        self.selectTopicsCollectionView.delegate = self
        let flowLayout = SelectTopicsCollectionViewLayout()
        flowLayout.delegate = self
        self.selectTopicsCollectionView.collectionViewLayout = flowLayout
    }

    // MARK: - Update
    private func updateNotificationView(isError: Bool) {
        UIView.animate(withDuration: 0.15) {
            self.notificationView.alpha = isError ? 1 : 0
        }
    }

    private func updateStartTapableView(isEnable: Bool) {
        self.startTapableView.isUserInteractionEnabled = isEnable
        UIView.animate(withDuration: 0.15) {
            self.blurView.alpha = isEnable ? 0 : 1
        }
    }
}

// MARK: - UICollectionViewDelegate
extension SelectTopicsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.input.didSelectItem.onNext(indexPath.row)
    }
}

// MARK: - UICollectionViewDataSource
extension SelectTopicsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItem
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.selectTopicsCollectionView.dequeueCell(type: SelectTopicCell.self, indexPath: indexPath)!
        cell.bind(viewModel: self.viewModel.itemAt(index: indexPath.row))
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SelectTopicsViewController: SelectTopicsCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.viewModel.sizeItemAt(index: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.viewModel.cellSpacing()
    }

    func collectionView(_ collectionView: UICollectionView, itemSpacingInSection section: Int) -> CGFloat {
        return self.viewModel.cellSpacing()
    }
}

