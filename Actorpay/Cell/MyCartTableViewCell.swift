//
//  MyCartTableViewCell.swift
//  Actorpay
//
//  Created by iMac on 21/12/21.
//

import UIKit

class MyCartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var actualPriceLabel: UILabel!
    @IBOutlet weak var productQuntityLabel: UILabel!
    
    var deleteButtonHandler: (() -> ())!
    var addButtonHandler: (() -> ())!
    var minusButtonHandler: (() -> ())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func minusButtonAction(_ sender: UIButton) {
        minusButtonHandler()
    }
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        deleteButtonHandler()
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        addButtonHandler()
    }
    
}
