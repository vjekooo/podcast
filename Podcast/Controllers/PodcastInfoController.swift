//
//  PodcastInfoController.swift
//  Podcast
//
//  Created by Vjeko on 16/03/2019.
//  Copyright © 2019 Vjeko. All rights reserved.
//

import UIKit
import FeedKit

class PodcastInfoController: UITableViewController {
    
    var podcast: Podcast? {
        didSet {
            //navigationItem.title = podcast?.trackName
            
            fetchPodcastInfo()
        }
    }
    
    fileprivate func fetchPodcastInfo() {
        guard let feedURL = podcast?.feedUrl else { return }
        guard let url = URL(string: feedURL) else { return}
        let parser = FeedParser(URL: url)
        
        parser?.parseAsync(result: { (result) in
            switch result {
            case let .rss(feed):
                
                let podcast = [PodcastInfo(feed: feed)]
                
                self.podcastInfo = podcast

                self.podcastTitle = feed.title ?? ""
                self.podcastDescription = feed.description ?? ""
                self.podcastImage = feed.image?.url ?? ""
                
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
    
    var podcastTitle: String?
    var podcastDescription: String?
    var podcastImage: String?
    
    var podcastInfo = [PodcastInfo]()
    
    fileprivate let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        // remove horizontal lines from table
        tableView.tableFooterView = UIView()
        
        // register a cell for table view
        let nib = UINib(nibName: "PodcastInfoCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodesController = EpisodesController()
        episodesController.podcast = podcast
        navigationController?.pushViewController(episodesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PodcastInfoCell
        
        //let podcastInfo = self.podcastInfo[0]
        //cell.podcastInfo = podcastInfo
        
        let url = URL(string: podcastImage ?? "")
        
        cell.podcastTitleLabel.text = podcastTitle
        cell.podcastDescriptionText.text = podcastDescription
        cell.podcastImageView.sd_setImage(with: url, completed: nil)
        
        return cell
    }
    
}
