//
//  BaseViewModel.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 23/02/2024.
//

import Foundation
import RxSwift

public protocol InputOutputViewModel {
    init()
}

public protocol RoutingOutput {
    init()
}

public class BaseViewModel<Input: InputOutputViewModel, Output: InputOutputViewModel, Routing: RoutingOutput> {
    var input = Input()
    var output = Output()
    var routing = Routing()
    var disposeBag = DisposeBag()
}
