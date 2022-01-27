//
//  AddAddressViewController.swift
//  Actorpay
//
//  Created by iMac on 04/01/22.
//

import UIKit
import Alamofire
import GoogleMaps

class AddAddressViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var mapCenterPinImage: UIImageView!
    @IBOutlet private weak var pinImageVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bgView: UIView! {
        didSet {
            topCorner(bgView: bgView, maskToBounds: true)
        }
    }
    @IBOutlet weak var addressTypeTextField: UITextField! {
        didSet {
            addressTypeTextField.delegate = self
        }
    }
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.delegate = self
        }
    }
    @IBOutlet weak var addressLine1TextField: UITextField!{
        didSet {
            addressLine1TextField.delegate = self
        }
    }
    
    @IBOutlet weak var stateTextField: UITextField!{
        didSet {
            stateTextField.delegate = self
        }
    }
    
    @IBOutlet weak var addressLine2TextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!{
        didSet {
            zipcodeTextField.delegate = self
        }
    }
    @IBOutlet weak var landMarkTextField: UITextField!{
        didSet {
            landMarkTextField.delegate = self
        }
    }
    @IBOutlet weak var cityTextField: UITextField!{
        didSet {
            cityTextField.delegate = self
        }
    }
    @IBOutlet weak var countryTextField: UILabel! {
        didSet {
            countryTextField.text = AppManager.shared.countryName
        }
    }
    @IBOutlet weak var countryImageView: UIImageView! {
        didSet {
            countryImageView.image = UIImage(named: AppManager.shared.countryFlag)
        }
    }
    @IBOutlet weak var primaryContactTextField: UITextField!{
        didSet {
            primaryContactTextField.delegate = self
        }
    }
    @IBOutlet weak var countryCodeImageView: UIImageView! {
        didSet {
            countryCodeImageView.image = UIImage(named: AppManager.shared.countryFlag)
        }
    }
    @IBOutlet weak var countryCodeLbl: UILabel! {
        didSet {
            countryCodeLbl.text = AppManager.shared.countryCode
        }
    }
    @IBOutlet weak var secondaryContactTextField: UITextField!{
        didSet {
            secondaryContactTextField.delegate = self
        }
    }
    @IBOutlet weak var countryCode2ImageView: UIImageView! {
        didSet {
            countryCode2ImageView.image = UIImage(named: AppManager.shared.countryFlag)
        }
    }
    @IBOutlet weak var countryCode2Lbl: UILabel! {
        didSet {
            countryCode2Lbl.text = AppManager.shared.countryCode
        }
    }
    @IBOutlet weak var addressTypeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLine1Label: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var landMarkLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var primaryContactLabel: UILabel!
    @IBOutlet weak var secondaryContactLabel: UILabel!
    
    
    var isEditAddress = false
    var addressItem: AddressItems?
    
    private let locationManager = CLLocationManager()
    var latitude: Double?
    var longitude: Double?
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupGoogleMap()
        if isEditAddress == true {
            self.setEditAddressData()
        }
    }
    
    //MARK: - Selectors -

    //Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Phone Code Button Action
    @IBAction func phoneCodeBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let countriesVC = self.storyboard?.instantiateViewController(withIdentifier: "CountryViewController") as! CountryViewController
        countriesVC.onCompletion = {(code,flag,country) in
            AppManager.shared.countryCode = ""
            AppManager.shared.countryFlag = ""
            if let url = URL(string: flag) {
                self.countryCodeImageView.sd_setImage(with: url, completed: nil)
                self.countryCode2ImageView.sd_setImage(with: url, completed: nil)
                self.countryImageView.sd_setImage(with: url, completed: nil)
            }
            self.countryCodeLbl.text = code
            self.countryCode2Lbl.text = code
            self.countryTextField.text = country
            
        }
        let navC = UINavigationController.init(rootViewController: countriesVC)
        self.present(navC, animated: true, completion: nil)
    }
    
    //Save Button Action
    @IBAction func saveButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if addressValidation() {
            if isEditAddress == false {
                addAddressApi()
            } else {
                editAddressApi()
            }
        }
    }
    
    // MARK: - Helper Functions -
    
    func setupGoogleMap(){
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
          locationManager.requestLocation()
            googleMapView.isMyLocationEnabled = true
            googleMapView.settings.myLocationButton = true
        } else {
          locationManager.requestWhenInUseAuthorization()
        }
        
        googleMapView.delegate = self
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
      let geocoder = GMSGeocoder()
      showLoading()
      geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
        dissmissLoader()
        self.addressLine1TextField.unlock()
        
        guard let address = response?.firstResult() else { return }
        
        self.latitude = address.coordinate.latitude
        self.longitude = address.coordinate.longitude
        self.addressLine1TextField.text = address.lines?.joined()
        self.landMarkTextField.text = address.subLocality
        self.cityTextField.text = address.locality
        self.stateTextField.text = address.administrativeArea
        self.zipcodeTextField.text = address.postalCode
        
        let labelHeight = self.addressLine1TextField.intrinsicContentSize.height
        let topInset = self.view.safeAreaInsets.top
        self.googleMapView.padding = UIEdgeInsets(
          top: topInset,
          left: 0,
          bottom: labelHeight,
          right: 0)
        
        UIView.animate(withDuration: 0.25) {
          self.pinImageVerticalConstraint.constant = (labelHeight - topInset) * 0.5
          self.view.layoutIfNeeded()
        }
      }
    }
    // Address Validation
    func addressValidation() -> Bool {
        var isValidate = true
        if addressTypeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            addressTypeLabel.isHidden = false
            addressTypeLabel.text =  ValidationManager.shared.addressType
            isValidate = false
        } else {
            addressTypeLabel.isHidden = true
        }
        if nameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            nameLabel.isHidden = false
            nameLabel.text =  ValidationManager.shared.addName
            isValidate = false
        } else {
            nameLabel.isHidden = true
        }
        
        if addressLine1TextField.text?.trimmingCharacters(in: .whitespaces).count ?? 0 < 3 {
            addressLine1Label.isHidden = false
            addressLine1Label.text =  ValidationManager.shared.addressLine1
            isValidate = false
        } else {
            addressLine1Label.isHidden = true
        }
        
        if zipcodeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            zipcodeLabel.isHidden = false
            zipcodeLabel.text =  ValidationManager.shared.zipcode
            isValidate = false
        } else {
            zipcodeLabel.isHidden = true
        }
        
        if landMarkTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            landMarkLabel.isHidden = false
            landMarkLabel.text =  ValidationManager.shared.landmark
            isValidate = false
        } else {
            landMarkLabel.isHidden = true
        }
        
        if cityTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            cityLabel.isHidden = false
            cityLabel.text =  ValidationManager.shared.city
            isValidate = false
        } else {
            cityLabel.isHidden = true
        }
        
        if stateTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            stateLabel.isHidden = false
            stateLabel.text =  ValidationManager.shared.state
            isValidate = false
        } else {
            stateLabel.isHidden = true
        }
        
        if primaryContactTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            primaryContactLabel.isHidden = false
            primaryContactLabel.text =  ValidationManager.shared.contact
            isValidate = false
        } else if !isValidMobileNumber(mobileNumber: primaryContactTextField.text ?? "") {
            primaryContactLabel.isHidden = false
            primaryContactLabel.text =  ValidationManager.shared.contact
            isValidate = false
        }
        else {
            primaryContactLabel.isHidden = true
        }
        
        if secondaryContactTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            secondaryContactLabel.isHidden = false
            secondaryContactLabel.text =  ValidationManager.shared.contact
            isValidate = false
        } else if !isValidMobileNumber(mobileNumber: secondaryContactTextField.text ?? "") {
            secondaryContactLabel.isHidden = false
            secondaryContactLabel.text =  ValidationManager.shared.contact
            isValidate = false
        }
        else {
            secondaryContactLabel.isHidden = true
        }
        
        return isValidate
    }
    
    // Setup Edit Address Data
    func setEditAddressData() {
        addressTypeTextField.text = addressItem?.title
        landMarkTextField.text = addressItem?.area
        addressLine1TextField.text = addressItem?.addressLine1
        addressLine2TextField.text = addressItem?.addressLine2
        zipcodeTextField.text = addressItem?.zipCode
        cityTextField.text = addressItem?.city
        stateTextField.text = addressItem?.state
        primaryContactTextField.text = addressItem?.primaryContactNumber
        secondaryContactTextField.text = addressItem?.secondaryContactNumber
    }
    
}

