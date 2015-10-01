//
//  TweetViewController.swift
//  Twitter
//
//  Created by Jaimin Shah on 9/29/15.
//  Copyright (c) 2015 Janki Chauhan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NewTweetViewControllerDelegate {

    var tweets: [Tweet]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
            
            self.tweets = tweets
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetViewCell", forIndexPath: indexPath) as! TweetViewCell
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil{
            return tweets!.count
        } else {
            return 0
        }
    }

    func newTweetViewController(newTweetViewController: NewTweetViewController, didUpdateTweet newTweet: Tweet) {
        addNewTweet(newTweet)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let navigationController = segue.destinationViewController as! UINavigationController
        
        if navigationController.topViewController is DetailViewController {
            
            let detailViewController = navigationController.topViewController as! DetailViewController
        
            var indexPath: AnyObject!
            indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        
            detailViewController.selectedTweet = tweets[indexPath!.row]
            detailViewController.indexPath = indexPath! as? NSIndexPath
        
        } else if navigationController.topViewController is NewTweetViewController {
            
            let newTweetViewController = navigationController.topViewController as! NewTweetViewController
            newTweetViewController.delegate = self
        }

    
    }
    
    func addNewTweet(newTweet: Tweet) {
        
        tweets.insert(newTweet, atIndex: 0)
        tableView.reloadData()
        
        // go to top of table
        self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top)
    }


}
