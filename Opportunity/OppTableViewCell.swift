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
    
    var opp: Opp? {
        didSet {
            if opp != nil {
                let newOpp = opp!
                nameLabel.text = newOpp.name != nil ? newOpp.name! : ""
                colourView.backgroundColor = UIColor(hexString: newOpp.colour!)
                lastTriggeredLabel.text = ""
                self.backgroundColor = newOpp.disabled == 1 ? UIColor.lightGrayColor() : UIColor.whiteColor()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
