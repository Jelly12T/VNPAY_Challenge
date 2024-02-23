//
//  SplashViewModel.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 23/02/2024.
//

import UIKit
import RxSwift

private struct Const {
    static let timeDelay = 2
}

struct SplashViewModelInput: InputOutputViewModel {

}

struct SplashViewModelOutput: InputOutputViewModel {
    var updateBackgroundColor = PublishSubject<Void>()
}

struct SplashViewModelRouting: RoutingOutput {
    var stopSplash = PublishSubject<Void>()
}

final class SplashViewModel: BaseViewModel<SplashViewModelInput, SplashViewModelOutput, SplashViewModelRouting> {

    override init() {
        super.init()

        self.finishSplashScreenAfterAFewSeconds()
    }

    private func finishSplashScreenAfterAFewSeconds() {
        Observable.just(())
            .delay(.seconds(Const.timeDelay), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.routing.stopSplash.onNext(())
            })
            .disposed(by: self.disposeBag)
    }

}
