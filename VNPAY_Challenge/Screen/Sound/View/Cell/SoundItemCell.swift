//
//  SoundItemCell.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import UIKit

class SoundItemCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var playerView: PlayerView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.config()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.playerView.alpha = 0
        self.titleLabel.text = ""
        DispatchQueue.global().async {
            self.playerView.replacePlayerItem(nil)
        }
    }

    // MARK: - Config
    private func config() {
        self.configPlayerView()
    }

    private func configPlayerView() {
        self.playerView.setLayerVideoGravity(.resizeAspectFill)
        self.playerView.loopEnable = true
        self.playerView.pauseWhenEnterBackground = true
        self.playerView.addPlayerObserver()
    }

    // MARK: - Bind Data
    func bindData(viewModel: SoundItemViewModel) {
        self.titleLabel.text = viewModel.title
        DispatchQueue.global().async {
            guard let playerItem = viewModel.thumbnailPlayerItem() else {
                return
            }

            self.playerView.replacePlayerItem(playerItem)
            self.playerView.seekTo(.zero)
            self.playerView.play()
            DispatchQueue.main.async {
                self.playerView.alpha = 1
            }
        }
    }

}
