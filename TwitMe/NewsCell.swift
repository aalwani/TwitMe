//
//  NewsCell.swift
//  TwitMe
//
//  Created by Aanya Alwani on 6/27/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell
{
    @IBOutlet weak var myButton: UIButton!
//    var retweeted: Bool = false
//    var favourited: Bool = false
    @IBOutlet weak var favouriteCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var post: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var faveButton: UIButton!
    let image0 = UIImage(named: "hb") as UIImage?
    let image1 = UIImage(named: "hr") as UIImage?
    let image2 = UIImage(named: "rb") as UIImage?
    let image3 = UIImage(named: "rg") as UIImage?
    var user: User?

    
    var tweet: Tweet? {
        didSet {
            // setup labels
            post.text = tweet!.text as! String
            post.sizeToFit()
            user = tweet!.user as User
            let url = user!.profileURL! as NSURL
            profilePic.setImageWithURL(url)
            name.text = user!.name as! String
            name.sizeToFit()
            screenName.text = "@" + (user!.screenName as! String)
            screenName.sizeToFit()
            retweetCount.text = String(tweet!.retweetCount)
            favouriteCount.text = String(tweet!.favoritesCount)
            if(!tweet!.retweeted)
            {
                retweetButton.setImage(image2, forState: .Normal)
            }
            else
            {
                retweetButton.setImage(image3, forState: .Normal)
            }
            if(!tweet!.favorited)
            {
                faveButton.setImage(image0, forState: .Normal)
            }
            else
            {
                faveButton.setImage(image1, forState: .Normal)
                
            }
            
            if let x = tweet!.timestamp as NSDate!
            {
                //print("There is something in timestamp")
                var str = NSDate.timeAgoSinceDate(x, numericDates: true)
                time.text = str
            }

        }
        
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
    
    
    
    
    
   
   
    
    
    @IBAction func retweeted(sender: AnyObject)
    {
        if(tweet!.retweeted)
        {
            
            TwitterClient.sharedInstance.unretweet(tweet!.id, success: { (tweet: Tweet) in
                
            }) { (error: NSError) in
                print(error.localizedDescription)
            }
            //retweeted = false
            print("sucess unret")
            retweetCount.text = String(tweet!.retweetCount - 1)
            retweetButton.setImage(image2, forState: .Normal)
        }
            
        else
        {
            
            TwitterClient.sharedInstance.retweet(tweet!.id, success: { (tweet: Tweet) in
                
            }) { (error: NSError) in
                print(error.localizedDescription)
            }
            print("sucess ret")
          //  retweeted = true
            retweetCount.text = String(tweet!.retweetCount + 1)
            retweetButton.setImage(image3, forState: .Normal)
            
        }

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
            favouriteCount.text = String(tweet!.favoritesCount - 1)
            faveButton.setImage(image0, forState: .Normal)
        }
            
        else
        {
            
            TwitterClient.sharedInstance.favourited(tweet!.id, success: { (tweet: Tweet) in
                
            }) { (error: NSError) in
                print(error.localizedDescription)
            }
            
            print("sucess fav")
            favouriteCount.text = String(tweet!.favoritesCount + 1)
            faveButton.setImage(image1, forState: .Normal)
        }

    }
    
   
    
    
    
     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
    
        let nav = segue.destinationViewController as! UINavigationController
        let tab = nav.topViewController as! UITabBarController
        let destVC = tab.viewControllers![1] as! ProfileViewController
        destVC.user = user
        tab.selectedIndex = 1
        
        
        
        
    }

    
    
    
    
    
}
