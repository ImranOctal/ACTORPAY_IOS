//
//  CancelOrderViewController.swift
//  Actorpay
//
//  Created by iMac on 25/01/22.
//

import UIKit
import Alamofire

class CancelOrderViewController: UIViewController {
    
    //MARK: - Properties -

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var headerTitleLbl: UILabel!
    @IBOutlet weak var orderNoLbl: UILabel!
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var orderPriceLbl: UILabel!
    @IBOutlet weak var orderTextView: UITextView!
    @IBOutlet weak var cancelOrderTextViewValidationLbl: UILabel!
    @IBOutlet weak var cancelOrderValidationView: UIView!
    @IBOutlet weak var orderTblView: UITableView! {
        didSet {
            orderTblView.delegate = self
            orderTblView.dataSource = self
        }
    }
    @IBOutlet weak var cancelOrderBtn: UIButton!
    @IBOutlet weak var uploadImageView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadImageBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    var status:String = ""
    var orderItems: OrderItems?
    var orderItemDtos: OrderItemDtos?
    var placeHolder = ""
    var productImage: UIImage?
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        self.setUpTextView()
        topCorner(bgView: bgView, maskToBounds: true)
        self.setOrderData()
    }
    
    //MARK: - Selectors -
    
    // Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Cancel Order Button Action
    @IBAction func cancelOrderBtnAction(_ sender: UIButton) {
        if cancelOrderValidation() {
            cancelOrderValidationView.isHidden = true
            cancelOrReturnOrderApi()
        }
    }
    
    // Upload Image Button Action
    @IBAction func uploadImageBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let alertController = UIAlertController(title:"", message: "", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Choose Existing", style: .default) { (action) in
            self.openPhotos()
        }
        let okAction2 = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            self.openCamera()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(okAction2)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions -
    
    // SetUp Text View
    func setUpTextView() {
        cancelOrderValidationView.isHidden = true
        placeHolder = "Enter Cancel Reason"
        orderTextView.delegate = self
        orderTextView.text = placeHolder
        if orderTextView.text == placeHolder {
            orderTextView.textColor = .lightGray
        } else {
            orderTextView.textColor = .black
        }
    }
    
    // Cancel Order Validation
    func cancelOrderValidation() -> Bool {
        var isValidate = true
        
        if orderTextView.text?.trimmingCharacters(in: .whitespaces).count == 0 || orderTextView.text == placeHolder {
            cancelOrderValidationView.isHidden = false
            cancelOrderTextViewValidationLbl.text = ValidationManager.shared.emptyCancelOrderDescription
            isValidate = false
        } else {
            cancelOrderValidationView.isHidden = true
        }
        
        return isValidate
        
    }
    
    // Set Order Data
    func setOrderData() {
        uploadImageView.isHidden = status == "Cancel Order" ? true : false
        headerTitleLbl.text = status == "Cancel Order" ? "Cancel Order" : "Return Order"
        cancelOrderBtn.setTitle(status == "Cancel Order" ? "CANCEL ORDER" : "RETURN ORDER", for: .normal)
        orderNoLbl.text = orderItems?.orderNo
        orderDateLbl.text = "Order Date: \(orderItems?.createdAt?.toFormatedDate(from: "yyyy-MM-dd hh:mm", to: "dd MMM yyyy HH:MM") ?? "")"
        orderPriceLbl.text = "₹\((orderItems?.totalPrice ?? 0.0).doubleToStringWithComma())"
    }
    
    //Open Camera
    func openCamera(){
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let alert  = UIAlertController(title: "Warning", message: "Camera Not Supported", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Open Image Gallary
    func openPhotos(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
        
}

//MARK: - Extensions -

//MARK: Api Call
extension CancelOrderViewController {
    
    // Cancel Or Return Order Api
    func cancelOrReturnOrderApi() {
        var imgData: Data?
        
        let params: Parameters = [
            "cancelOrder": [
                "cancellationRequest": status == "Cancel Order" ? "CANCELLED" : "RETURNING",
                "cancelReason": orderTextView.text ?? "",
                "orderItemIds":[orderItemDtos?.orderItemId ?? ""]
            ]
        ]
        if productImage != nil {
            imgData = self.productImage?.jpegData(compressionQuality: 0.1)
        }
        showLoading()
        APIHelper.cancelOrReturnOrderApi(params:params, imgData: imgData, imageKey: "file", orderNo: orderItems?.orderNo ?? "") { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name:  Notification.Name("getOrderDetailsApi"), object: self)
                NotificationCenter.default.post(name:  Notification.Name("reloadOrderListApi"), object: self)
            }
        }
    }
    
}

//MARK: TableView Setup
extension CancelOrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemTableViewCell", for: indexPath) as! OrderItemTableViewCell
        cell.cancelOrderItemDtos = orderItemDtos
        return cell
    }
    
}

//MARK: Image Picker Delegate Methods
extension CancelOrderViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.productImage = image
            uploadImageBtn.setTitle(productImage == nil ? "Upload Image":"Edit Image", for: .normal)
            imageView.contentMode = .scaleAspectFill
            imageView.image = self.productImage
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: Text View Delegate Methods
extension CancelOrderViewController : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == placeHolder {
            textView.text = ""
        }
        
        if textView.text == placeHolder {
            textView.isSelectable = false
        } else {
            textView.isSelectable = true
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 500
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == placeHolder {
            textView.text = nil
            
            textView.textColor = UIColor.black
        }
        
        if textView.text == placeHolder {
            textView.isSelectable = false
        } else {
            textView.isSelectable = true
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == placeHolder {
            textView.isSelectable = true
        } else {
            textView.isSelectable = true
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count == 0 {
            textView.text = placeHolder
            textView.textColor = UIColor.lightGray
        } else {
            textView.textColor = UIColor.black
        }
        
        if textView.text == placeHolder {
            textView.isSelectable = false
            cancelOrderValidationView.isHidden = false
            cancelOrderTextViewValidationLbl.text = ValidationManager.shared.emptyCancelOrderDescription
        } else {
            textView.isSelectable = true
            cancelOrderValidationView.isHidden = true
        }
    }
    
}
