//
//  DistanceTableViewCell.swift
//  Actorpay
//
//  Created by iMac on 04/01/22.
//

import UIKit

class DistanceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var distanceSlider: UISlider!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
