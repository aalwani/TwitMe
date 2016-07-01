//
//  MentionsViewController.swift
//  TwitMe
//
//  Created by Aanya Alwani on 6/27/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit
import AFNetworking

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var replies: [Tweet]?
    @IBOutlet weak var TABLEvIEW: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        TABLEvIEW.insertSubview(refreshControl, atIndex: 0)
        TABLEvIEW.delegate = self
        TABLEvIEW.dataSource = self
        self.TABLEvIEW.estimatedRowHeight = 80
        self.TABLEvIEW.rowHeight = UITableViewAutomaticDimension
        self.TABLEvIEW.layoutIfNeeded()
        loadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let replies = replies
        {
            return replies.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MentionsCell", forIndexPath: indexPath) as! MentionsCell
        let tweet = replies![indexPath.row] as! Tweet
        cell.post.text = tweet.text as! String
        let user = tweet.user as! User
        cell.name.text = user.name as! String
        let url = user.profileURL! as NSURL
        cell.PICTURE.setImageWithURL(url)
        cell.screenname.text = "@" + (user.screenName as! String)
        if let x = tweet.timestamp as NSDate!
        {
            var str = NSDate.timeAgoSinceDate(x, numericDates: true)
            cell.timestamp.text = str
        }

        return cell
    }
    
    func loadData()
    {
        TwitterClient.sharedInstance.mentions({ (tweets: [Tweet]) -> () in
        self.replies = tweets
        self.TABLEvIEW.reloadData()
    
    
        }) { (error: NSError) in
        print(error.localizedDescription)
        }
            self.TABLEvIEW.reloadData()
    

    
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl)
    {
        loadData()
        self.TABLEvIEW.reloadData()
        refreshControl.endRefreshing()
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
