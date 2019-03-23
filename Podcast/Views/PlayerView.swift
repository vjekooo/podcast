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
            
            //guard let url = URL(string: episode.artwork) else { return }
            //playerImageView.sd_setImage(with: url, completed: nil)
            
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let interval = CMTimeMake(value: 1, timescale: 2)
        
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self](time) in
            
            self?.playerStartTimeLabel.text = time.displayTimeString()
            
            let duration = self?.player.currentItem?.duration
            
            self?.playerEndTimeLabel.text = duration?.displayTimeString()
            
            self?.updateTimeSlider()
        }
    }
    
    fileprivate func updateTimeSlider() {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        
        let percentage = currentTime / duration
        
        self.playerTimeSlider.value = Float(percentage)
    }
    
    // MARK:- Actions and Outlets
    
    @IBAction func playerVolumeSliderAction(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    @IBAction func playerRewindAction(_ sender: Any) {
        
        let currentTime = CMTimeGetSeconds(player.currentTime())
        
        let rewind = Float64(currentTime) - 15
        
        let seekTime = CMTimeMakeWithSeconds(rewind, preferredTimescale: Int32(NSEC_PER_SEC))
        
        player.seek(to: seekTime)
    }
    
    
    @IBAction func playerFastForwardAction(_ sender: Any) {
        
        let currentTime = CMTimeGetSeconds(player.currentTime())
        
        let rewind = Float64(currentTime) + 15
        
        let seekTime = CMTimeMakeWithSeconds(rewind, preferredTimescale: Int32(NSEC_PER_SEC))
        
        player.seek(to: seekTime)
    }
    
    @IBAction func playerTimeSliderAction(_ sender: Any) {
        print(playerTimeSlider.value)
        
        let percentage = playerTimeSlider.value
        
        guard let duration = player.currentItem?.duration else { return }
        
        let seconds = CMTimeGetSeconds(duration)
        
        let seekTimeSeconds = seconds * Float64(percentage)
        
        let seekTime = CMTimeMakeWithSeconds(seekTimeSeconds, preferredTimescale: Int32(NSEC_PER_SEC))
        
        player.seek(to: seekTime)
    }
    
    @IBOutlet weak var playerTimeSlider: UISlider!
    
    @IBOutlet weak var playerStartTimeLabel: UILabel!
    
    @IBOutlet weak var playerEndTimeLabel: UILabel!
    
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
