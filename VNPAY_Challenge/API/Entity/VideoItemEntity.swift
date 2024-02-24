//
//  VideoItemEntity.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import Foundation

struct VideoItemEntity: Codable {
    var id: String
    var name: String
    var source: String
    var thumbGif: String
    var thumbImage: String
    var thumbMp4: String
    var duration: Double
    var type: String
}

