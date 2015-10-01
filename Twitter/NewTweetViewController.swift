//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Jaimin Shah on 10/1/15.
//  Copyright (c) 2015 Janki Chauhan. All rights reserved.
//

import UIKit

@objc protocol NewTweetViewControllerDelegate {
    optional func newTweetViewController(newTweetViewController: NewTweetViewController, didUpdateTweet newTweet: Tweet)
}

class NewTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!

    var limit = 140
    
    var replyTweet: Tweet?
    
    weak var delegate: NewTweetViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
      
        tweetTextView.delegate = self
        tweetTextView.becomeFirstResponder()
        tweetButton.layer.cornerRadius = 5
        tweetButton.alpha = 0.7
        tweetButton.enabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(sender: AnyObject) {
  
        TwitterClient.sharedInstance.updateTweet(tweetTextView.text, completion: { (tweet, error) -> () in
            
            var newTweet = tweet
            
            if let newTweet = newTweet {
                println("get new tweet")
                self.delegate?.newTweetViewController?(self, didUpdateTweet: newTweet)
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }

    @IBAction func onCancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if tweetTextView.text == "What's happening?" {
                moveCursorToStart(tweetTextView)
                limit = 140
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        
        if tweetTextView.text.isEmpty {
            tweetTextView.text = "What's happening?"
            tweetButton.alpha = 0.7
            tweetButton.enabled = false
            moveCursorToStart(tweetTextView)
            limit = 140
            charCountLabel.text = "\(limit)"
            
        } else {
            var firstCharacter = Array(tweetTextView.text)[0]
            if tweetTextView.text == "\(firstCharacter)What's happening?" {
                tweetTextView.text = "\(firstCharacter)"
            }
            
            if count(tweetTextView.text.utf8) > 140 {
                tweetTextView.text = tweetTextView.text[0..<140]
            }
            
            
            tweetTextView.textColor = UIColor.blackColor()
            tweetButton.alpha = 1
            tweetButton.enabled = true
            limit = 140 - count(tweetTextView.text.utf8)
            charCountLabel.text = "\(limit)"
        }
    }
    
    func moveCursorToStart(aTextView: UITextView) {
        
        dispatch_async(dispatch_get_main_queue(), {
            aTextView.selectedRange = NSMakeRange(0, 0);
        })
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

extension String {
    
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    
    func replace(target: String, withString: String) -> String {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
}

