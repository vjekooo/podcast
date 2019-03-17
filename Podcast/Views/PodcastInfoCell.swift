//
//  PodcastInfoCell.swift
//  Podcast
//
//  Created by Vjeko on 16/03/2019.
//  Copyright © 2019 Vjeko. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastInfoCell: UITableViewCell {
    
    @IBOutlet weak var podcastImageView: UIImageView!
    
    @IBOutlet weak var podcastTitleLabel: UILabel! {
        didSet {
            podcastTitleLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet weak var podcastProviderLabel: UILabel!
    
    @IBOutlet weak var podcastDescriptionText: UITextView!
    
    
    var podcastInfo: PodcastInfo! {
        didSet {
            podcastTitleLabel.text = podcastInfo.title
            //podcastProviderLabel.text = podcast.trackName
            podcastDescriptionText.text = podcastInfo.description
        }
    }
    
}
