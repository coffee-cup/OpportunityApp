//
//  HistTableViewCell.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-03-10.
//  Copyright © 2016 FixCode. All rights reserved.
//

import UIKit

class HistTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
