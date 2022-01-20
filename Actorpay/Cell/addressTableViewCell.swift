//
//  addressTableViewCell.swift
//  Actorpay
//
//  Created by iMac on 21/12/21.
//

import UIKit

class addressTableViewCell: UITableViewCell {
    @IBOutlet weak var addressTypeLbl: UILabel!
    @IBOutlet weak var addressNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var deleteButtonHandler: ((_ sender: UIButton) -> ())!
    var editButtonHandler: ((_ sender: UIButton) -> ())!
    
    var addressItem: AddressItems? {
        didSet{
            if let item = addressItem {
                self.addressNameLbl.text = item.name
                self.addressLbl.text = "\(item.addressLine1 ?? ""), \(item.area ?? ""), \(item.addressLine2 ?? ""), \(item.city ?? ""), \(item.state ?? ""),, \(item.country ?? ""), \(item.zipCode ?? "")"
                self.addressTypeLbl.text = item.title
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editButtonAction(_ sender: UIButton) {
//        editButtonHandler()
    }
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        deleteButtonHandler(sender)
    }
    

}
