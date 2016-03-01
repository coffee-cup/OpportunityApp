//
//  ConditionParser.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-03-01.
//  Copyright © 2016 FixCode. All rights reserved.
//

import Foundation

let TIME_RANGE = "Time Range"

class ConditionParser {
    
    // parses time range value
    // returns tuple (lowValue, highValue)
    class func parseTimeRange(value: String) -> (Int, Int) {
        let array = value.componentsSeparatedByString("|")
        let lowValue = Int(array[0])!
        let upValue = Int(array[1])!+3
        return (lowValue, upValue)
    }
}