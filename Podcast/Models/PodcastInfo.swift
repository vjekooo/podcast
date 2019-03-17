//
//  PodcastInfo.swift
//  Podcast
//
//  Created by Vjeko on 16/03/2019.
//  Copyright © 2019 Vjeko. All rights reserved.
//

import Foundation
import FeedKit

struct PodcastInfo {
    let title: String
    let description: String
    let provider: String
    
    init(feed: RSSFeed) {
        self.title = feed.title ?? ""
        self.description = feed.description ?? ""
        self.provider = feed.iTunes?.iTunesAuthor ?? ""
    }
}
