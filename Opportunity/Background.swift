//
//  Background.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-29.
//  Copyright © 2016 FixCode. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation
import SwiftLocation
import SwiftyJSON

let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?"
let WEATHER_APIKEY = "f08fa2990158d409a6f4998960cddfa1"

let KELVIN: Float = 273.15

class WeatherSet {
    var set: Bool
    var temp: Int
    var sky: String
    init() {
        temp = -1
        sky = ""
        set = false
    }
    init(temp: Int, sky: String) {
        self.temp = temp
        self.sky = sky
        set = true
    }
}

// Class to handle all background tasks
class Background {
    
    var store: Store
    var currentLocation: CLLocation?
    var currentWeather: WeatherSet?
    var promises = [Promise]()
    
    init() {
        store = Store()
        
        promises = [getLocation()]
    }
    
    // run background fetch and trigger any opps that can be triggered
    // returns true or false if an opp was triggered
    func backgroundFetch() -> Promise {
        let promise = Craft.promise({
            (resolve: (value: Value) -> (), reject: (value: Value) -> ()) -> () in
            
            let opps = self.store.getOpps()
            var oneTriggered = false
            
            var oppPromises: [Promise] = [Promise]()
            
            // Put all promises in an array
            for opp in opps {
                oppPromises.append(self.parseOpp(opp))
            }
            
            // Settle all condition promises
            Craft.allSettled(oppPromises).then({
                (value: Value) -> Value in
                
                if let v: [Value] = value as? [Value] {
                    
                    // loop through opp promises to see if an opp was triggered
                    // if opp triggered, send local notification
                    for (index, result) in v.enumerate() {
                        let opp = opps[index]
                        if let triggered = (result as! SettledResult).value! as? Bool {
                            if triggered {
                                self.createTriggerNotification(opp)
                                self.store.setOppRead(opp)
                                oneTriggered = true
                            }
                        }
                    }
                }
                
                resolve(value: oneTriggered)
                return nil
            })
        })
        return promise
    }
    
