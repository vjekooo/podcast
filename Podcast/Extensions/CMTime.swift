//
//  CMTime.swift
//  Podcast
//
//  Created by Vjeko on 17/03/2019.
//  Copyright © 2019 Vjeko. All rights reserved.
//

import AVKit

extension CMTime {
    
    func displayTimeString() -> String {
        
        let timeInterval = Int(CMTimeGetSeconds(self))
        let minutes = timeInterval / 60
        let seconds = timeInterval % 60
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        
        return timeFormatString
    }
}
