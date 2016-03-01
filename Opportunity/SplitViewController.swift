//
//  SplitViewController.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-16.
//  Copyright © 2016 FixCode. All rights reserved.
//

import UIKit

class SplitViewController: UIViewController, OppListDelegate {

    @IBOutlet weak var oppListContainerView: UIView!
    @IBOutlet weak var settingsContainerView: UIView!
    
    @IBOutlet weak var activeTabView: UIView!
    @IBOutlet weak var createOppButton: UIBarButtonItem!
    
    var store: Store!
    
    let ANIMATION_DURATION = 0.175
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        store = Store(forClass: SplitViewController.classForCoder())
        store = Store.sharedInstance
        
        // Do any additional setup after loading the view.
        showList()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        store.getOpps()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showSettings() {
        settingsContainerView.hidden = false
        oppListContainerView.hidden = true
        
        UIView.animateWithDuration(ANIMATION_DURATION, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.activeTabView.transform = CGAffineTransformMakeTranslation(self.activeTabView.bounds.width, 0)
            }, completion: {finished in
        })
    }
    
    func showList() {
        oppListContainerView.hidden = false
        settingsContainerView.hidden = true
        
        UIView.animateWithDuration(ANIMATION_DURATION, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.activeTabView.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: {finished in
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toView = segue.destinationViewController
        toView.transitioningDelegate = self.transitioningDelegate
        
        if let addView = toView as? CreateOppViewController {
            if let _ = sender as? UIBarButtonItem {
                addView.creating = true
            } else if let editOpp = sender as? Opp {
                addView.opp = editOpp
            }
        }
        
        if let listView = toView as? OppsViewController {
            listView.delegate = self
        }
    }
    
    func selectCell(from: AnyObject?) {
        let sender = from == nil ? self : from!
        self.performSegueWithIdentifier("addSegue", sender: sender)
    }
    
    @IBAction func createOppButtonDidTouch(sender: AnyObject) {
        self.performSegueWithIdentifier("addSegue", sender: createOppButton)
    }
    
    @IBAction func oppsButtonDidTouch(sender: AnyObject) {
        showList()
    }

    @IBAction func settingsButtonDidTouch(sender: AnyObject) {
        showSettings()
    }
    
}
