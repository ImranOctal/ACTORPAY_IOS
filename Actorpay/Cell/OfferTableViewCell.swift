//
//  OfferTableViewCell.swift
//  Actorpay
//
//  Created by iMac on 04/01/22.
//

import UIKit

class OfferTableViewCell: UITableViewCell {

    @IBOutlet weak var offterImageView: UIImageView!
    @IBOutlet weak var offerTitleLbl: UILabel!
    @IBOutlet weak var offerDescriptionLbl: UILabel!
    @IBOutlet weak var offerCodeLbl: UILabel!
    
    var offer: Items? {
        didSet {
            if let offer = offer {
                offerTitleLbl.text = offer.offerTitle
                offerDescriptionLbl.text = offer.offerDescription
                offerCodeLbl.text = offer.promoCode
            }
        }
    }
    
    var copyButtonHandler: ((_ sender: UIButton) -> ())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func copyButtonAction(_ sender: UIButton){
        copyButtonHandler(sender)
    }

}
