//
//  ConditionViewController.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-28.
//  Copyright © 2016 FixCode. All rights reserved.
//

import UIKit

class ConditionViewController: UIViewController {
    
    var delegate: CreateConditionDelegate?

    var condition: Condition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let checkButton = UIBarButtonItem(image: UIImage(named: "check"), style: UIBarButtonItemStyle.Plain, target: self, action: "createCondition")
        checkButton.tintColor = purpleColour
        navigationItem.rightBarButtonItem = checkButton
    }
    
    func createUpdateCondition(type: String, value: String, message: String) {
        if condition == nil {
            // create new condition
            delegate?.createCondition(type, value: value, message: message)
        } else {
            // update condition
            delegate?.updateCondition(condition!, type: type, value: value, message: message)
        }
    }
    
    func createCondition() {
        print("you need to override createCondition")
    }
}
