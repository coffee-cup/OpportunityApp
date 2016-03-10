//
//  AddConditionTableViewController.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-25.
//  Copyright © 2016 FixCode. All rights reserved.
//

import UIKit

class AddConditionTableViewController: UITableViewController {
    
    var conditions = [
        [
            "type": "Time Range",
            "disabled": false
        ],
        [
            "type": "Weather",
            "disabled": false
        ]
//        [
//            "type": "Location",
//            "disabled": false
//        ],        [
//            "type": "Availbility",
//            "disabled": false
//        ],        [
//            "type": "Event",
//            "disabled": false
//        ]
    ]
//    let conditions = ["Time Range", "Weather", "Location", "Availbility", "Event"]
    var opp: Opp?
    
    var delegate: CreateConditionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO : CHANGE THIS
        if opp != nil {
            let oppConditions = Store.sharedInstance.getConditionsForOpp(opp!)
            for oppC in oppConditions {
                for (var i=0;i<conditions.count;i++) {
                    let aC = conditions[i]
                    let type = (aC["type"] as! String).uppercaseString
                    if type == oppC.type!.uppercaseString {
                        conditions[i]["disabled"] = true
                    }
                }
            }
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conditions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddConditionCell", forIndexPath: indexPath)
        let cond = conditions[indexPath.row]
        
        cell.textLabel?.text = cond["type"] as? String
        if (cond["disabled"] as! Bool) {
            cell.backgroundColor = UIColor.lightGrayColor()
            cell.userInteractionEnabled = false
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cond = conditions[indexPath.row]
        let stripped = (cond["type"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
        let segueId = "\(stripped)Segue"
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier(segueId, sender: tableView.cellForRowAtIndexPath(indexPath))
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toView = segue.destinationViewController
        if let conditionView = toView as? ConditionViewController {
            conditionView.delegate = delegate
        }
    }

}
