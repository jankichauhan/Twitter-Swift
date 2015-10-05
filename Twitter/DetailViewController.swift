//
//  DetailViewController.swift
//  Twitter
//
//  Created by Jaimin Shah on 10/1/15.
//  Copyright (c) 2015 Janki Chauhan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screeNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favLabel: UILabel!
    
    var selectedTweet: Tweet?
    var indexPath: NSIndexPath?
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadDetails()
        // Do any additional setup after loading the view.
    }

    func loadDetails(){
        
        let screenName = selectedTweet?.user?.screenName
        
        profileImageView.setImageWithURL(selectedTweet?.user?.profileUrl)
        nameLabel.text = selectedTweet?.user?.name
        screeNameLabel.text = "@"+screenName!
        tweetTextLabel.text = selectedTweet?.text
        dateLabel.text = selectedTweet?.formatedDetailDate()
        if let tweetCount = selectedTweet?.retweetCount {
            if tweetCount > 0 {
                retweetLabel.text = "\(tweetCount) Retweets"
            } else {
                retweetLabel.text = "0 Retweets"
            }
        }
        
        if let favCount = selectedTweet?.favCount {
            if favCount > 0 {
                favLabel.text = "\(favCount) Favorites"
            } else {
                favLabel.text = "0 Favorites"
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)

    }

    @IBAction func onRetweetButton(sender: AnyObject) {
        
        if selectedTweet!.isRetweeted {
            TwitterClient.sharedInstance.getRetweetedId(selectedTweet!.id!, completion: { (retweetedId, error) -> () in
                if let myRetweetId = retweetedId {
                    TwitterClient.sharedInstance.unretweet(myRetweetId, completion: { (response, error) -> () in
                        if response != nil {
                            self.selectedTweet!.isRetweeted = false
                            var retweetCount = self.selectedTweet!.retweetCount! - 1
                            self.selectedTweet!.retweetCount = retweetCount
                            if retweetCount != 0 {
                                self.retweetLabel.text = "\(retweetCount) Retweets"
                            } else {
                                self.retweetLabel.text = "0 Retweets"
                            }
                            
                            self.retweetButton.setImage(UIImage(named: "Retweet"), forState: .Normal)
                        }
                    })
                }
            })
        } else {
            TwitterClient.sharedInstance.retweet(selectedTweet!.id!, completion: { (response, error) -> () in
                if response != nil {
                    self.selectedTweet!.isRetweeted = true
                    var retweetCount = self.selectedTweet!.retweetCount! + 1
                    self.selectedTweet!.retweetCount = retweetCount
                    self.retweetLabel.text = "\(retweetCount) Retweets"
                    self.retweetButton.setImage(UIImage(named: "RetweetOn"), forState: .Normal)
                }
            })
        }
    
    }

    @IBAction func onFavButton(sender: AnyObject) {
        
        if selectedTweet!.isFavorited {
            TwitterClient.sharedInstance.unfavoriteTweet(selectedTweet!.id!, completion: { (response, error) -> () in
                if response != nil {
                    self.selectedTweet!.isFavorited = false
                    var favCount = self.selectedTweet!.favCount! - 1
                    self.selectedTweet!.favCount = favCount
                    if favCount != 0 {
                        self.favLabel.text = "\(favCount) Favorites"
                    } else {
                        self.favLabel.text = "0 Favorites"
                    }
                    
                    self.favButton.setImage(UIImage(named: "Favorite"), forState: .Normal)
                }
            })
        } else {
            TwitterClient.sharedInstance.favoriteTweet(selectedTweet!.id!, completion: { (response, error) -> () in
                if response != nil {
                    self.selectedTweet!.isFavorited = true
                    var favCount = self.selectedTweet!.favCount! + 1
                    self.selectedTweet!.favCount = favCount
                    self.favLabel.text = "\(favCount) Favorites"
                    self.favButton.setImage(UIImage(named: "FavoriteOn"), forState: .Normal)
                }
            })
        }
    }

    
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

