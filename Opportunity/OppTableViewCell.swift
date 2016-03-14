//
//  OppTableViewCell.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-27.
//  Copyright © 2016 FixCode. All rights reserved.
//

import UIKit

class OppTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colourView: UIView!
    @IBOutlet weak var lastTriggeredLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconView: UIView!
    
    var opp: Opp? {
        didSet {
            if opp != nil {
                let newOpp = opp!
                nameLabel.text = newOpp.name != nil ? newOpp.name! : ""
                colourView.backgroundColor = UIColor(hexString: newOpp.colour!)
                lastTriggeredLabel.text = ""
                self.backgroundColor = newOpp.disabled == 1 ? UIColor.lightGrayColor() : UIColor.whiteColor()
                
                // get conditions for this opp to use icons
                self.conditions = Store.sharedInstance.getConditionsForOpp(opp!)
                
                // remove everything from stack view
                for view in self.stackView.subviews {
                    self.stackView.removeArrangedSubview(view)
                    view.removeFromSuperview()
                }
                
                // add icons for conditions to stack view
                let SPACING = CGFloat(30)
                var width:CGFloat = 0
                for (index, cond) in self.conditions.enumerate() {
                    let iconImage = Condition.getIconForCondition(cond, colour: colourView.backgroundColor!)
                    let imageView = UIImageView(image: iconImage)
                    imageView.contentMode = UIViewContentMode.ScaleAspectFit
                
                    self.stackView.addArrangedSubview(imageView)
                    
                    width += 26
                
                    if index < conditions.count - 1 {
                        let andLabel = UILabel()
                        andLabel.text = "AND"
                        andLabel.font = UIFont(name: "Avenir", size: 12)
                        andLabel.textColor = UIColor.lightGrayColor()
                        self.stackView.addArrangedSubview(andLabel)
                        
                        width += CGFloat(30) + SPACING
                    }
                }
                stackWidthConstraint.constant = CGFloat(width)
            }
        }
    }
    var conditions: [Condition] = [Condition]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
