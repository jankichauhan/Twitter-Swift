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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
