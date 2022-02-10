//
//  FilterTableViewCell.swift
//  Actorpay
//
//  Created by iMac on 04/01/22.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dropDownBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setExpented() {
        dropDownBtn.setImage(UIImage(named: "up_arrow"), for: .normal)
    }
    func setCollpased() {
        dropDownBtn.setImage(UIImage(named: "drop_down_arrow"), for: .normal)
    }

}
