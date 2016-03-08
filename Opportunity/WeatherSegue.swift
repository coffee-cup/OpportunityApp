//
//  WeatherSegue.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-03-02.
//  Copyright © 2016 FixCode. All rights reserved.
//

import UIKit

class WeatherSegue: ConditionViewController {
    
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
    
    var lessThan = true // start opposite
    var temperture: Int = 23
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skyButtons = [sunButton, cloudsButton, rainButton, snowButton]
        
//        let gesture = UITapGestureRecognizer(target: self, action: "someAction:")
//        self.myView.addGestureRecognizer(gesture)
        
        sunView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "sunViewTap"))
        cloudsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "cloudsViewTap"))
        rainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "rainViewTap"))
        snowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "snowViewTap"))
        
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
