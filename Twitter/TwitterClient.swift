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
   
    class var sharedInstance:TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSceret)
        }
        
        return Static.instance
    }
}
