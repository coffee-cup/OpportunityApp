//
//  WelcomeViewController.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-16.
//  Copyright © 2016 FixCode. All rights reserved.
//

import UIKit

let WELCOMED = "welcomed"

class WelcomeViewController: UIViewController {

    let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toView = segue.destinationViewController
        toView.transitioningDelegate = transitionManager
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(true, forKey: WELCOMED)
    }
    
    @IBAction func signInButtonDidTouch(sender: AnyObject) {
        self.performSegueWithIdentifier("listSegue", sender: self)
    }
    
    @IBAction func signUpButtonDidTouch(sender: AnyObject) {
        self.performSegueWithIdentifier("listSegue", sender: self)
    }

    @IBAction func goButtonDidTouch(sender: AnyObject) {
        self.performSegueWithIdentifier("listSegue", sender: self)
    }
}
