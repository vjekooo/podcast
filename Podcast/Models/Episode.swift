//
//  Episode.swift
//  Podcast
//
//  Created by Vjeko on 17/03/2019.
//  Copyright © 2019 Vjeko. All rights reserved.
//

import Foundation
import FeedKit

struct Episode {
    let pubDate: Date
    let title: String
    let description: String
    let duration: Double
    
    init(feedItem: RSSFeedItem) {
        self.pubDate = feedItem.pubDate ?? Date()
        self.title = feedItem.title ?? ""
        self.description = feedItem.description ?? ""
        self.duration = feedItem.iTunes?.iTunesDuration ?? 0
    }
}
