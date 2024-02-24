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

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }

     func getRGB() -> Int {
         var red: CGFloat = 0
         var green: CGFloat = 0
         var blue: CGFloat = 0
         self.getRed(&red, green: &green, blue: &blue, alpha: nil)
         red *= 255;
         green *= 255;
         blue *= 255;
         return Int(red) << 16 + Int(green) << 8 + Int(blue)
     }

     func getAlpha() -> CGFloat {
         var alpha: CGFloat = 0
         self.getRed(nil, green: nil, blue: nil, alpha: &alpha)
         return alpha
     }
}
