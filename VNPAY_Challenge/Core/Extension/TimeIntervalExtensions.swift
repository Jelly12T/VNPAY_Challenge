//
//  TimeIntervalExtensions.swift
//  BabyPhoto
//
//  Created by VietLV on 7/13/20.
//  Copyright © 2020 Solar. All rights reserved.
//

import Foundation
import AVFoundation

public extension TimeInterval {
    func toDurationString() -> String {
        let seconds: Int = Int(self) % 60
        let minutes = Int(self / 60)
        let hours = Int(self / 3600)
        
        if hours == 0 {
            return String.init(format: "%02d:%02d", minutes, seconds)
        }
        
        return String.init(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func toRecordingString() -> String {
        let seconds: Int = Int(self) % 60
        let minutes = Int(self / 60)
        let hours = Int(self / 3600)
        return String.init(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func toString() -> String {
        if self.isNaN {
            return "00:00"
        }
        
        let seconds: Int = Int(self) % 60
        let minutes = Int(self / 60)
        return String.init(format: "%02d:%02d", minutes, seconds)
    }
}

extension CMTime {
    func toDouble() -> Float64 {
        return CMTimeGetSeconds(self)
    }
}
