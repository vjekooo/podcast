//
//  EpisodeCell.swift
//  Podcast
//
//  Created by Vjeko on 17/03/2019.
//  Copyright © 2019 Vjeko. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    @IBOutlet weak var episodeDateLabel: UILabel!
    
    @IBOutlet weak var episodeTitleLabel: UILabel! {
        didSet {
           episodeTitleLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet weak var episodeDescriptionLabel: UILabel! {
        didSet {
            episodeDescriptionLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet weak var episodeDurationLabel: UILabel!
    
    var episode: Episode! {
        didSet {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            episodeDateLabel.text = dateFormatter.string(from: episode.pubDate)
            episodeTitleLabel.text = episode.title
            episodeDescriptionLabel.text = episode.description
            episodeDurationLabel.text = String(episode.duration)
        }
    }
}
