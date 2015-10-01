//
//  LoginViewController.swift
//  Twitter
//
//  Created by Jaimin Shah on 10/1/15.
//  Copyright (c) 2015 Janki Chauhan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    @IBAction func onLogin(sender: AnyObject) {
            
        TwitterClient.sharedInstance.loginCompletion() {
            (user: User?, error: NSError?) in
            if user != nil{
            
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                // Handle error
            }
        }
    }
        
}
