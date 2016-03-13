//
//  Condition.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-28.
//  Copyright © 2016 FixCode. All rights reserved.
//

import Foundation
import CoreData
import UIKit

let TIME_RANGE = "Time Range"
let WEATHER = "Weather"
let LOCATION = "Location"
let AVAILBILITY = "Availbility"

class Condition: NSManagedObject {
    
    class func getIconForCondition(condition: Condition, colour: UIColor) -> UIImage {
        var icon = "";
        if condition.type! == TIME_RANGE {
            icon += "time"
        } else if condition.type! == WEATHER {
            let values = ConditionParser.parseWeather(condition.value!)
            if values.1 != nil {
                icon += "temp"
            } else if values.2 != nil {
                icon += values.2!
            }
        } else if condition.type! == LOCATION {
            icon += "pin"
        } else if condition.type! == AVAILBILITY {
            icon += "cal"
        }
        
        return getIconForColour(icon, colour: colour)
    }
    
    class func getIconForColour(iconName: String, colour: UIColor) -> UIImage {
        var icon = "\(iconName)"
        if colour == yellowColour {
            icon += "_yellow"
        } else if colour == greenColour {
            icon += "_green"
        } else if colour == purpleColour {
            icon += "_purple"
        } else if colour == darkpurpleColour {
            icon += "_darkpurple"
        } else if colour == pinkColour {
            icon += "_pink"
        }
        
        return UIImage(named: icon)!
    }
}

