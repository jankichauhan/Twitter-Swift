//
//  TweetViewCell.swift
//  Twitter
//
//  Created by Jaimin Shah on 9/30/15.
//  Copyright (c) 2015 Janki Chauhan. All rights reserved.
//

import UIKit

class TweetViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favLabel: UILabel!
    @IBOutlet weak var imagesView: UIView!
    
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var imagesViewHeightConstraint: NSLayoutConstraint!

    
    var tweet: Tweet!{
        didSet{
            
            let imagesViewConstraints = [imagesViewHeightConstraint]

            let name = tweet.user?.name
            let screenName = tweet.user?.screenName
          
            profileImageView.setImageWithURL(tweet.user?.profileUrl)
            nameLabel.text = tweet.user?.name
            screenNameLabel.text = "@"+screenName!
            tweetTextLabel.text = tweet.text
            timeLabel.text = tweet.formatedDate()
            if let tweetCount = tweet.retweetCount {
                if tweetCount > 0 {
                    retweetLabel.text = "\(tweetCount)"
                } else {
                    retweetLabel.text = ""
                }
            }
            
            if let favCount = tweet.favCount {
                if favCount > 0 {
                    favLabel.text = "\(favCount)"
                } else {
                    favLabel.text = ""
                }
            }

            if tweet.mediaURL != nil {
               // contentImageView.setImageWithURL(tweet.mediaURL)
                var imagesViewTmp = NSBundle.mainBundle().loadNibNamed("ImagesView1", owner: self, options: nil).first! as! ImagesView1
                imagesViewTmp.images = tweet.images
                imagesViewTmp.imageView.setImageWithURL(tweet.mediaURL)
                imagesView.addSubview(imagesViewTmp)
                addConstraintImagesView(imagesViewTmp, imagesView: imagesView)
            }
            else {
                imagesViewHeightConstraint.constant = 0
            }
            
            if tweet.isRetweeted {
                retweetButton.setImage(UIImage(named: "RetweetOn"), forState: .Normal)
            } else {
                retweetButton.setImage(UIImage(named: "Retweet"), forState: .Normal)
            }
            
            if tweet.isFavorited {
                favButton.setImage(UIImage(named: "FavoriteOn"), forState: .Normal)
            } else {
                favButton.setImage(UIImage(named: "Favorite"), forState: .Normal)
            }
            

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        tweetTextLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 88
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tweetTextLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 88
        
    }
    
    override func prepareForReuse() {
        
//        topIconHeightConstraint.constant = 12
//        topIconWidthConstraint.constant = 12
//        topLabelHeightConstraint.constant = 14.5
        imagesViewHeightConstraint.constant = 115
    }
    
    @IBAction func onFavButton(sender: AnyObject) {
        
        if let selectedTweetCell = sender.superview?!.superview as? TweetViewCell {
            var selectedTweet = selectedTweetCell.tweet
            
            if selectedTweet.isFavorited {
                TwitterClient.sharedInstance.unfavoriteTweet(selectedTweet.id!, completion: { (response, error) -> () in
                    if response != nil {
                        selectedTweet.isFavorited = false
                        var favCount = selectedTweet.favCount! - 1
                        selectedTweet.favCount = favCount
                        if favCount != 0 {
                            self.favLabel.text = "\(favCount)"
                        } else {
                            self.favLabel.text = ""
                        }
                        
                        self.favButton.setImage(UIImage(named: "Favorite"), forState: .Normal)
                    }
                })
            } else {
                TwitterClient.sharedInstance.favoriteTweet(selectedTweet.id!, completion: { (response, error) -> () in
                    if response != nil {
                        selectedTweet.isFavorited = true
                        var favCount = selectedTweet.favCount! + 1
                        selectedTweet.favCount = favCount
                        self.favLabel.text = "\(favCount)"
                        self.favButton.setImage(UIImage(named: "FavoriteOn"), forState: .Normal)
                    }
                })
            }
        }
    }

    @IBAction func OnRetweetButton(sender: AnyObject) {
        
        if let selectedTweetCell = sender.superview?!.superview as? TweetViewCell {
            var selectedTweet = selectedTweetCell.tweet
           
            if selectedTweet.isRetweeted {
                TwitterClient.sharedInstance.getRetweetedId(selectedTweet.id!, completion: { (retweetedId, error) -> () in
                    if let myRetweetId = retweetedId {
                        TwitterClient.sharedInstance.unretweet(myRetweetId, completion: { (response, error) -> () in
                            if response != nil {
                                selectedTweet.isRetweeted = false
                                var retweetCount = selectedTweet.retweetCount! - 1
                                selectedTweet.retweetCount = retweetCount
                                if retweetCount != 0 {
                                    self.retweetLabel.text = "\(retweetCount)"
                                } else {
                                    self.retweetLabel.text = ""
                                }
                                
                                self.retweetButton.setImage(UIImage(named: "Retweet"), forState: .Normal)
                            }
                        })
                    }
                })
            } else {
                TwitterClient.sharedInstance.retweet(selectedTweet.id!, completion: { (response, error) -> () in
                    if response != nil {
                        selectedTweet.isRetweeted = true
                        var retweetCount = selectedTweet.retweetCount! + 1
                        selectedTweet.retweetCount = retweetCount
                        self.retweetLabel.text = "\(retweetCount)"
                        self.retweetButton.setImage(UIImage(named: "RetweetOn"), forState: .Normal)
                    }
                })
            }
        }

    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addConstraintImagesView(tmpView: UIView, imagesView: UIView) {
        
        tmpView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imagesView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var myConstraintTop =
        NSLayoutConstraint(item: tmpView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: imagesView,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0)
        
        var myConstraintBottom =
        NSLayoutConstraint(item: tmpView,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: imagesView,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: 0)
        
        var myConstraintTrailing =
        NSLayoutConstraint(item: tmpView,
            attribute: NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem: imagesView,
            attribute: NSLayoutAttribute.Trailing,
            multiplier: 1.0,
            constant: 0)
        
        var myConstraintLeading =
        NSLayoutConstraint(item: tmpView,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: imagesView,
            attribute: NSLayoutAttribute.Leading,
            multiplier: 1.0,
            constant: 0)
        
        imagesView.addConstraints([myConstraintBottom, myConstraintLeading, myConstraintTop, myConstraintTrailing])
        imagesView.updateConstraints()
    }


}
