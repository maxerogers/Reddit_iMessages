//
//  RedditAPI.swift
//  Reddit_iMessage
//
//  Created by Max Rogers on 8/22/16.
//  Copyright © 2016 Max Rogers. All rights reserved.
//

import UIKit

struct Post {
    var title: String?
    var score: NSNumber?
    var url: String?
    var domain: String?
}

class RedditAPI {
    static let REDDIT_API_URL = "https://www.reddit.com/r/programming.json"
    
    class func getTopStories(_ completionBlock: @escaping (_ results: [Post]) -> Void ) {
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        defaultSession.dataTask(with: URL(string: REDDIT_API_URL)!) { (data, response, error) in
            guard let sData = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: sData, options: .mutableContainers) as? NSDictionary
                guard let wrapper = json?["data"] as? NSDictionary,  let children = wrapper["children"] as? NSArray
                    else { return }
                var posts =  [Post]()
                for child in children {
                    guard let childDict = child as? NSDictionary, let post = childDict["data"] as? NSDictionary else { continue }
                    var redditObject = Post()
                    if let score = post["score"] as? NSNumber {
                        redditObject.score = score
                    }
                    if let title = post["title"] as? NSString {
                        redditObject.title = String(title)
                    }
                    if let url = post["url"] as? NSString {
                        redditObject.url = String(url)
                    }
                    if let domain = post["domain"] as? NSString {
                        redditObject.domain = String(domain)
                    }
                    posts.append(redditObject)
                }
                completionBlock(posts)
            } catch {
                print(error)
            }
        }.resume()
    }
}
