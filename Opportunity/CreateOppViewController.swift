//
//  CreateOppViewController.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-16.
//  Copyright © 2016 FixCode. All rights reserved.
//

import UIKit

class CreateOppViewController: UIViewController {

    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var checkButton: UIBarButtonItem!
    
    // if we are creating or editing an opp
    var creating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = creating ? "Create Opp" : "Edit Opp"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backToList() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        backToList()
    }

    @IBAction func checkButtonDidTouch(sender: AnyObject) {
        backToList()
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
