//
//  SoundViewModel.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import UIKit
import RxSwift

private struct Const {
    static let spacing: CGFloat = 10 // take by design
    static let numberOfItemsInRow: CGFloat = 2
}

struct SoundViewModelInput: InputOutputViewModel {
    var viewWillAppear = PublishSubject<Void>()
    var didTapBackTapalbeView = PublishSubject<Void>()
    var didTapTryAgain = PublishSubject<Void>()
}

struct SoundViewModelOutput: InputOutputViewModel {
    var updateLoadingView = PublishSubject<Bool>()
    var updateNoDataView = PublishSubject<Bool>()
    var reloadData = PublishSubject<Void>()
    var updateNoInternetView = ReplaySubject<Bool>.create(bufferSize: 1)
}

struct SoundViewModelRouting: RoutingOutput {
    var dimiss = PublishSubject<Void>()
}

final class SoundViewModel: BaseViewModel<SoundViewModelInput, SoundViewModelOutput, SoundViewModelRouting> {
    private var listTopicSelected: [String]
    private var listVideoItem: [VideoItem] = []
    private var isLoadingData = false
    private var isConnectedInternet = true {
        didSet {
            if !self.isLoadingData && self.isConnectedInternet {
                self.output.updateNoInternetView.onNext(false)
                return
            }
        }
    }

    init(listTopicSelected: [String]) {
        self.listTopicSelected = listTopicSelected
        super.init()

        self.fetchData()
        self.configInput()
        self.configOutput()
        self.configRoute()
        self.configNotification()
    }

    // MARK: - Config
    private func configInput() {
        self.input.didTapTryAgain
            .subscribe(onNext: { [unowned self] in
                if self.isConnectedInternet {
                    self.output.updateNoInternetView.onNext(true)
                    self.fetchData()
                }
            })
            .disposed(by: self.disposeBag)

        self.input.didTapBackTapalbeView
            .bind(to: self.routing.dimiss)
            .disposed(by: self.disposeBag)

        self.input.viewWillAppear
            .subscribe(onNext: { [unowned self] in
                self.output.updateLoadingView.onNext(true)
            })
            .disposed(by: self.disposeBag)
    }

    private func configOutput() {

    }

    private func configRoute() {

    }


    // MARK: - Fetch Data
    private func fetchData() {
        let getListVideoCategoryFromAPI = GetListVideoCategoryFromAPI()
        getListVideoCategoryFromAPI.requestData { data in
            let listVideoCategory = data.filter { [unowned self] in
                self.listTopicSelected.contains($0.name.lowercased())
            }

            self.listVideoItem = listVideoCategory.flatMap { $0.videos }
            self.output.reloadData.onNext(())
            self.output.updateNoDataView.onNext(self.listVideoItem.isEmpty)
            self.output.updateLoadingView.onNext(false)
        }
    }

    private func configNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInternet), name: .didChangeConnectNetworkActivity, object: nil)
    }

    @objc private func handleInternet() {
        self.isConnectedInternet = MonitorNetwork.shared.isConnectedNetwork()
    }

    // MARK: - Get
    func numberOfItem() -> Int {
        return self.listVideoItem.count
    }

    func spacing() -> CGFloat {
        return Const.spacing
    }

    func itemAt(index: Int) -> SoundItemViewModel {
        return SoundItemViewModel(thumbMp4: self.listVideoItem[index].thumbMp4, title: self.listVideoItem[index].name)
    }

    func cellSize() -> CGSize {
        let widthScreen = UIScreen.main.bounds.width
        let marginHorizontal: CGFloat = 20
        let widthCell = (widthScreen - marginHorizontal - self.spacing()) / Const.numberOfItemsInRow
        return CGSize(width: widthCell, height: widthCell)
    }

}
