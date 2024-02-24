//
//  VideoItem.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import UIKit

public struct VideoItem : Codable {
    var id: String
    var name: String
    var source: String
    var thumbGif: String
    var thumbMp4: String
    var thumbImage: String
    var duration: Double
    var type: String
    
    // MARK: - Init
    init(entity: VideoItemEntity) {
        self.id = entity.id
        self.name = entity.name
        self.source = entity.source
        self.thumbGif = entity.thumbGif
        self.thumbImage = entity.thumbImage
        self.thumbMp4 = entity.thumbMp4
        self.duration = entity.duration
        self.type = entity.type
    }
}
