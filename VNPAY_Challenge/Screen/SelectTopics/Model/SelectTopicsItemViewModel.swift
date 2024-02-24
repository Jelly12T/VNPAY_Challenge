//
//  SelectTopicsItemViewModel.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import UIKit

struct SelectTopicsItemViewModel {
    var title: String
    var isSelected: Bool = false

    // MARK: - Get
    func backgroundColor() -> UIColor {
        return self.isSelected ? UIColor(rgb: 0x333333) : .white
    }

    func boderWidth() -> CGFloat {
        return self.isSelected ? 0 : 1
    }

    func textColor() -> UIColor {
        return self.isSelected ? .white : UIColor(rgb: 0x333333)
    }

    func selectedImage() -> UIImage {
        return UIImage(named: isSelected ? "ic_unselect_topics" : "ic_select_topics")!
    }
}