    func createTriggerNotification(opp: Opp) {
        // if there is already a notification for this opp, do not make a new one
        if !allowedNotification(opp) {
            return
        }
        
        let notification = UILocalNotification()
        notification.alertBody = opp.name!
        notification.alertAction = "open"
        notification.fireDate = NSDate()
        
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["id": opp.objectID.URIRepresentation().absoluteString]
        notification.category = opp.colour!
        
        // update last triggered time of opp
        store.setLastTriggered(opp)
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    // returns whether or not we are allowed to set notification for opp
    func allowedNotification(opp: Opp) -> Bool {
        if opp.read == 0 {
            return false
        }
        // only all opp to be triggered once every 30 minutes
        if opp.lastTriggered != nil {
            let elapsedTime = NSDate().timeIntervalSinceDate(opp.lastTriggered!)
            if elapsedTime <= 30 * 60 { // 30 minutes
                return false
            }
        }
        return true
    }
    
    func parseOpp(opp: Opp) -> Promise {
        let promise = Craft.promise({
            (resolve: (value: Value) -> (), reject: (value: Value) -> ()) -> () in
            
            let conditions = self.store.getConditionsForOpp(opp)
            var conditionPromises: [Promise] = [Promise]()
            
            if conditions.count == 0 {
                resolve(value: false)
                return
            }
            
            // Put all promises in an array
            for cond in conditions {
                conditionPromises.append(self.checkCondition(cond))
            }
            
            // Settle all condition promises
            Craft.allSettled(conditionPromises).then({
                (value: Value) -> Value in
                
                if let v: [Value] = value as? [Value] {
                    
                    // loop through promises results to see if all opp conditions passed
                    for result in v {
                        if let conditionPassed = (result as! SettledResult).value! as? Bool {
                            if !conditionPassed {
                                resolve(value: false)
                                return nil
                            }
                        }
                    }
                    resolve(value: true)
                }
                
                resolve(value: conditions.count != 0)
                return nil
            })
        })
        return promise
    }
    
    // returns true if condition passes and can trigger opp
    func checkCondition(condition: Condition) -> Promise {
        let type = condition.type!
        if type == TIME_RANGE {
            return checkTimeRange(condition)
        } else if type == WEATHER {
            return checkWeather(condition)
        }
        let promise = Craft.promise({
            (resolve: (value: Value) -> (), reject: (value: Value) -> ()) -> () in
            resolve(value: false)
        })
        return promise
    }
    
    func getLocation() -> Promise {
        let promise = Craft.promise({
            (resolve: (value: Value) -> (), reject: (value: Value) -> ()) -> () in
            
            // do not use location again if already have for this background fetch
            if self.currentLocation != nil {
                resolve(value: self.currentLocation!)
            } else {
                try! SwiftLocation.shared.currentLocation(Accuracy.Block, timeout: 20, onSuccess: { (location) -> Void in
                    // location is a CLPlacemark
                    self.currentLocation = location
                    resolve(value: self.currentLocation!)
                    }) { (error) -> Void in
                        reject(value: error)
                }
            }
        })
        
        return promise
    }
    
    // Get weather from openweathermap
    func getWeather(coords: CLLocationCoordinate2D) -> Promise {
        // http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=44db6a862fba0b067b1930da0d769e98
        let promise = Craft.promise({
            (resolve: (value: Value) -> (), reject: (value: Value) -> ()) -> () in
            
            if self.currentWeather != nil {
                resolve(value: self.currentWeather!)
                return
            }
            
            let lat = coords.latitude.description
            let lon = coords.longitude.description
            Alamofire.request(.GET, WEATHER_URL, parameters: ["lat": lat, "lon": lon, "appid": WEATHER_APIKEY])
                .responseJSON { response in
                    let json = JSON(data: response.data!)
                    let weather = WeatherSet()
                    if let temp = json["main"]["temp"].number {
                        weather.temp = Int(temp.floatValue - KELVIN)
                        weather.set = true
                    }
                    if let sky = json["weather"][0]["main"].string {
                        // I know this is poop
                        if sky == "Rain" {
                            weather.sky = "rain"
                        } else if sky == "Clear" {
                            weather.sky = "sun"
                        } else if sky == "Clouds" {
                            weather.sky = "clouds"
                        } else if sky == "Snow" {
                            weather.sky = "snow"
                        }
                        weather.set = true
                    }
                    
                    self.currentWeather = weather
                    resolve(value: weather)
            }
            
        })
        
        return promise
    }
    
    // MARK : CHECKING CONDITIONS
    
    // Check if weather condition passed
    func checkWeather(condition: Condition) -> Promise {
        let promise = Craft.promise({
            (resolve: (value: Value) -> (), reject: (value: Value) -> ()) -> () in
            
            // I Know below is if mess
            self.getLocation().then({
                (value: Value) -> Value in
                
                if let location = value as? CLLocation {
                    self.getWeather(location.coordinate).then({
                        (value: Value) -> Value in
                        
                        if let weather = value as? WeatherSet {
                            let values = ConditionParser.parseWeather(condition.value!)
                            var shouldPass = false
                            
                            if weather.set {
                                shouldPass = true
                                // Check if weather condition passes
                                if values.1 != nil {
                                    if values.0 == "<" {
                                        // less than temp
                                        if weather.temp > values.1! {
                                            shouldPass = false
                                        }
                                    } else {
                                        // greater than temp
                                        if weather.temp < values.1! {
                                            shouldPass = false
                                        }
                                    }
                                }
                                if values.2 != nil {
                                    if values.2! != weather.sky {
                                        shouldPass = false
                                    }
                                }
                            }
                            resolve(value: shouldPass)
                        } else {
                            resolve(value: false)
                        }
                        return nil
                        }, reject: {
                            (value: Value) -> Value in
                            resolve(value: false)
                            return nil
                    })
                }
                return nil
                }, reject: {
                    (value: Value) -> Value in
                    resolve(value: false)
                    return nil
            })
        })
        return promise
    }
    
    // parses and checks time range condition and returns
    // true if can trigger opp
    func checkTimeRange(condition: Condition) -> Promise {
        let promise = Craft.promise({
            (resolve: (value: Value) -> (), reject: (value: Value) -> ()) -> () in
            
            let values = ConditionParser.parseTimeRange(condition.value!)
            let lowValue = values.0
            let upValue = values.1
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "HH"
            // the 24 hour
            let hour24 = Int(formatter.stringFromDate(NSDate()))!
            
            // all day time range, always trigger
            if lowValue == 0 && upValue == 0 {
                resolve(value: true)
            }
            
            if hour24 >= lowValue && hour24 <= upValue {
                resolve(value: true)
            }
            resolve(value: false)
        })
        return promise
    }
}