//
//  TimeRangeViewController.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-28.
//  Copyright © 2016 FixCode. All rights reserved.
//

import UIKit

class TimeRangeViewController: ConditionViewController {

    @IBOutlet weak var timeSlider: RangeSlider!
    @IBOutlet weak var betweenLabel: UILabel!
    
    let type = TIME_RANGE
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if condition != nil {
            let values = ConditionParser.parseTimeRange(condition!.value!)
            timeSlider.lowerValue = Double(values.0)
            timeSlider.upperValue = Double(values.1+3)
        }
        betweenLabel.text = getMessage()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
        
    func getMessage() -> String {
        let early = numToTimeString(timeSlider.lowerValue)
        let late = numToTimeString(round(timeSlider.upperValue-3))
        return "Between \(early) and \(late)"
    }
    
    func numToTimeString(value: Double) -> String {
        var ampm = ""
        var num = Int(value)
        if num == 0 {
            ampm = "am"
            num = 12
        } else if num < 12 {
            ampm = "am"
        } else if num == 12 {
            ampm = "pm"
        } else if num == 24 {
            ampm = "am"
            num = 12
        } else {
            ampm = "pm"
            num -= 12
        }
        return "\(num)\(ampm)"
    }
    
    override func createCondition() {
        let message = getMessage()
        let value = "\(Int(round(timeSlider.lowerValue)))|\(Int(round(timeSlider.upperValue))-3)"
        createUpdateCondition(type, value: value, message: message)
    }
    
    @IBAction func timeSliderValueChanged(sender: AnyObject) {
        betweenLabel.text = getMessage()
    }
    
}
