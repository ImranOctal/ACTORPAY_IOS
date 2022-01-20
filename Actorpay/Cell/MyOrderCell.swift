//
//  MyOrderCell.swift
//  Actorpay
//
//  Created by iMac on 30/12/21.
//

import UIKit
import SDWebImage

class MyOrderCell: UITableViewCell {
    
    @IBOutlet weak var orderNoLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var businessNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var imgCollectionView: UICollectionView!
    
    var orderItemDtos: [OrderItemDtos]?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUpCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Setup Collection View
    func setUpCollectionView() {
        imgCollectionView.delegate = self
        imgCollectionView.dataSource = self
    }
}

extension MyOrderCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderItemDtos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderImgCollectionViewCell", for: indexPath) as! orderImgCollectionViewCell
        cell.imgView.sd_setImage(with: URL(string: orderItemDtos?[indexPath.row].image ?? ""), placeholderImage: UIImage(named: "logo"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if orderItemDtos?.count == 1 {
            return CGSize(width: (collectionView.frame.size.width), height: (collectionView.frame.size.width))
        }
        else if orderItemDtos?.count == 2 {
            return CGSize(width: (collectionView.frame.size.width-2.5) / 2, height: (collectionView.frame.size.width))
        } else {
            if indexPath.row == 2 {
                return CGSize(width: (collectionView.frame.size.width) , height: (collectionView.frame.size.width-2.5) / 2)
            }else {
                return CGSize(width: (collectionView.frame.size.width - 2.5) / 2 , height: (collectionView.frame.size.width-2.5) / 2)
            }
        }
        
    }
}
