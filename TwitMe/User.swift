//
//  User.swift
//  TwitMe
//
//  Created by Aanya Alwani on 6/27/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit

class User: NSObject
{
    static var userDidLogoutNotiication = "userDidLogout"

    var name: NSString?
    var screenName: NSString?
    var profileURL: NSURL?
    var descriptions: NSString?
    var dictionary: NSDictionary?
    var followerCount: Int = 0
    var followingCount: Int = 0
    var statusCount: Int = 0
    var banner: NSURL?
    var id: Int = 0
    
    init(dictionary: NSDictionary)
    {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        let pu = dictionary["profile_image_url_https"] as? String
        let modifiedProfileUrlString = pu!.stringByReplacingOccurrencesOfString("_normal", withString: "_bigger")
        followerCount = dictionary["followers_count"] as! Int
       followingCount = dictionary["friends_count"] as! Int
        statusCount = dictionary["statuses_count"] as! Int
        id = dictionary["id"] as! Int
        
            profileURL = NSURL(string: modifiedProfileUrlString)
            
        
        let b = dictionary["profile_banner_url"] as? String
        if let b = b
        {
            banner = NSURL(string: b)
            
        }
        descriptions = dictionary["description"] as? String
    }
    
    static var _currentUser: User?

    class var currentUser: User?
    {
        get
        {
            if _currentUser == nil
            {
            let defaults = NSUserDefaults.standardUserDefaults()
            let userData = defaults.objectForKey("currentUserData") as? NSData

            if let userData = userData
            {
                let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
            
                _currentUser = User(dictionary: dictionary)
            }
            }
            
            return _currentUser
        
    }
    
        set(user)
        {
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user
            {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            }
            else{
                defaults.setObject(nil, forKey: "currentUserData")
            }
           
            defaults.synchronize()
        }
    }
    
    
    
    
    
    
    
    
}
