//
//  TapableView.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import Foundation
import UIKit

open class TapableView: UIControl {
    @IBInspectable open var dimAlpha: CGFloat = 0.6
    @IBInspectable open var scaleOnHighlight: CGFloat = 0.8
    @IBInspectable var delayEventDuration: Double = 0
    private var isPreventTouch = false

    open var touchInset: UIEdgeInsets = .zero
    private var boundsWhenTouchBegan: CGRect!

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isPreventTouch {
            return
        }

        super.touchesBegan(touches, with: event)

        self.boundsWhenTouchBegan = self.bounds
        self.animate(alpha: dimAlpha, scale: self.scaleOnHighlight)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isPreventTouch {
            return
        }

        self.animate(alpha: 1, scale: 1)

        let location = touches.first!.location(in: self)
        if self.boundsWhenTouchBegan.inset(by: touchInset).contains(location) {
            self.sendActions(for: .touchUpInside)
            self.disableOverrideInteractiveFor(seconds: delayEventDuration)
        }
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.animate(alpha: 1, scale: 1)
    }

    private func animate(alpha: CGFloat, scale: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = alpha
            self.transform = scale == 1 ? .identity : .init(scaleX: scale, y: scale)
        }
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.bounds.inset(by: touchInset).contains(point)
    }

    private func disableOverrideInteractiveFor(seconds: Double) {
        if seconds == 0 {
            self.isPreventTouch = false
            return
        }

        self.isPreventTouch = true
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
            guard let self = self else { return }
            self.isPreventTouch = false
        }
    }
}
