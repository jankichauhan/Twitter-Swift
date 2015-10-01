//
//  TwitterClient.swift
//  Twitter
//
//  Created by Jaimin Shah on 9/29/15.
//  Copyright (c) 2015 Janki Chauhan. All rights reserved.
//

import UIKit

let twitterConsumerKey="wXxFcnARVV0p9x2S7O39YExSG"
let twitterConsumerSceret="yO10qCmQtQziUrUlgVM8jK1p9TMA1AK2sDHNNXtc5QdRxR3tUo"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
   
    class var sharedInstance:TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSceret)
        }
        
        return Static.instance
    }
    
    func loginCompletion(completion: (user: User?, error: NSError?) -> ()){
        
        loginCompletion = completion
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
            println("Got the request token \(requestToken)")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            
            }) { (error: NSError!) -> Void in
                
                println("Error in getting request token")
                self.loginCompletion?(user: nil, error: error)
        }
        
    }
    
    func homeTimeLineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
     
        GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            // println(" user timeline \(response)")
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                
                println("error while fecthing user timeline")
                completion(tweets: nil , error: error)

        })

    }
    
    func openURL(url: NSURL){
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString:
            url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
                
                println("Got access token")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                    
                    // println(" user \(response)")
                    var user = User(dictionary: response as! NSDictionary)
                    println(" user name \(user.name)")
                    User.currentUser = user
                    self.loginCompletion?(user: user, error: nil)
                    
                    }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        
                        println("error while fetching user")
                        self.loginCompletion?(user: nil, error: error)
                })
                
            }) { (error: NSError!) -> Void in
                
                println("Error while getting access token")
                self.loginCompletion?(user: nil, error: error)
        }

    }
    
    func updateTweet(text: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        var params = [String : AnyObject]()
        params["status"] = text
        
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            var newTweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: newTweet, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
               
                println("error adding new tweet")
                completion(tweet: nil, error: error)
        })
    }
}
