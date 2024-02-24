//
//  GetListVideoCategoryFromAPI.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import UIKit

final class GetListVideoCategoryFromAPI: NetworkClient {
    func path() -> String {
        return "https://api-whistle-sos.fun-apps.net/api/video-category"
    }

    func requestData(completionHandler: (([VideoCategory]) -> Void)?) {
        self.excuted(urlAPI: self.path(), header: [:],type: [VideoCategoryEntity].self) { data, errors in
            var listVideoCategory: [VideoCategory] = []
            defer {
                completionHandler?(listVideoCategory)
            }

            guard let data = data else {
                return
            }

            listVideoCategory = data.map { VideoCategory(entity: $0) }
        }
    }

}
