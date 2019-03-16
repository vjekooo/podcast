//
//  PodcastsSearchController.swift
//  Podcast
//
//  Created by Vjeko on 16/03/2019.
//  Copyright © 2019 Vjeko. All rights reserved.
//

import UIKit

class PodcastsSearchController: UITableViewController {
    
    let fakePodcasts = [
        Podcast(name: "Dobre banane", artistName: "Danko Bananko"),
        Podcast(name: "Eto me za po ure", artistName: "Niko Balić"),
        Podcast(name: "Bmw je sranje", artistName: "Koki")
    ]
    
    let cellId = "cellid"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register a cell for table view
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakePodcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let podcast = self.fakePodcasts[indexPath.row]
        
        cell.textLabel?.text = "\(podcast.name)\n\(podcast.artistName)"
        cell.textLabel?.numberOfLines = -1
        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        
        return cell
    }
}
