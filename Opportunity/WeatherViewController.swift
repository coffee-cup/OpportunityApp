//
//  WeatherSegue.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-03-02.
//  Copyright © 2016 FixCode. All rights reserved.
//

import UIKit

class WeatherViewController: ConditionViewController {
    
    @IBOutlet weak var lessThanButton: DesignableButton!
    @IBOutlet weak var greaterThanButton: DesignableButton!
    @IBOutlet weak var tempertureButton: DesignableButton!
    @IBOutlet weak var tempertureLabel: UILabel!
    @IBOutlet weak var tempertureSlider: UISlider!
    
    @IBOutlet weak var sunButton: DesignableButton!
    @IBOutlet weak var cloudsButton: DesignableButton!
    @IBOutlet weak var rainButton: DesignableButton!
    @IBOutlet weak var snowButton: DesignableButton!
    var skyButtons: [DesignableButton]!
    var selectedButton: DesignableButton?
    
    @IBOutlet weak var sunView: UIView!
    @IBOutlet weak var cloudsView: UIView!
    @IBOutlet weak var rainView: UIView!
    @IBOutlet weak var snowView: UIView!
    
    @IBOutlet weak var tempIconView: UIImageView!
    @IBOutlet weak var sunImageView: UIImageView!
    @IBOutlet weak var cloudsImageView: UIImageView!
    @IBOutlet weak var rainImageView: UIImageView!
    @IBOutlet weak var snowImageView: UIImageView!
    
    var lessThan = true
    var temperture: Int?
    
    let type = WEATHER
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skyButtons = [sunButton, cloudsButton, rainButton, snowButton]
        
//        let gesture = UITapGestureRecognizer(target: self, action: "someAction:")
//        self.myView.addGestureRecognizer(gesture)
        
        sunView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "sunViewTap"))
        cloudsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "cloudsViewTap"))
        rainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "rainViewTap"))
        snowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "snowViewTap"))
        
        // Init UI values from editing condition
        if condition != nil {
            let values = ConditionParser.parseWeather(condition!.value!)
            if values.1 != nil {
                tempertureSlider.value = Float(values.1!)
                if values.0 == ">" {
                    lessThan = false
                }
                tempertureToggleDidTouch(tempertureButton)
            }
            if values.2 != nil {
                if values.2! == "sun" {
                    selectedButton = sunButton
                } else if values.2! == "clouds" {
                    selectedButton = cloudsButton
                } else if values.2! == "rain" {
                    selectedButton = rainButton
                } else if values.2! == "snow" {
                    selectedButton = snowButton
                }
                animateToggleButton(selectedButton!)
            }
        }
        
        tempIconView.image = Condition.getIconForColour("temp", colour: colour!)
        sunImageView.image = Condition.getIconForColour("sun", colour: colour!)
        cloudsImageView.image = Condition.getIconForColour("clouds", colour: colour!)
        rainImageView.image = Condition.getIconForColour("rain", colour: colour!)
        snowImageView.image = Condition.getIconForColour("snow", colour: colour!)
        
        toggleThanButtons()
        setTempertureLabel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func createCondition() {
        var sky: String = "none"
        var skyString: String = ""
        var temp: String = "none"
        var sign: String = "<"
        var message: String = ""
        if temperture != nil {
            if !lessThan {
                sign = ">"
            }
            temp = "\(sign)\(temperture!)"
            message += "Temperture is \(temp)°C"
        }
        if selectedButton != nil {
            if selectedButton == sunButton {
                sky = "sun"
                skyString = "sunny"
            } else if selectedButton == cloudsButton {
                sky = "clouds"
                skyString = "cloudy"
            } else if selectedButton == rainButton {
                sky = "rain"
                skyString = "rainy"
            } else if selectedButton == snowButton {
                sky = "snow"
                skyString = "snowy"
            }
            if temperture != nil {
                message += " and it is \(skyString)"
            } else {
                message += "It is \(skyString.capitalizedString)"
            }
        }
        let value = "\(temp)|\(sky)"
        
        if value != "none|none" {
            self.createUpdateCondition(type, value: value, message: message)
        } else {
            tempertureButton.animation = "shake"
            tempertureButton.animate()
            
            var delay: CGFloat = 0.100
            for b in skyButtons {
                b.delay = delay
                b.animation = "shake"
                b.animate()
                delay += 0.100
            }
        }
    }
    
    func buttonOn(button: DesignableButton) -> Bool {
        if button.backgroundColor == nil {
            return false
        } else if button.backgroundColor! == UIColor.clearColor() {
            return false
        }
        return true
    }
    
    func animateToggleButton(button: DesignableButton) {
        let ANI_DUR = 0.250
        if !buttonOn(button) {
            UIView.animateWithDuration(ANI_DUR, animations: {
                button.backgroundColor = greenColour
                button.borderColor = UIColor.clearColor()
            })
        } else {
            UIView.animateWithDuration(ANI_DUR, animations: {
                button.backgroundColor = UIColor.clearColor()
                button.borderColor = UIColor.lightGrayColor()
            })
        }
    }
    
    // Sets than buttons to current state of lessThan condition
    func toggleThanButtons() {
        let ANI_DUR = 0.500
        if !lessThan {
            // set to greater than
            UIView.animateWithDuration(ANI_DUR, animations: {
                self.lessThanButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
                self.greaterThanButton.setTitleColor(greenColour, forState: UIControlState.Normal)
            })
        } else {
            // set to less than
            UIView.animateWithDuration(ANI_DUR, animations: {
                self.lessThanButton.setTitleColor(greenColour, forState: UIControlState.Normal)
                self.greaterThanButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            })
        }
    }
    
    // sets temperature label based on current value of slider
    func setTempertureLabel() {
        let value = Int(tempertureSlider.value)
        let label = "\(value)°C"
        tempertureLabel.text = label
    }
    
    @IBAction func tempertureSliderDidChange(sender: AnyObject) {
        if !buttonOn(tempertureButton) {
             tempertureToggleDidTouch(tempertureButton)   
        }
        temperture = Int(tempertureSlider.value)
        setTempertureLabel()
    }
    
    @IBAction func lessThanDidTouch(sender: AnyObject) {
        lessThan = true
        toggleThanButtons()
    }
    
    @IBAction func greaterThanDidTouch(sender: AnyObject) {
        lessThan = false
        toggleThanButtons()
    }
    
    @IBAction func tempertureToggleDidTouch(sender: AnyObject) {
        if buttonOn(tempertureButton) {
            // set no temperature
            temperture = nil
        } else {
            // set temperature
            setTempertureLabel()
            temperture = Int(tempertureSlider.value)
        }
        animateToggleButton(tempertureButton)
    }
    
    @IBAction func skyButtonDidTouch(sender: AnyObject) {
        if let button = sender as? DesignableButton {
            // Deselect button if the select the current one
            if button == selectedButton {
                selectedButton = nil
            } else {
                if selectedButton != nil {
                    animateToggleButton(selectedButton!)
                }
                selectedButton = button
            }
            
            animateToggleButton(button)
        }
    }
    
    func sunViewTap() {
        skyButtonDidTouch(sunButton)
    }
    
    func cloudsViewTap() {
        skyButtonDidTouch(cloudsButton)
    }
    
    func rainViewTap() {
        skyButtonDidTouch(rainButton)
    }
    
    func snowViewTap() {
        skyButtonDidTouch(snowButton)
    }
}
