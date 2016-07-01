//
//  TwitterClient.swift
//  TwitMe
//
//  Created by Aanya Alwani on 6/27/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import AFNetworking

class TwitterClient: BDBOAuth1SessionManager
{
        
        static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "QIuKlncLW4CDPHhE3yozgJnWp", consumerSecret: "eDsSP6kYKt3RhsdaFj5OJQKgZOwUTqdmze1uWKxqFH7KkWQGUu")
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ())
    {
    
        GET("1.1/account/verify_credentials.json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            
            let userDict = response as! NSDictionary
            let user = User(dictionary: userDict)
            success(user)
//            print("name: \(user.name)")
//            print("screenname: \(user.screenName)")
//            print("description: \(user.descriptions)")
//            print("profileURL: \(user.profileURL)")
            
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print(error.localizedDescription)
                failure(error)
        })

    }
    
    func otherAccount(screenname: String, success: ([Tweet]) -> (), failure: (NSError) -> ())
    {
        
        GET("1.1/statuses/user_timeline.json?screen_name=\(screenname)", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
    }
    
    func banner(name: String, id: Int, success: (User) -> (), failure: (NSError) -> ())
    {
        let parameters = ["screenname" : name, "id" : id]
        GET("1.1/users/show.json", parameters: parameters, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            var dict = response as! NSDictionary
            var user = User(dictionary: dict)
            success(user)
        
    },
            failure: { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
    })
    


    
    
    
    
    }




    

    
    func homeTimeLine(count: Int, success: ([Tweet]) -> (), failure: (NSError) -> ()) // fetches home timeline
    {
        let parameters = ["count" : count]
        
        GET("1.1/statuses/home_timeline.json", parameters: parameters, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
    
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
    }
    
    func login(success: () -> (), failure: (NSError) -> ())
    {
        loginSuccess = success
        loginFailure = failure
        deauthorize()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitme://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
        }) { (error: NSError!) -> Void in
            print (error.localizedDescription)
            self.loginFailure?(error)
        }
        

    }
    
    
    
    func retweet(id: Int, success: (Tweet) -> () , failure: (NSError) -> ())
    {
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("success retweet")
        },
             failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })

            
    }
    
    func unretweet(id: Int, success: (Tweet) -> () , failure: (NSError) -> ())
        {
        
        POST("1.1/statuses/unretweet/\(id).json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("success unretweet")
        },
             failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
            
            
    }

    
    func favourited(id: Int, success: (Tweet) -> () , failure: (NSError) -> ())
    {
        POST("1.1/favorites/create.json?id=\(id)", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("success fav")
            },
             failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })

    }
    
    
    func unfavourite(id: Int, success: (Tweet) -> () , failure: (NSError) -> ())
    {
        POST("1.1/favorites/destroy.json?id=\(id)", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("success fav")
            },
             failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
        
    }

    
    func tweet(status: String, success: (Tweet) -> () , failure: (NSError) -> ())
    {
        let parameters = ["status" : status]
        
        POST("1.1/statuses/update.json", parameters: parameters, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("success tweet")
            },
             failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
        

    }
    
    func reply(status: String, id: Int, success: (Tweet) -> () , failure: (NSError) -> ())
    {
        let parameters = ["status" : status, "in_reply_to_status_id" : id]
        
        POST("1.1/statuses/update.json", parameters: parameters, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            },
             failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })

    }
    
    
    
    
    
    
    
    
    
    
    
    func mentions(success: ([Tweet]) -> (), failure: (NSError) -> ())
    {
        GET("1.1/statuses/mentions_timeline.json",parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            let mentions = Tweet.tweetsWithArray(dictionaries)
            success(mentions)
            

            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print(error.localizedDescription)
                failure(error)
        })
        

    }
    
    func handleOpenUrl(url: NSURL)
    {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) in
                    self.loginFailure?(error)
            })
            
            
        }) { (error: NSError!) in
            print(error.localizedDescription)
            self.loginFailure?(error)
        }

    }
    
     func logout()
    {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotiication, object: nil)
    }
    
}
