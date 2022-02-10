//
//  CountryCell.swift
//  Actorpay
//
//  Created by iMac on 07/01/22.
//

import UIKit
import SDWebImage

class CountryCell: UITableViewCell {
    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var countryCode: UILabel!
    
    var countryList: CountryList? {
        didSet {
            if let countryList = countryList {
                countryImage.sd_setImage(with: URL(string: countryList.countryFlag ?? ""), placeholderImage: UIImage(named: "IN.png"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                countryName.text = countryList.country
                countryCode.text = countryList.countryCode
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

}
