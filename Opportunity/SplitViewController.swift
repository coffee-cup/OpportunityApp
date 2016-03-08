//
//  SplitViewController.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-16.
//  Copyright © 2016 FixCode. All rights reserved.
//

import UIKit
import PermissionScope

class SplitViewController: UIViewController, OppListDelegate {

    @IBOutlet weak var oppListContainerView: UIView!
    @IBOutlet weak var settingsContainerView: UIView!
    
    @IBOutlet weak var activeTabView: UIView!
    @IBOutlet weak var createOppButton: UIBarButtonItem!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    var store: Store!
    let pscope = PermissionScope()
    
    let ANIMATION_DURATION = 0.175
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        store = Store(forClass: SplitViewController.classForCoder())
        store = Store.sharedInstance
        
        setupPermissions()
        
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
    
    func setupPermissions() {
        // Set up permissions
        pscope.addPermission(NotificationsPermission(notificationCategories: nil),
            message: "We use this to send you Opp notifications")
        pscope.addPermission(LocationAlwaysPermission(),
            message: "We use this to trigger Opps based on your location")
        
        pscope.closeButtonTextColor = UIColor.redColor()
        pscope.permissionButtonTextColor = purpleColour
        pscope.permissionButtonBorderColor = purpleColour
        pscope.authorizedButtonColor = greenColour
        
        // Show dialog with callbacks
        pscope.show({ finished, results in
            //            print("got results \(results)")
            }, cancelled: { (results) -> Void in
                //                print("thing was cancelled")
        })
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
    
    @IBAction func sortButtonDidTouch(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: "Sort Options", preferredStyle: .ActionSheet)
        
        
        let nc = NSNotificationCenter.defaultCenter()
        let sortName = UIAlertAction(title: "Sort by Nane", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            nc.postNotificationName("SortOpps", object: nil, userInfo: ["sortBy": "Name"])
            NSUserDefaults.standardUserDefaults().setValue("Name", forKey: "sortDesc")
        })
        let sortColour = UIAlertAction(title: "Sort by Colour", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            nc.postNotificationName("SortOpps", object: nil, userInfo: ["sortBy": "Colour"])
            NSUserDefaults.standardUserDefaults().setValue("Colour", forKey: "sortDesc")
        })
        let sortDisabled = UIAlertAction(title: "Sort by Disabled", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            nc.postNotificationName("SortOpps", object: nil, userInfo: ["sortBy": "Disabled"])
            NSUserDefaults.standardUserDefaults().setValue("Disabled", forKey: "sortDesc")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        optionMenu.addAction(sortName)
        optionMenu.addAction(sortColour)
        optionMenu.addAction(sortDisabled)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
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
