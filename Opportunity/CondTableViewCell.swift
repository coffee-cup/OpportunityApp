//
//  CondTableViewCell.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-25.
//  Copyright © 2016 FixCode. All rights reserved.
//

import UIKit

class CondTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var iconImageView: DesignableImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
