//
//  DetailedViewController.swift
//  TwitMe
//
//  Created by Aanya Alwani on 6/28/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
     let refreshControl = UIRefreshControl()
    @IBOutlet weak var reply: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var replies: [Tweet] = []
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var Fbutton: UIButton!
    @IBOutlet weak var rbutton: UIButton!
    var tweet: Tweet?
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var screenName: UILabel!
    
    @IBOutlet weak var post: UILabel!
    let image0 = UIImage(named: "hb") as UIImage?
    let image1 = UIImage(named: "hr") as UIImage?
    let image2 = UIImage(named: "rb") as UIImage?
    let image3 = UIImage(named: "rg") as UIImage?

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
         refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
       tableView.insertSubview(refreshControl, atIndex: 0)
        post.text = tweet!.text as! String
        
        let user = tweet!.user as User
        let url = user.profileURL! as NSURL
        
        if(!tweet!.retweeted)
        {
            rbutton.setImage(image2, forState: .Normal)
        }
        else
        {
            rbutton.setImage(image3, forState: .Normal)
        }
        if(!tweet!.favorited)
        {
            Fbutton.setImage(image0, forState: .Normal)
        }
        else
        {
            Fbutton.setImage(image1, forState: .Normal)
            
        }
        

        profilePic.setImageWithURL(url)
        name.text = user.name as! String
        screenName.text = "@" + (user.screenName as! String)
        screenName.sizeToFit()
        tableView.delegate = self
        tableView.dataSource = self
        let s: String = String(tweet!.retweetCount)
        let p: String = String(tweet!.favoritesCount)
        label.text = "\(s) Retweets    \(p) Favorites"
       // reply.hidden = true
         loadData()
        loadData2()

    }
    
    func loadData2()
    {
        TwitterClient.sharedInstance.mentions({ (tweets: [Tweet]) -> () in
           
            for tweeti in tweets
            {
                 var xx: Bool = false
                for x in self.replies
                {
                    if x.text as! String == tweeti.text as! String
                    {
                        xx = true
                    }
                }
                if (tweeti.in_reply_to_status_id == (self.tweet!.id as! Int) && xx == false)
                {
                    
                    self.replies.append(tweeti as! Tweet)
                }
            }
            
            self.tableView.reloadData()
            
            
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
        

        
    }
    
    
    
    func loadData()
    {
        print(replies)
        TwitterClient.sharedInstance.getReplies(tweet?.user.screenName as! String, success: { (tweets:[Tweet]) -> () in
            print(tweets)
            for tweeti in tweets
            {
                var xx: Bool = false
                for x in self.replies
                {
                    if x.text as! String == tweeti.text as! String
                    {
                        xx = true
                    }
                }
                if (tweeti.in_reply_to_status_id == (self.tweet!.id as! Int) && xx == false)
                {
                    
                    self.replies.append(tweeti as! Tweet)
                }
            }
            
            self.tableView.reloadData()

        })
    
    { (error: NSError) in
    print(error.localizedDescription)
    }
    self.tableView.reloadData()
    
    
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func reply(sender: AnyObject)
    {
        let user = tweet!.user as User
       // reply.hidden = false
        let x = "@\(user.screenName as! String) " + (reply.text! as String)
        reply.text! = ""
        if x.characters.count != 0
        {
            
        TwitterClient.sharedInstance.reply(x, id: tweet!.id, success: { (tweet: Tweet) in
            
            })
        { (error: NSError) in
            print(error.localizedDescription)
        }
        
        loadData()
            loadData2()
        self.tableView.reloadData()
      //  print(replies)
      //  reply.hidden = true

        }
        
    }
    
    
    @IBAction func retweeted(sender: AnyObject)
    {
        
        if(tweet!.retweeted)
        {
            
            TwitterClient.sharedInstance.unretweet(tweet!.id, success: { (tweet: Tweet) in
                
            }) { (error: NSError) in
                print(error.localizedDescription)
            }
           // retweeted = false
            print("sucess unret")
          //  retweetCount.text = String(tweet!.retweetCount)
            let ss: String = String(tweet!.retweetCount - 1)
            let p: String = String(tweet!.favoritesCount)
            label.text = "\(ss) Retweets    \(p) Favorites"
            rbutton.setImage(image2, forState: .Normal)
        }
            
        else
        {
            
            TwitterClient.sharedInstance.retweet(tweet!.id, success: { (tweet: Tweet) in
                
            }) { (error: NSError) in
                print(error.localizedDescription)
            }
            print("sucess ret")
           // retweeted = true
          //  retweetCount.text = String(tweet!.retweetCount)
            let ss: String = String(tweet!.retweetCount + 1)
            let ps: String = String(tweet!.favoritesCount)
            label.text = "\(ss) Retweets    \(ps) Favorites"
            rbutton.setImage(image3, forState: .Normal)
            
        }
        
        
    }
    
    
    func refreshControlAction(refreshControl: UIRefreshControl)
    {
        loadData()
        loadData2()
         self.tableView.reloadData()
                refreshControl.endRefreshing()
        
        
    }

    
    @IBAction func faved(sender: AnyObject)
    {
        
        if(tweet!.favorited)
        {
            
            TwitterClient.sharedInstance.unfavourite(tweet!.id, success: { (tweet: Tweet) in
                
            }) { (error: NSError) in
                print(error.localizedDescription)
            }
            print("sucess unfav")
            //favourited = false
            //favouriteCount.text = String(tweet!.favoritesCount)
            let ss: String = String(tweet!.retweetCount)
            let pp: String = String(tweet!.favoritesCount - 1 )
            label.text = "\(ss) Retweets    \(pp) Favorites"
            Fbutton.setImage(image0, forState: .Normal)
        }
            
        else
        {
            
            TwitterClient.sharedInstance.favourited(tweet!.id, success: { (tweet: Tweet) in
                
            }) { (error: NSError) in
                print(error.localizedDescription)
            }
            
            print("sucess fav")
           // favourited = true
            //favouriteCount.text = String(tweet!.favoritesCount)
            let s: String = String(tweet!.retweetCount)
            let p: String = String(tweet!.favoritesCount + 1)
            label.text = "\(s) Retweets    \(p) Favorites"
            Fbutton.setImage(image1, forState: .Normal)
        }


    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return replies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReplyCell", forIndexPath: indexPath) as! ReplyCell
        let reply = replies[indexPath.row] as! Tweet
        let user = reply.user as! User
        cell.name.text = user.name as! String
        cell.screenName.text = "@" + (user.screenName as! String)
        cell.reply.text = reply.text as! String
        let url = user.profileURL! as NSURL
        cell.picture.setImageWithURL(url)
        return cell
        
    }
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        loadData()
        loadData2()
        self.tableView.reloadData()
    }
   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
//    let button = sender as! UIButton
//    let indexPath = button.tag
    let nav = segue.destinationViewController as! UINavigationController
    let tab = nav.topViewController as! UITabBarController
    let destVC = tab.viewControllers![1] as! ProfileViewController
    destVC.user = self.tweet!.user
    destVC.x = true
    tab.selectedIndex = 1
    }
   
}
