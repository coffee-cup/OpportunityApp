//
//  ConditionParser.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-03-01.
//  Copyright © 2016 FixCode. All rights reserved.
//

import Foundation
import CoreLocation

class ConditionParser {
    
    // parses time range value
    // returns tuple (lowValue, highValue)
    class func parseTimeRange(value: String) -> (Int, Int) {
        let array = value.componentsSeparatedByString("|")
        let lowValue = Int(array[0])!
        let upValue = Int(array[1])!
        return (lowValue, upValue)
    }
    
    // parses weather condition
    // returns tuple (sign string, temp?, skyString?)
    class func parseWeather(value: String) -> (String, Int?, String?) {
        let array = value.componentsSeparatedByString("|")
        var sign: String = ""
        var temp: Int?
        var sky: String?
        
        if array[0] != "none" {
            sign = array[0].substringToIndex(array[0].startIndex.advancedBy(1))
            temp = Int(array[0].substringFromIndex(array[0].startIndex.advancedBy(1)))
        }
        if array[1] != "none" {
            sky = array[1]
        }
        
        return (sign, temp, sky)
    }
    
    class func parseLocation(value: String) -> MapPin {
        let values = value.componentsSeparatedByString("|")
        var fulltitle = values[0]
        var title = ""
        var subtitle = ""
        if values[0].containsString("-") {
            let aValues = values[0].componentsSeparatedByString("-")
            title = aValues[0]
            subtitle = aValues[1]
        } else {
            title = fulltitle
        }
        let coord = CLLocationCoordinate2D(latitude: Double(values[1])!, longitude: Double(values[2])!)
        let mapPin = MapPin(coordinate: coord, title: title, subtitle: subtitle)
        return mapPin
    }
}