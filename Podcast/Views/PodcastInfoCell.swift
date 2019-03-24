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
    
    var podcastInfo: PodcastInfo! {
        didSet {
            podcastTitleLabel.text = podcastInfo.title
            podcastProviderLabel.text = podcastInfo.provider
            podcastDescriptionText.text = podcastInfo.description
        }
    }
    
    @IBOutlet weak var podcastImageView: UIImageView!
    
    @IBOutlet weak var podcastTitleLabel: UILabel! {
        didSet {
            podcastTitleLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet weak var podcastProviderLabel: UILabel!
    
    @IBOutlet weak var podcastDescriptionText: UITextView!
    
}
