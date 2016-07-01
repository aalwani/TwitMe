//
//  compose.swift
//  TwitMe
//
//  Created by Aanya Alwani on 6/28/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit
import AFNetworking

class compose: UIViewController
{
    @IBOutlet weak var profPic: UIImageView!
    var post: String?
    @IBOutlet weak var postView: UITextView!
    var user: User?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let url = user!.profileURL! as NSURL
        self.profPic.setImageWithURL(url)
        
        
    }

    @IBAction func tweetMe(sender: AnyObject)
    {
        
        post = postView.text
        
        
        
        
    }
}
