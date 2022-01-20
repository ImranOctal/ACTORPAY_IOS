//
//  ManageAddressTableViewCell.swift
//  Actorpay
//
//  Created by iMac on 03/01/22.
//

import UIKit

class ManageAddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var contactNoLbl: UILabel!

    var deleteButtonHandler: ((_ sender: UIButton) -> ())!
    var editButtonHandler: (() -> ())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteButtonAction(_ sender: UIButton) {
        deleteButtonHandler(sender)
    }
    
    @IBAction func editAddressBtnAction(_ sender: UIButton) {
        editButtonHandler()
    }
}
