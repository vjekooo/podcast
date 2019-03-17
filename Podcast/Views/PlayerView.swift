//
//  PlayerView.swift
//  Podcast
//
//  Created by Vjeko on 17/03/2019.
//  Copyright © 2019 Vjeko. All rights reserved.
//

import UIKit

class PlayerView: UIView {
    
    var episode: Episode! {
        didSet {
            playerTitleLabel.text = episode.title
        }
    }
    
    @IBAction func playerCloseButton(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBOutlet weak var playerImageView: UIImageView!
    
    @IBOutlet weak var playerTitleLabel: UILabel! {
        didSet {
            playerTitleLabel.numberOfLines = 2
        }
    }
    
}