//MARK: - Extension -

//MARK: Api Call
extension AddAddressViewController {
    // Add Shipping Address Api
    func addAddressApi() {
        let params: Parameters = [
            "userId": AppManager.shared.userId,
            "name":"\(nameTextField.text ?? "")",
            "title":"\(addressTypeTextField.text ?? "")",
            "area":"\(landMarkTextField.text ?? "")",
            "extensionNumber":"\(countryCodeLbl.text ?? "")",
            "primaryContactNumber":"\(primaryContactTextField.text ?? "")",
            "secondaryContactNumber":"\(secondaryContactTextField.text ?? "")",
            "primary":true,
            "addressLine1":"\(addressLine1TextField.text ?? "")",
            "addressLine2":"\(addressLine2TextField.text ?? "")",
            "zipCode":"\(zipcodeTextField.text ?? "")",
            "city":"\(cityTextField.text ?? "")",
            "state":"\(stateTextField.text ?? "")",
            "country":"\(countryTextField.text ?? "")",
            "latitude":self.latitude ?? 0,
            "longitude":self.longitude ?? 0
        ]
        showLoading()
        APIHelper.addAddressAPI(params: params) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                print(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                NotificationCenter.default.post(name: NSNotification.Name("getAllShippingAddressListApi"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // Edit Address Api
    func editAddressApi() {
        let params: Parameters = [
            "userId": AppManager.shared.userId,
            "id":addressItem?.id ?? "",
            "name":"\(nameTextField.text ?? "")",
            "title":"\(addressTypeTextField.text ?? "")",
            "area":"\(landMarkTextField.text ?? "")",
            "extensionNumber":"+91",
            "primaryContactNumber":"\(primaryContactTextField.text ?? "")",
            "secondaryContactNumber":"\(secondaryContactTextField.text ?? "")",
            "primary":true,
            "addressLine1":"\(addressLine1TextField.text ?? "")",
            "addressLine2":"\(addressLine2TextField.text ?? "")",
            "zipCode":"\(zipcodeTextField.text ?? "")",
            "city":"\(cityTextField.text ?? "")",
            "state":"\(stateTextField.text ?? "")",
            "country":"\(countryTextField.text ?? "")",
            "latitude":self.latitude ?? 0,
            "longitude":self.longitude ?? 0
        ]
        showLoading()
        APIHelper.updateShippingAddressApi(params: params) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                NotificationCenter.default.post(name: NSNotification.Name("getAllShippingAddressListApi"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

//MARK: Text Field Delegate Methods
extension AddAddressViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case addressTypeTextField:
            if addressTypeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                addressTypeLabel.isHidden = false
                addressTypeLabel.text =  ValidationManager.shared.addressType
            } else {
                addressTypeLabel.isHidden = true
            }
        case nameTextField :
            if nameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                nameLabel.isHidden = false
                nameLabel.text =  ValidationManager.shared.addName
            } else {
                nameLabel.isHidden = true
            }
        case primaryContactTextField:
            if primaryContactTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                primaryContactLabel.isHidden = false
                primaryContactLabel.text =  ValidationManager.shared.contact
            } else if !isValidMobileNumber(mobileNumber: primaryContactTextField.text ?? "") {
                primaryContactLabel.isHidden = false
                primaryContactLabel.text =  ValidationManager.shared.contact
            }
            else {
                primaryContactLabel.isHidden = true
            }
        case secondaryContactTextField:
            if secondaryContactTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                secondaryContactLabel.isHidden = false
                secondaryContactLabel.text =  ValidationManager.shared.contact

            } else if !isValidMobileNumber(mobileNumber: secondaryContactTextField.text ?? "") {
                secondaryContactLabel.isHidden = false
                secondaryContactLabel.text =  ValidationManager.shared.contact
            }
            else {
                secondaryContactLabel.isHidden = true
            }
        case addressLine1TextField:
            if addressLine1TextField.text?.trimmingCharacters(in: .whitespaces).count ?? 0 < 3 {
                addressLine1Label.isHidden = false
                addressLine1Label.text =  ValidationManager.shared.addressLine1
            } else {
                addressLine1Label.isHidden = true
            }
        case zipcodeTextField:
            if zipcodeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                zipcodeLabel.isHidden = false
                zipcodeLabel.text =  ValidationManager.shared.zipcode
            } else {
                zipcodeLabel.isHidden = true
            }
        case landMarkTextField:
            if landMarkTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                landMarkLabel.isHidden = false
                landMarkLabel.text =  ValidationManager.shared.landmark
            } else {
                landMarkLabel.isHidden = true
            }

        case cityTextField:
            if cityTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                cityLabel.isHidden = false
                cityLabel.text =  ValidationManager.shared.city
            } else {
                cityLabel.isHidden = true
            }
        case stateTextField:
            if stateTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                stateLabel.isHidden = false
                stateLabel.text =  ValidationManager.shared.state
            } else {
                stateLabel.isHidden = true
            }
        default:
            break
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension AddAddressViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedWhenInUse else {
      return
    }    
    locationManager.requestLocation()
    googleMapView.isMyLocationEnabled = true
    googleMapView.settings.myLocationButton = true
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
    
    googleMapView.camera = GMSCameraPosition(
      target: location.coordinate,
      zoom: 15,
      bearing: 0,
      viewingAngle: 0)
//    fetchPlaces(near: location.coordinate)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}

// MARK: - GMSMapViewDelegate
extension AddAddressViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocode(coordinate: position.target)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            mapCenterPinImage.fadeIn(0.25)
            mapView.selectedMarker = nil
        }
    }
    
    //  func googleMapView(_ googleMapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
    ////    guard let placeMarker = marker as? PlaceMarker else {
    ////      return nil
    ////    }
    ////    guard let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView else {
    ////      return nil
    ////    }
    //
    ////    infoView.nameLabel.text = marker.place.name
    ////    addressLine1TextField.text = marker.
    //
    //    return infoView
    //  }
    
    func googleMapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapCenterPinImage.fadeOut(0.25)
        return false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        mapCenterPinImage.fadeIn(0.25)
        mapView.selectedMarker = nil
        return false
    }
}
