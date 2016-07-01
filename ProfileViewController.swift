//
//  ProfileViewController.swift
//  TwitMe
//
//  Created by Aanya Alwani on 6/27/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var banners: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var x: Bool = false
    var user: User?
    var userMe: User?
    var tweets: [Tweet]?
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var tagline: UILabel!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        loadData()
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        // Do any additional setup after loading the view.
    }
    @IBAction func compose(sender: AnyObject)
    {
    }

    @IBOutlet weak var tweetCount: UILabel!
    func loadData()
    {
        TwitterClient.sharedInstance.currentAccount({ (user: User) -> () in
            if self.x
            {
              
            }
            else
            {
                self.user = user
            }
            self.userMe = user
            self.loadData2()
            self.loadData3()
            //print("1")
            
                
            
            self.nameLabel.text = self.user?.name as! String
            self.followersLabel.text = "Followers: " + (String(self.user!.followerCount))
           self.followingLabel.text = "Following: " + (String(self.user!.followingCount))
            self.screenNameLabel.text = "@" + (self.user!.screenName as! String)
            let url = self.user!.profileURL! as NSURL
            self.profilePic.setImageWithURL(url)
            self.tagline.text = self.user!.descriptions as! String
            self.tweetCount.text = "Tweets: " + (String(self.user!.statusCount))
            
            
            
            })
     
            
        { (error: NSError) in
            print(error.localizedDescription)
        }
        //        self.isMoreDataLoading = false
        //        self.loadingMoreView!.stopAnimating()
        
        
       
  
    }
  
    
    func loadData2()
    {
        TwitterClient.sharedInstance.otherAccount((self.user?.screenName as! String), success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            //            self.tableView.reloadData()
            
            self.tableView.reloadData()
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
        //        self.isMoreDataLoading = false
        //        self.loadingMoreView!.stopAnimating()
        // tableView.reloadData()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogOut(sender: AnyObject)
    {
         TwitterClient.sharedInstance.logout()

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
         if segue.identifier == "toDet"
        {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let postt = tweets![(indexPath?.row)!] as! Tweet
            let detailVC = segue.destinationViewController as! DetailedViewController
            detailVC.tweet = postt
            
        }
        else
         {
            
        let destVC = segue.destinationViewController as! composeViewController
        destVC.user = self.userMe
        destVC.goToProf = true
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets
        {
            return tweets.count
        }
        else
        {
           return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileCell
        cell.tweet = tweets![indexPath.row] as! Tweet
        
        return cell
        
        
        

    }
    
    
    
    
    func refreshControlAction(refreshControl: UIRefreshControl)
    {
        loadData()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        
        
    }
    
    
    func loadData3()
    {
        TwitterClient.sharedInstance.banner((user?.screenName)! as String, id: (user?.id)!, success: { (user1: User) -> ()  in
           if let b = self.user!.banner
           {
            
            let url = b as! NSURL
            self.banners.setImageWithURL(url)
            }
            else
           {
            self.banners.image = UIImage(named: "Blue-Wallpaper-1.jpg")
            }
           
            })
        { (error: NSError) in
            print(error.localizedDescription)
        }
        
    }
    
    
    
    
    
    
    

}
