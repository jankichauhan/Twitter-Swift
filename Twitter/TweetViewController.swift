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
    
    var refreshControl: UIRefreshControl?
    var tableFooterView: UIView!
    var loadingView: UIActivityIndicatorView!
    var notificationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 228
        tableView.rowHeight = UITableViewAutomaticDimension
        
        addTableFooterView()
        loadData()
        pullToRefresh()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func loadData() {
        
        TwitterClient.sharedInstance.homeTimeLineWithParams(20, maxId: nil, completion: { (tweets, error) -> () in
            self.tweets = tweets!
            self.tableView.reloadData()
        })
        
        refreshControl?.endRefreshing()
    }
    
    func pullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl!.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
    }
    
    func addTableFooterView() {
        
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.superview!.frame), height: 50))
        println("width: \(tableFooterView.frame.width)")
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        loadingView.startAnimating()
        loadingView.center = tableFooterView.center
        tableFooterView.addSubview(loadingView)
        
        notificationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.superview!.frame), height: 50))
        notificationLabel.text = "No more tweets"
        notificationLabel.textAlignment = NSTextAlignment.Center
        notificationLabel.hidden = true
        tableFooterView.addSubview(notificationLabel)
        
        tableView.tableFooterView = tableFooterView
    }
    
    // MARK: Table view

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetViewCell", forIndexPath: indexPath) as! TweetViewCell
        cell.tweet = tweets[indexPath.row]
        
        cell.tweetTextLabel.sizeToFit()
        
        if indexPath.row == tweets.count - 1 {
            
            loadingView.startAnimating()
            notificationLabel.hidden = true
            getMoreData()
            
        } else {
            loadingView.stopAnimating()
        }

        
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
    
    func getMoreData() {
        
        if tweets.count > 0 {
            var maxId = ((tweets[tweets.count - 1].id)!.longLongValue - NSNumber(integer: 1).longLongValue) as NSNumber
            
            TwitterClient.sharedInstance.homeTimeLineWithParams(20, maxId: maxId, completion: { (tweets, error) -> () in
                var newTweets = tweets!
                for tweet in newTweets {
                    self.tweets.append(tweet)
                }
                self.tableView.reloadData()
                
                //println(error)
            })
        }
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
            
            if segue.identifier == "replySegue" {
                if let chosenTweetCell = sender!.superview!!.superview as? TweetViewCell {
                    var chosenTweet = chosenTweetCell.tweet
                    newTweetViewController.replyTweet = chosenTweet
                }
            }
        }

    
    }
    
    func addNewTweet(newTweet: Tweet) {
        
        tweets.insert(newTweet, atIndex: 0)
        tableView.reloadData()
        
        // go to top of table
        self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top)
    }


}
