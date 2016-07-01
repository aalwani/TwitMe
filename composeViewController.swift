//
//  composeViewController.swift
//  TwitMe
//
//  Created by Aanya Alwani on 6/29/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit

class composeViewController: UIViewController
{
    var goToProf: Bool = true
    @IBOutlet weak var postView: UITextView!
    var user: User?
    var post: String?
    @IBOutlet weak var profPic: UIImageView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let url = user!.profileURL! as NSURL
        self.profPic.setImageWithURL(url)
        
        
    }
    

    @IBAction func tweetme(sender: AnyObject)
    {
        post = postView.text
        if(post?.characters.count == 0)
        {
            print("sorry bro")
        }
        else if(post?.characters.count <= 140)
        {
            TwitterClient.sharedInstance.tweet(post!, success: { (tweet: Tweet) in
                
            })
            { (error: NSError) in
                print(error.localizedDescription)
            }
            performSegueWithIdentifier("tweeted", sender: nil)
            print("sucess tweet")
            
            
        }

        
            else
        {
            print ("sorry bro")
        }
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "toNav")
    {
        let nav = segue.destinationViewController as! UINavigationController
        let tab = nav.topViewController as! UITabBarController
        if goToProf == true
        {
            
        let destVC = tab.viewControllers![1] as! ProfileViewController
//            destVC.loadData()
//            destVC.tableView.reloadData()
            tab.selectedIndex = 1
        }
            else
        {
            let destVC = tab.viewControllers![0] as! TweetsViewController
//            destVC.loadData()
//            destVC.tableView.reloadData()

        }
    }
        
        if (segue.identifier == "tweeted")
        {
            let nav = segue.destinationViewController as! UINavigationController
            let tab = nav.topViewController as! UITabBarController
            let destVC = tab.viewControllers![0] as! TweetsViewController
            
        }
    }
    
    
    
    
    
    
    
    
}
