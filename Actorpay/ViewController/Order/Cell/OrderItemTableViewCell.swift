//
//  OrderItemTableViewCell.swift
//  Actorpay
//
//  Created by iMac on 29/12/21.
//

import UIKit
import SDWebImage
import DropDown

class OrderItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    
    var menuButtonHandler: (() -> ())!
    var cancelOrderDropDown = DropDown()
    var cancelOrderHandler: ((_ status:String) -> ())!
    
    var item: OrderItemDtos? {
        didSet {
            if let item = self.item {
                titleLbl.text = item.productName
                qtyLbl.text = "Quantity: \(item.productQty ?? 0)"
                priceLbl.text = "Price: ₹\((item.totalPrice ?? 0.0).doubleToStringWithComma())"
                imgView.sd_setImage(with: URL(string: item.image ?? ""), placeholderImage: UIImage(named: "NewLogo"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                statusLbl.text = "\(item.orderItemStatus ?? "")"
                menuButton.isHidden = item.orderItemStatus == "CANCELLED" || item.orderItemStatus == "RETURNING" || item.orderItemStatus == "RETURNED" ? true : false
                statusLbl.textColor = getStatus(stausString: item.orderItemStatus ?? "")
            }
        }
    }
    
    var cancelOrderItemDtos: OrderItemDtos? {
        didSet {
            if let item = self.cancelOrderItemDtos {
                titleLbl.text = item.productName
                qtyLbl.text = "Quantity: \(item.productQty ?? 0)"
                priceLbl.text = "Price: ₹\((item.totalPrice ?? 0.0).doubleToStringWithComma())"
                imgView.sd_setImage(with: URL(string: item.image ?? ""), placeholderImage: UIImage(named: "NewLogo"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                statusLbl.text = "Status: \(item.orderItemStatus ?? "")"
                print(item.orderItemStatus)
                
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
    
    // Menu Button Action
    @IBAction func menuButtonAction(_ sender: UIButton) {
        menuButtonHandler()
    }
    
    // Cancel Order DropDown SetUp
    func setUpCancelOrderDropDown() {
        cancelOrderDropDown.show()
        cancelOrderDropDown.anchorView = menuButton
        cancelOrderDropDown.layer.borderWidth = 1
        cancelOrderDropDown.layer.borderColor = UIColor.black.cgColor
        if item?.orderItemStatus == "SUCCESS" || item?.orderItemStatus == "READY" {
            cancelOrderDropDown.dataSource = ["Cancel Order"]
        } else if item?.orderItemStatus == "DISPATCHED" || item?.orderItemStatus == "DELIVERED" {
            cancelOrderDropDown.dataSource = ["Return Order"]
        }else if item?.orderItemStatus == "RETURNING_DECLINED" {
            cancelOrderDropDown.dataSource = ["Raise Dispute"]
        }
        cancelOrderDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            cancelOrderHandler(item)
            self.cancelOrderDropDown.hide()
        }
        cancelOrderDropDown.bottomOffset = CGPoint(x: -60, y: 25)
        cancelOrderDropDown.width =  110
        cancelOrderDropDown.direction = .bottom
    }

}
