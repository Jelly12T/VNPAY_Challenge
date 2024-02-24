//
//  SelectTopicCell.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import UIKit

class SelectTopicCell: UICollectionViewCell {
    @IBOutlet private weak var selectImageView: UIImageView!
    @IBOutlet private weak var backgroundCellView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Bind
    func bind(viewModel: SelectTopicsItemViewModel) {
        self.titleLabel.text = viewModel.title
    }

    // MARK: - UpdateUI
    func updateSelectedItem(viewModel: SelectTopicsItemViewModel) {
        UIView.animate(withDuration: 0.2) {
            self.backgroundCellView.backgroundColor = viewModel.backgroundColor()
            self.backgroundCellView.borderWidth = viewModel.boderWidth()
            self.selectImageView.image = viewModel.selectedImage()
            self.titleLabel.textColor = viewModel.textColor()
        }
    }
}
