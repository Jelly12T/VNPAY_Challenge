//  CollectionViewExtension.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 23/02/2024.
//


import Foundation
import UIKit

public extension UIColor {
    func hex() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: nil)

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
     }
}
