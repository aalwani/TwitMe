//
//  TweetsViewController.swift
//  TwitMe
//
//  Created by Aanya Alwani on 6/27/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit
import AFNetworking


class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate
{
    var count: Int = 20
    
var userMe: User?
  var isMoreDataLoading = false
    let refreshControl = UIRefreshControl()
  var loadingMoreView: InfiniteScrollActivityView?
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        tableView.insertSubview(refreshControl, atIndex: 0)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.layoutIfNeeded()

        loadData()

        // Do any additional setup after loading the view.
    }

    
    
    func loadData()
    {
               
        TwitterClient.sharedInstance.homeTimeLine(count, success: { (tweets: [Tweet]) -> () in
                        self.tweets = tweets
            self.tableView.reloadData()
            
            //            for tweet in tweets
            //            {
            //                print(tweet.text)
            //            }
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
        
        
        TwitterClient.sharedInstance.currentAccount({ (user: User) -> () in
            
            self.userMe = user
            
            })
            
            
        { (error: NSError) in
            print(error.localizedDescription)
        }
       
        self.refreshControl.endRefreshing()
        self.loadingMoreView!.stopAnimating()
        tableView.reloadData()
        self.isMoreDataLoading = false
        
        


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        loadData()
        tableView.reloadData()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell",forIndexPath: indexPath) as! NewsCell
        cell.tweet = tweets[indexPath.row]
        cell.myButton.tag = indexPath.row
        
        return cell
    }

     
    
    
    
    func refreshControlAction(refreshControl: UIRefreshControl)
    {
        loadData()
       // self.tableView.reloadData()
//        refreshControl.endRefreshing()
        
        
    }
    
       
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (!isMoreDataLoading) {
            //            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
//
//            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
               
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView?.startAnimating()
                 count = count + 5
                loadData()
//                // ... Code to load more results ...
            }
        }
    }
    
    
     // When the user has scrolled past the threshold, start requesting
     
    @IBAction func pushed(sender: AnyObject)
    {
    }
    
    
    
    @IBAction func tweet(sender: AnyObject)
    {
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "toNav"
        {
            
        let button = sender as! UIButton
        let indexPath = button.tag
        let nav = segue.destinationViewController as! UINavigationController
        let tab = nav.topViewController as! UITabBarController
        let destVC = tab.viewControllers![1] as! ProfileViewController
        var tweeti = tweets[indexPath] as! Tweet
        destVC.user = tweeti.user
        destVC.x = true
        tab.selectedIndex = 1
        }
        else if segue.identifier == "toDet"
        {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let postt = tweets[(indexPath?.row)!] as! Tweet
            let detailVC = segue.destinationViewController as! DetailedViewController
            detailVC.tweet = postt

        }
        else
        {
            
            let destVC = segue.destinationViewController as! composeViewController
            destVC.user = userMe
            destVC.goToProf = false
            

            
        }
        
    }
    
    

}
