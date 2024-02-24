//
//  GetVideoItemByIDFormAPI.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import UIKit

final class GetVListideoCategoryFromAPI: NetworkClient {
    func path() -> String {
        return "https://api-whistle-sos.fun-apps.net/api/video-category"
    }

    func requestAPI(completionHandler: ((VideoItemEntity?, Error?) -> Void)?) {
        self.excuted(urlAPI: self.path(), header: [:],type: [VideoCategoryEntity].self) { data, errors in
        }
    }

}
