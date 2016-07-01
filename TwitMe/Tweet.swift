//
//  Tweet.swift
//  TwitMe
//
//  Created by Aanya Alwani on 6/27/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit

class Tweet: NSObject
{
    
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User
    var id: Int = 0
    var retweeted: Bool = false
    var favorited: Bool = false
    var in_reply_to_status_id: Int = 0
    
    init(dictionary: NSDictionary)
    {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        id = (dictionary["id"] as? Int) ?? 0
        retweeted = dictionary["retweeted"] as! Bool
        favorited = dictionary["favorited"] as! Bool
        in_reply_to_status_id = (dictionary["in_reply_to_status_id"] as? Int) ?? 0
        if let timeStampString = dictionary["created_at"] as? String
        {
        //print(timeStampString)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
        timestamp = formatter.dateFromString(timeStampString)
            
        }
        else
        {
            print("yy")
        }
    
    }
    
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]
    {
        var tweets = [Tweet]()
        for dictionary in dictionaries
        {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
            
        }
        
        
        
        return tweets
    }
    
    
    

}
