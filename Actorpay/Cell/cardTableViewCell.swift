//
//  cardTableViewCell.swift
//  Actorpay
//
//  Created by iMac on 21/12/21.
//

import UIKit

class cardTableViewCell: UITableViewCell {

    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    var deleteButtonHandler: (() -> ())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func removeButtonAction(_ sender: UIButton) {
//        deleteButtonHandler()
    }

}
