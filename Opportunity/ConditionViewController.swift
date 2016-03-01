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
    
    func createUpdateCondition(type: String, value: String, message: String) {
        if condition == nil {
            // create new condition
            delegate?.createCondition(type, value: value, message: message)
        } else {
            // update condition
            delegate?.updateCondition(condition!, type: type, value: value, message: message)
        }
    }
    
}
