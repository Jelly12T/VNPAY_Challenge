//
//  SelectTopicsViewModel.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 23/02/2024.
//

import UIKit

import UIKit
import RxSwift

private struct Const {
    static let cellHegiht: CGFloat = 40
    static let spacing: CGFloat = 8
    static let maxSelectedTopics = 3
    static let cellSpacing: CGFloat = 16
}

struct SelectTopicsViewModelInput: InputOutputViewModel {
    var didSelectItem = PublishSubject<Int>()
    var didTapStartButton = PublishSubject<Void>()
}

struct SelectTopicsViewModelOutput: InputOutputViewModel {
    var updateSelectedCellAtIndex = ReplaySubject<Int>.create(bufferSize: 1)
    var updateErrorsView = BehaviorSubject<Bool>.init(value: false)
    var updateEnableStartButton = BehaviorSubject<Bool>.init(value: false)
}

struct SelectTopicsViewModelRouting: RoutingOutput {
    var dismiss = PublishSubject<Void>()
}

final class SelectTopicsViewModel: BaseViewModel<SelectTopicsViewModelInput, SelectTopicsViewModelOutput, SelectTopicsViewModelRouting> {
    private var listTopics = [SelectTopicsItemViewModel(title: "Football"),
                              SelectTopicsItemViewModel(title: "Volleyball"),
                              SelectTopicsItemViewModel(title: "Basketball"),
                              SelectTopicsItemViewModel(title: "Sport Whistle"),
                              SelectTopicsItemViewModel(title: "Mouth Whistle"),
                              SelectTopicsItemViewModel(title: "Party Whistle"),
                              SelectTopicsItemViewModel(title: "Daily Sound")]

    var numberOfItem: Int {
        return self.listTopics.count
    }

    private var numberOfSelectedItem = 0 {
        didSet {
            self.output.updateEnableStartButton.onNext(self.numberOfSelectedItem <= Const.maxSelectedTopics && self.numberOfSelectedItem >= 1)
        }
    }

    override init() {
        super.init()

        self.configInput()
        self.configOutput()
        self.configRoute()
    }

    private func configInput() {
        self.input.didSelectItem
            .subscribe(onNext: { [unowned self] index in
                let newNumberSelectedItem = self.numberOfSelectedItem + (self.listTopics[index].isSelected ? -1 : 1)
                self.output.updateErrorsView.onNext(newNumberSelectedItem > Const.maxSelectedTopics)
                if newNumberSelectedItem > Const.maxSelectedTopics {
                    return
                }

                self.listTopics[index].isSelected = !self.listTopics[index].isSelected
                self.output.updateSelectedCellAtIndex.onNext(index)
                self.numberOfSelectedItem = min(newNumberSelectedItem, Const.maxSelectedTopics)
            })
            .disposed(by: self.disposeBag)

        self.input.didTapStartButton
            .subscribe(onNext: { [unowned self] in
               // self.routing.dismiss.onNext(())
            })
            .disposed(by: self.disposeBag)
    }

    private func configOutput() {

    }

    private func configRoute() {

    }

    // MARK: - Get
    func itemAt(index: Int) -> SelectTopicsItemViewModel {
        return self.listTopics[index]
    }

    func sizeItemAt(index: Int) -> CGSize {
        let selectButtonWidth: CGFloat = 16
        let stringWidth = self.itemAt(index: index).title.widthOfString(usingFont: Montserrat.boldFont(size: 14))
        let width = stringWidth + Const.spacing * 3 + selectButtonWidth
        return CGSize(width: width, height: Const.cellHegiht)
    }

    func cellSpacing() -> CGFloat {
        return Const.cellSpacing
    }
}

