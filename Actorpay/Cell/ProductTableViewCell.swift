//
//  ProductTableViewCell.swift
//  Actorpay
//
//  Created by iMac on 06/12/21.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buyNowButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!

    var buyNowButtonHandler: (() -> ())!
    var addToCartButtonHandler: (() -> ())!
    var likeButtonHandler: (() -> ())!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        likeButton.setImage( UIImage(named: "like_small"), for: .normal)
        likeButton.setImage( UIImage(named: "liked_small"), for: .selected)
    }
    
    @IBAction func likeButtonAction(_ sender: UIButton){
        likeButtonHandler()
    }
    
    @IBAction func buyNowButtonAction(_ sender: UIButton){
        buyNowButtonHandler()
    }
    
    @IBAction func addTocartButtonAction(_ sender: UIButton){
        addToCartButtonHandler()
    }

}
