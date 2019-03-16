//
//  PodcastCell.swift
//  Podcast
//
//  Created by Vjeko on 16/03/2019.
//  Copyright © 2019 Vjeko. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastImageView: UIImageView!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var episodeCountLabel: UILabel!
    
    var podcast: Podcast! {
        didSet {
            artistNameLabel.text = podcast.artistName
            trackNameLabel.text = podcast.trackName
            episodeCountLabel.text = "\(podcast.trackCount ?? 0) episodes"
            
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
            
            podcastImageView.sd_setImage(with: url, completed: nil)
        }
    }
}
