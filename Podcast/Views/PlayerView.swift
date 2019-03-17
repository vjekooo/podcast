//
//  PlayerView.swift
//  Podcast
//
//  Created by Vjeko on 17/03/2019.
//  Copyright © 2019 Vjeko. All rights reserved.
//

import UIKit
import AVKit

class PlayerView: UIView {
    
    var episode: Episode! {
        didSet {
            playerTitleLabel.text = episode.title
            
            playEpisode()
        }
    }
    
    fileprivate func playEpisode() {
        guard let url = URL(string: episode.audioStream) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    // MARK:- Actions and Outlets
    
    @IBAction func playerCloseButton(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBOutlet weak var playerImageView: UIImageView!
    
    @IBOutlet weak var playerTitleLabel: UILabel! {
        didSet {
            playerTitleLabel.numberOfLines = 2
        }
    }
    
    
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @objc func handlePlayPause() {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
    }
}
