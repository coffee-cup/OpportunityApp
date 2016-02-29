//
//  OppsViewController.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-16.
//  Copyright © 2016 FixCode. All rights reserved.
//

import UIKit
import SugarRecord

protocol OppListDelegate: class {
    func selectCell(from: AnyObject?)
}

class OppsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: OppListDelegate?
    
    var store: Store!
    var opps: [Opp]! {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        store = Store(forClass: OppsViewController.classForCoder())
        store = Store.sharedInstance
        
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadOpps()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : OPPS
    
    func loadOpps() {
        opps = store.getOpps()
    }
    
    // MARK : Tableview
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return opps.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("oppCell", forIndexPath: indexPath)
        let opp = opps[indexPath.row]

        if let oppCell = cell as? OppTableViewCell {
            oppCell.opp = opp
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let opp = opps[indexPath.row]
        delegate?.selectCell(opp)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let opp = opps[indexPath.row]
        let disable = UITableViewRowAction(style: .Normal, title: "Disable") { action, index in
            self.store.toggleDisabled(opp)
//            opp.disabled = !opp.disabled
//            self.store.save()
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        }
        disable.backgroundColor = UIColor.lightGrayColor()
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            self.store.deleteOpp(opp)
//            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.loadOpps()
        }
        delete.backgroundColor = UIColor.redColor()
        
        return [delete, disable]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
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