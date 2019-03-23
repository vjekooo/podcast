//
//  MainTabBarController.swift
//  Podcast
//
//  Created by Vjeko on 16/03/2019.
//  Copyright © 2019 Vjeko. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().prefersLargeTitles = true
        
        tabBar.tintColor = .purple
        
        viewControllers = [
            generateNavigationController(with: ViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
            generateNavigationController(with: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search") ),
            generateNavigationController(with: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
        
        setupPlayerView()
        
    }
    
    @objc func minimizePlayerView() {
        
        maxTopAnchorConstraint.isActive = false
        minTopAnchorConstraint.isActive = true
        
        bottomAnchorConstraint.constant = view.frame.height
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            
            self.playerView.maxPlayerView.alpha = 0
            self.playerView.minPlayerView.alpha = 1
        })
    }
    
   func maximizePlayerView(episode: Episode?) {
        
        maxTopAnchorConstraint.isActive = true
        maxTopAnchorConstraint.constant = 0
        minTopAnchorConstraint.isActive = false
    
        bottomAnchorConstraint.constant = 0
    
        if (episode != nil) {
            playerView.episode = episode
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            self.playerView.maxPlayerView.alpha = 1
            self.playerView.minPlayerView.alpha = 0
            
        })
    }
    
    var maxTopAnchorConstraint: NSLayoutConstraint!
    var minTopAnchorConstraint: NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!
    
    fileprivate func setupPlayerView() {
        view.insertSubview(playerView, belowSubview: tabBar)
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        
        //playerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        maxTopAnchorConstraint = playerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maxTopAnchorConstraint.isActive = true
        
        minTopAnchorConstraint = playerView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -65)
        
        bottomAnchorConstraint = playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    let playerView = PlayerView.initFromNib()
    
    //MARK:- Helper functions
    
    fileprivate func generateNavigationController(
        with rootViewController: UIViewController,
        title: String,
        image: UIImage) -> UIViewController
    {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        return navController
    }
}
