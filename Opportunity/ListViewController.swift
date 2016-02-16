//
//  listViewController.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-16.
//  Copyright © 2016 FixCode. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var createOppButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toView = segue.destinationViewController
        toView.transitioningDelegate = self.transitioningDelegate
        
        print("Yes")
        if let addView = toView as? CreateOppViewController {
            print("no")
            print(sender)
            if let createButton = sender as? UIBarButtonItem {
                addView.creating = true
            }
        }
    }
    
    @IBAction func createOppButtonDidTouch(sender: AnyObject) {
        self.performSegueWithIdentifier("addSegue", sender: createOppButton)
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("oppCell", forIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("addSegue", sender: self)
    }
    
}
