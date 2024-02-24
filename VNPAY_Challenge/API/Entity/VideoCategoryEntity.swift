//
//  VideoCategoryEntity.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import Foundation

struct VideoCategoryEntity: Codable {
    var id: String
    var name: String
    var thumb: String
    var itemCount: Int
    var videos: [VideoItemEntity]
}
