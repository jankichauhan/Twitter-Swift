//
//  Tweet.swift
//  Twitter
//
//  Created by Jaimin Shah on 9/29/15.
//  Copyright (c) 2015 Janki Chauhan. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweetCount: Int?
    var favCount: Int?
    var isRetweeted = false
    var isFavorited = false
    
    init(dictionary: NSDictionary){
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        retweetCount = dictionary["retweet_count"] as? Int!
        favCount = dictionary["favorite_count"] as? Int!
        
        isRetweeted = (dictionary["retweeted"] as? Bool!)!
        isFavorited = (dictionary["favorited"] as? Bool!)!
        
    }

    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
    func formatedDate() -> String {
        
        let min = 60
        let hour = min * 60
        let day = hour * 24
        let week = day * 7
        
        let elapsedTime = NSDate().timeIntervalSinceDate(createdAt!)
        let duration = Int(elapsedTime)
        
        if duration < min {
            return "\(duration)s"
        } else if duration >= min && duration < hour {
            let minDur = duration / min
            return "\(minDur)m"
        } else if duration >= hour && duration < day {
            let hourDur = duration / hour
            return "\(hourDur)h"
        } else if duration >= day && duration < week {
            let dayDur = duration / day
            return "\(dayDur)d"
        } else {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "M/d/yy"
            var dateString = dateFormatter.stringFromDate(createdAt!)
            
            return dateString
        }
    }
    
    func formatedDetailDate() -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        var dateString = dateFormatter.stringFromDate(createdAt!)
        
        return dateString
    }
    
}
