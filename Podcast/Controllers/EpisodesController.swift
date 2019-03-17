//
//  EpisodesController.swift
//  Podcast
//
//  Created by Vjeko on 16/03/2019.
//  Copyright © 2019 Vjeko. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
    
    var podcast: Podcast? {
        didSet {
            
            fetchEpisodes()
        }
    }
    
    fileprivate func fetchEpisodes() {
        guard let feedURL = podcast?.feedUrl else { return }
        guard let url = URL(string: feedURL) else { return}
        let parser = FeedParser(URL: url)
        
        parser?.parseAsync(result: { (result) in
            switch result {
            case let .rss(feed):
                
                var episodes = [Episode]()
                
                feed.items?.forEach({ (feedItem) in
                    let episode = Episode(feedItem: feedItem)
                    episodes.append(episode)
                })
                
                self.episodes = episodes
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case let .failure(error):
                print(error)
                break
            default:
                break
            }
        })
    }
    
    var episodes = [Episode]()
    
    fileprivate let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        // remove horizontal lines from table
        tableView.tableFooterView = UIView()
        
        // register a cell for table view
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        
        let episode = episodes[indexPath.row]
        cell.episode = episode
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
}
