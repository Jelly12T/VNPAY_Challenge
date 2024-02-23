//
//  UIViewExtension.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 23/02/2024.
//

import Foundation
import UIKit

public extension UIView {
    @IBInspectable var borderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }

        get {
            return self.layer.borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            self.layer.borderColor = newValue?.cgColor
        }

        get {
            guard let cgcolor = self.layer.borderColor else { return nil }
            return UIColor.init(cgColor: cgcolor)
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }

        get {
            return self.layer.cornerRadius
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        set {
            self.layer.shadowOffset = newValue
        }

        get {
            return self.layer.shadowOffset
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        set {
            self.layer.shadowRadius = newValue
        }

        get {
            return self.layer.shadowRadius
        }
    }

    @IBInspectable var shadowColor: UIColor? {
        set {
            self.layer.shadowColor = newValue?.cgColor
        }

        get {
            return self.layer.shadowColor != nil ? UIColor(cgColor: self.layer.shadowColor!) : nil
        }
    }

    @IBInspectable var shadowOpacity: Float {
        set {
            self.layer.shadowOpacity = newValue
        }

        get {
            return self.layer.shadowOpacity
        }
    }

    func fitSuperviewConstraint(edgeInset: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let superview = self.superview!
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: edgeInset.top).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: edgeInset.left).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -edgeInset.right).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -edgeInset.bottom).isActive = true
    }

    static func loadView(fromNib nibName: String, bundle: Bundle = Bundle.main) -> Self {
        guard let view = bundle.loadNibNamed(nibName, owner: nil, options: nil)?.last as? Self else {
            fatalError("Can not load view with type \(Self.self) in nib \"\(nibName)\" in bundle \(bundle)")
        }

        return view
    }

    func heightConstraint() -> NSLayoutConstraint? {
        var targetConstraint: NSLayoutConstraint?
        self.constraints.forEach { (constraint) in
            if (constraint.firstItem as? UIView) == self && constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                targetConstraint = constraint
            }
        }

        return targetConstraint
    }

    func widthConstraint() -> NSLayoutConstraint? {
        var targetConstraint: NSLayoutConstraint?
        self.constraints.forEach { (constraint) in
            if (constraint.firstItem as? UIView) == self && constraint.firstAttribute == NSLayoutConstraint.Attribute.width {
                targetConstraint = constraint
            }
        }

        return targetConstraint
    }

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        self.layer.cornerRadius = radius
        var cornerMask = CACornerMask()

        if corners.contains(.topLeft) {
            cornerMask.insert(.layerMinXMinYCorner)
        }

        if corners.contains(.topRight) {
            cornerMask.insert(.layerMaxXMinYCorner)
        }

        if corners.contains(.bottomLeft) {
            cornerMask.insert(.layerMinXMaxYCorner)
        }

        if corners.contains(.bottomRight) {
            cornerMask.insert(.layerMaxXMaxYCorner)
        }

        self.layer.maskedCorners = cornerMask
    }

    static var bottomSafeArea: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }

    static var topSafeArea: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
    }

    static var leftSafeArea: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0
    }

    static var rightSafeArea: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.right ?? 0
    }

    func disableInteractiveFor(seconds: Double) {
        self.isUserInteractionEnabled = false

        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.isUserInteractionEnabled = true
        }
    }

    func drawImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }

    var nibName: String {
        return type(of: self).description().components(separatedBy: ".").last! // to remove the module name and get only files name
    }

    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }
}

public extension UIView {
    func image(padding: CGFloat = 0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: bounds.width + padding * 2, height: bounds.height + padding * 2), false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.saveGState()
        context.translateBy(x: padding, y: padding)
        layer.render(in: context)
        context.restoreGState()
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }

        UIGraphicsEndImageContext()
        return image
    }

    func containsPoints(_ point: CGPoint) -> Bool {
        let extendedCoordinates: CGFloat = 15.0
        let leftTopPoint = CGPoint(x: point.x - extendedCoordinates, y: point.y - extendedCoordinates)
        let rightTopPoint = CGPoint(x: point.x + extendedCoordinates, y: point.y - extendedCoordinates)
        let leftBottomPoint = CGPoint(x: point.x - extendedCoordinates, y: point.y + extendedCoordinates)
        let rightBottomPoint = CGPoint(x: point.x + extendedCoordinates, y: point.y + extendedCoordinates)

        return !self.frame.contains(point) && !self.frame.contains(leftTopPoint) && !self.frame.contains(rightTopPoint) && !self.frame.contains(leftBottomPoint) && !self.frame.contains(rightBottomPoint)
    }

    func addLineDashedStroke(pattern: [NSNumber]?, radius: CGFloat, color: CGColor) -> CALayer {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = color
        borderLayer.lineDashPattern = pattern
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        layer.addSublayer(borderLayer)
        return borderLayer
    }

    // MARK: - Add border
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func addLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        addSubview(border)
    }

    func addRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        addSubview(border)
    }
}
