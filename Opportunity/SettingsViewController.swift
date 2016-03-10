//
//  SettingsViewController.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-16.
//  Copyright © 2016 FixCode. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var hists: [Hist] = [Hist]()
    var store: Store!
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        store = Store.sharedInstance
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "loadHists", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(self.refreshControl) // not required when using UI
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadHists()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadHists() {
        hists = store.getTriggerHistory()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HistCell")!
        
        let hist = hists[indexPath.row]
        if let histCell = cell as? HistTableViewCell {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "hh:mm a MMM dd"

            histCell.titleLabel.text = hist.name!
            histCell.dateLabel.text = formatter.stringFromDate(hist.dateTriggered!)
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hists.count
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
