//
//  PlayerView.swift
//  Podcast
//
//  Created by Vjeko on 17/03/2019.
//  Copyright © 2019 Vjeko. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class PlayerView: UIView {
    
    var episode: Episode! {
        didSet {
            playerTitleLabel.text = episode.title
            miniPlayerTitleLabel.text = episode.title
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
    
    fileprivate func observePodcastTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self](time) in
            
            self?.playerStartTimeLabel.text = time.displayTimeString()
            
            let duration = self?.player.currentItem?.duration
            
            self?.playerEndTimeLabel.text = duration?.displayTimeString()
            
            self?.updateTimeSlider()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCommandCenterControl()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print("Audio session failed:", error)
        }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapToMaximize)))
        
        self.minPlayerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePlayerPanGesture)))
        
        observePodcastTime()
    }
    
    fileprivate func setupCommandCenterControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            self.player.play()
            return .success
            
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            self.player.pause()
            return .success
            
        }
    }
    
    @objc func handlePlayerPanGesture(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            let translation = gesture.translation(in: superview)
            self.transform = CGAffineTransform(translationX: 0, y: translation.y)
            
            self.minPlayerView.alpha = 1 + translation.y / 200
            self.maxPlayerView.alpha = -translation.y / 200
            
        } else if gesture.state == .ended {
            let translation = gesture.translation(in: superview)
            let velocity = gesture.velocity(in: superview)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = .identity
                
                if translation.y < -200 || velocity.y < -560 {
                    let mainTabBar = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
                    mainTabBar.maximizePlayerView(episode: nil)
                } else {
                    self.minPlayerView.alpha = 1
                    self.maxPlayerView.alpha = 0
                }
            })
        }
    }
    
    @objc func handleTapToMaximize() {
        let mainTabBar = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
        mainTabBar.maximizePlayerView(episode: nil)
    }
    
    static func initFromNib() -> PlayerView {
        return Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView
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
        //self.removeFromSuperview()
        let mainTabBar = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
        mainTabBar.minimizePlayerView()
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
            miniPlayerPlayPause.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayerPlayPause.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
    }
    
    @IBOutlet weak var miniPlayerImageView: UIImageView!
    
    @IBOutlet weak var miniPlayerTitleLabel: UILabel!
    
    @IBOutlet weak var miniPlayerPlayPause: UIButton! {
        didSet {
            miniPlayerPlayPause.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @IBAction func miniPlayerFastForwardAction(_ sender: Any) {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        
        let rewind = Float64(currentTime) + 15
        
        let seekTime = CMTimeMakeWithSeconds(rewind, preferredTimescale: Int32(NSEC_PER_SEC))
        
        player.seek(to: seekTime)
    }
    
    @IBOutlet weak var maxPlayerView: UIStackView!
    
    @IBOutlet weak var minPlayerView: UIView!
}
