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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func createCondition() {
        
    }
    
    func buttonOn(button: DesignableButton) {
        return button.backgroundColor != greenColour
    }
    
    func animateToggleButton(button: DesignableButton) {
        let ANI_DUR = 0.250
        if button.backgroundColor == UIColor.whiteColor() {
            UIView.animateWithDuration(ANI_DUR, animations: {
                button.backgroundColor = greenColour
                button.borderColor = UIColor.clearColor()
            })
        } else {
            UIView.animateWithDuration(ANI_DUR, animations: {
                button.backgroundColor = UIColor.whiteColor()
                button.borderColor = UIColor.lightGrayColor()
            })
        }
    }
    
    @IBAction func tempertureToggleDidTouch(sender: AnyObject) {
        animateToggleButton(tempertureButton)
    }
    
    @IBAction func skyButtonDidTouch(sender: AnyObject) {
        if let button = sender as? DesignableButton {
            animateToggleButton(button)
        }
    }
}
