//
//  APIService.swift
//  Podcast
//
//  Created by Vjeko on 16/03/2019.
//  Copyright © 2019 Vjeko. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    // singleton
    static let shared = APIService()
    
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        
        let url = "https://itunes.apple.com/search"
        
        let parameters = ["term": searchText, "media": "podcast"]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to fetch data", err)
                return
            }
            guard let data = dataResponse.data else {return}
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                
                completionHandler(searchResult.results)
                
            } catch let decodeErr {
                print("Failed to decode", decodeErr)
            }
        }
    }
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        
        guard let url = URL(string: feedUrl) else { return}
        
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            
            parser?.parseAsync(result: { (result) in
                
                if let err = result.error {
                    print("Failed to parse episode data", err)
                    return
                }
                
                guard let feed = result.rssFeed else { return }
                
                var episodes = [Episode]()
                
                feed.items?.forEach({ (feedItem) in
                    let episode = Episode(feedItem: feedItem)
                    episodes.append(episode)
                })
                
                completionHandler(episodes)
            })
        }
        
    }
    
    struct SearchResults: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
}
