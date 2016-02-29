//
//  CreateOppViewController.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-16.
//  Copyright © 2016 FixCode. All rights reserved.
//

import UIKit

let opps = [
    [
        "type": "Location",
        "message": "Thi is location method"
    ],
    [
        "type": "Weather",
        "message": "> 20 degrees and sunny"
    ]
]

class CreateOppViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var checkButton: UIBarButtonItem!
    @IBOutlet weak var colourButton: DesignableButton!
    
    @IBOutlet weak var nameTextField: DesignableTextField!
    
    var store: Store!
    // If in edit mode, this will be the opp we are editing
    var opp: Opp?
    
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
            nameTextField.text = opp!.name!
            colourButton.backgroundColor = UIColor(hexString: opp!.colour!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // return true if opp is valid
    func verifyOpp() -> Bool {
        let name = nameTextField.text != nil ? nameTextField.text! : ""
        if name == "" {
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

    }
    
    func backToList() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        backToList()
    }

    @IBAction func checkButtonDidTouch(sender: AnyObject) {
        if verifyOpp() {
            let name = nameTextField.text!
            let colour = colourButton.backgroundColor!
            // Create Opp
            if opp == nil {
                store.createOpp(name, colour: colour)
            } else {
                // Update Opp
                opp!.name = name
                opp!.colour = colour.toHexString()
                store.save()
                
//                let updateOpp = store.dataContext.opps.first{$ 0.objectID == opp!.objectID}
                
//                store.db.operation { (context, save) -> Void in
//                    self.opp!.name = name
//                    self.opp!.colour = colour.toHexString()
//                    save()
//                }
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
        
    }
    
    // MARK : Tableview
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return opps.count + 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == opps.count) {
            return 100
        }
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        if (indexPath.row == opps.count) {
            cell = tableView.dequeueReusableCellWithIdentifier("addConditionCell", forIndexPath: indexPath)
        } else {
            let cond = opps[indexPath.row]
            cell = tableView.dequeueReusableCellWithIdentifier("conditionCell")
            if let condCell = cell as? CondTableViewCell {
                condCell.typeLabel.text = cond["type"]?.uppercaseString
                condCell.messageLabel.text = cond["message"]
            }
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        self.performSegueWithIdentifier("addSegue", sender: self)
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
