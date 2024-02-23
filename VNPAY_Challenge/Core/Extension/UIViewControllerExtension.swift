//
//  UIViewControllerExtension.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 23/02/2024.
//

import UIKit
import RxSwift

private struct Keys {
    static var disposeBagKey = ""
}

extension UIViewController {
    var disposeBag: DisposeBag {
        if let bag = objc_getAssociatedObject(self, &Keys.disposeBagKey) as? DisposeBag {
            return bag
        }

        let bag = DisposeBag()
        objc_setAssociatedObject(self, &Keys.disposeBagKey, bag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return bag
    }
}
