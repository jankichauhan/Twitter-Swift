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
    
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favImageView: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favLabel: UILabel!
    
    var tweet: Tweet!{
        didSet{
            
            let name = tweet.user?.name
            let screenName = tweet.user?.screenName
            
//            var myMutableString = NSMutableAttributedString()
//            myMutableString = NSMutableAttributedString(
//                string: screenName!,
//                attributes: [NSFontAttributeName:UIFont(
//                    name: "Georgia",
//                    size: 18.0)!])
//            myMutableString.addAttribute(NSForegroundColorAttributeName,
//                value: UIColor.grayColor(),
//                range: NSRange(
//                    location:0,
//                    length:myMutableString.length))
//            let cScreenName = myMutableString.string
//            
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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
