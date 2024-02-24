//
//  SoundItemViewModel.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import UIKit
import AVFoundation

struct SoundItemViewModel {
    var thumbMp4: String
    var title: String

    // MARK: - Get
    func thumbnailPlayerItem() -> AVPlayerItem? {
        guard let url = URL(string: self.thumbMp4.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            return nil
        }

        let playerItem = AVPlayerItem(url: url)
        return playerItem
    }

}
