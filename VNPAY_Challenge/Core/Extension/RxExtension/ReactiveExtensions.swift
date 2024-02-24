//
//  ReactiveExtensions.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIControl {
    public var tap: ControlEvent<Void> {
        controlEvent(.touchUpInside)
    }
}
