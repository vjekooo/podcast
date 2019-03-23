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
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
        })
    }
    
   func maximizePlayerView(episode: Episode?) {
        
        maxTopAnchorConstraint.isActive = true
        maxTopAnchorConstraint.constant = 0
        minTopAnchorConstraint.isActive = false
    
        if (episode != nil) {
            playerView.episode = episode
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
        })
    }
    
    var maxTopAnchorConstraint: NSLayoutConstraint!
    var minTopAnchorConstraint: NSLayoutConstraint!
    
    fileprivate func setupPlayerView() {
        view.insertSubview(playerView, belowSubview: tabBar)
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        
        //playerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        maxTopAnchorConstraint = playerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maxTopAnchorConstraint.isActive = true
        
        minTopAnchorConstraint = playerView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -65)
        
        playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
