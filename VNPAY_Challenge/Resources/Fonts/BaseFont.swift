//
//  BaseFont.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import UIKit

public class BaseFont {
    public class func name() -> String {
        return String(describing: self)
    }

    public class func lightFont(size: CGFloat) -> UIFont {
        return UIFont(name: "\(name())-Light", size: size)!
    }

    public class func regularFont(size: CGFloat) -> UIFont {
        return UIFont(name: "\(name())-Regular", size: size)!
    }

    public class func mediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: "\(name())-Medium", size: size)!
    }

    public class func semiBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "\(name())-SemiBold", size: size)!
    }

    public class func boldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "\(name())-Bold", size: size)!
    }

    public class func extraBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "\(name())-ExtraBold", size: size)!
    }
}
