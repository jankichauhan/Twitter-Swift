//
//  TweetViewController.swift
//  Twitter
//
//  Created by Jaimin Shah on 9/29/15.
//  Copyright (c) 2015 Janki Chauhan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
            
            self.tweets = tweets
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        
        User.currentUser?.logout()
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