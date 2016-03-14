//
//  CreateOppViewController.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-16.
//  Copyright © 2016 FixCode. All rights reserved.
//

import UIKit

protocol CreateConditionDelegate: class {
    func createCondition(type: String, value: String, message: String)
    func updateCondition(condition: Condition, type: String, value: String, message: String)
}

class CreateOppViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CreateConditionDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var checkButton: UIBarButtonItem!
    @IBOutlet weak var colourButton: DesignableButton!
    @IBOutlet weak var triggerIfLabel: DesignableLabel!
    
    @IBOutlet weak var nameTextField: DesignableTextField!
    
    var store: Store!
    // If in edit mode, this will be the opp we are editing
    var opp: Opp?
    var conditions: [Condition] = []
    var newOpp: Bool = false
    
    var colours = [colour1, colour2, colour3, colour4, colour5]
    var colourIndex = 0
    
    // if we are creating or editing an opp
    var creating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        store = Store(forClass: CreateOppViewController.classForCoder())
        store = Store.sharedInstance

        colourButton.backgroundColor = colours[colourIndex]
        self.title = creating ? "Create Opp" : "Edit Opp"

        if opp != nil {
            conditions = []
//            conditions = opp!.conditions != nil ? opp!.conditions! : []
            nameTextField.text = opp!.name!
            colourButton.backgroundColor = UIColor(hexString: opp!.colour!)
        } else {
            opp = store.createOpp("New Opp", colour: UIColor.clearColor(), conditions: [])
            newOpp = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadConditions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadConditions() {
        if opp != nil {
            conditions = store.getConditionsForOpp(opp!)
            tableView.reloadData()
        }
    }
    
    // return true if opp is valid
    func verifyOpp() -> Bool {
        let name = nameTextField.text != nil ? nameTextField.text! : ""
        if name == "" {
            return false
        }
        if conditions.count == 0 {
            return false
        }
        return true
    }
    
    // Shakes all fields that are still required
    func animateError() {
        let name = nameTextField.text != nil ? nameTextField.text! : ""
        if name == "" {
            nameTextField.animation = "shake"
            nameTextField.animate()
        }
        if conditions.count == 0 {
            triggerIfLabel.animation = "shake"
            triggerIfLabel.animate()
        }
    }
    
    func popBack() {
        // pop back to this view controller
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    func createCondition(type: String, value: String, message: String) {
        store.createCondition(opp!, type: type, value: value, message: message)
        reloadConditions()
        popBack()
    }
    
    func updateCondition(condition: Condition, type: String, value: String, message: String) {
        store.updateCondition(condition, ownerOpp: opp!, type: type, value: value, message: message)
        reloadConditions()
        popBack()
    }
    
    func backToList() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        if newOpp && opp != nil {
            store.deleteOpp(opp!)
        } else {
            for c in conditions {
                if c.newlyCreated! == 1 {
                    store.deleteCondition(c)
                }
            }
        }
        backToList()
    }

    @IBAction func checkButtonDidTouch(sender: AnyObject) {
        if verifyOpp() {
            let name = nameTextField.text!
            let colour = colourButton.backgroundColor!
            // Create Opp
            if opp == nil {
                store.createOpp(name, colour: colour, conditions: conditions)
            } else {
                // Update Opp
                store.fullSetConditionsForOpp(opp!)
                store.setOppValues(opp!, name: name, colour: colour, conditions: conditions)
                store.save()
            }
            backToList()
        } else {
            animateError()
        }
    }
    
    @IBAction func colourButtonDidTouch(sender: AnyObject) {
        colourIndex++
        if colourIndex >= colours.count {
            colourIndex = 0
        }
        UIView.animateWithDuration(0.5, animations: {
            self.colourButton.backgroundColor = self.colours[self.colourIndex];
        })
        
        self.tableView.reloadData()
        
    }
    
    // MARK : Tableview
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if indexPath.row == conditions.count {
            return []
        }
        
        let condition = conditions[indexPath.row]
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            self.store.deleteCondition(condition)
            self.reloadConditions()
        }
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conditions.count + 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == conditions.count) {
            return 100
        }
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        if (indexPath.row == conditions.count) {
            cell = tableView.dequeueReusableCellWithIdentifier("addConditionCell", forIndexPath: indexPath)
        } else {
            let cond = conditions[indexPath.row]
            cell = tableView.dequeueReusableCellWithIdentifier("conditionCell")
            if let condCell = cell as? CondTableViewCell {
                condCell.typeLabel.text = cond.type!.uppercaseString
                condCell.messageLabel.text = cond.message!
                condCell.iconImageView.image = Condition.getIconForCondition(cond, colour: colourButton.backgroundColor!)
                condCell.iconImageView.animation = "fadeIn"
                condCell.iconImageView.duration = 0.250
                condCell.iconImageView.animate()
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row != conditions.count) {
            let cond = conditions[indexPath.row]
            let segue = cond.type!.stringByReplacingOccurrencesOfString(" ", withString: "")
            performSegueWithIdentifier("\(segue)Segue", sender: cond)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toView = segue.destinationViewController
        if let addConditionView = toView as? AddConditionTableViewController {
            addConditionView.delegate = self
            addConditionView.opp = opp!
            addConditionView.colour = colourButton.backgroundColor!
        } else if let conditionView = toView as? ConditionViewController {
            conditionView.delegate = self
            conditionView.colour = colourButton.backgroundColor!
            if let cond = sender as? Condition {
                conditionView.condition = cond
            }
        }
//        if let conditionView = toView as? ConditionVIewController {
//            if let cond = sender as? Condition {
//                conditionView.condition = cond
//            }
//        }
    }

}
