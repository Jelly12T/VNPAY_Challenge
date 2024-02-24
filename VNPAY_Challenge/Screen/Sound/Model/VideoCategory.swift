//
//  VideoCategory.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import Foundation

public struct VideoCategory {
    var id: String
    var name: String
    var thumb: String
    var itemCount: Int
    var videos: [VideoItem]

    // MARK: - Init
    init(entity: VideoCategoryEntity) {
        self.id = entity.id
        self.name = entity.name
        self.thumb = entity.thumb
        self.itemCount = entity.itemCount
        self.videos = entity.videos.map { VideoItem(entity: $0) }
    }
}

extension VideoCategory: Equatable {
    public static func == (lhs: VideoCategory, rhs: VideoCategory) -> Bool {
        return lhs.id == rhs.id
    }
}
