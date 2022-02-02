//
//  ValidationManager.swift
//  Actorpay Merchant
//
//  Created by iMac on 05/01/22.
//

import Foundation

class ValidationManager {
    
    static let shared = ValidationManager()
  
    // Login
    let lEmail = "Oops! Your Email is Empty"
    // signup
    let sPhoneNumber = "Oops! Your Phone is Not Correct or Empty"
    let emptyPhone = "Oops! Your Phone is Empty"
    let emptyPhoneCode = "Oops! Your Phone Code is Empty"
    let validPhone = "Oops! Your Phone is Invalid"
    let sFirstName = "Oops! Your Name's Length is Less than 3"
    let sLastName = "Oops! Your Last Name's Length is Less than 3"
    let sEmail = "Oops! Your Email is Not Correct or Empty"
    let sEmailInvalid = "Oops! Your Email is Invalid"
    let sPassword = "Password should contain min of 8 characters and at least 1 lowercase, 1 symbol, 1 uppercase and 1 numeric value"
    let sGender = "Please Select Gender"
    let sDateOfBirth = "Please Select DOB"
    let sPanCard = "Enter Valid PAN"
    let sAdharCard = "Enter Valid Adhar"
    let sTermAccepted = "Please agree to our terms to sign up"
    // forgot Password
    let fPassEmail = "Oops! Your Email is Empty"
    let fPassEmailInvalid = "Oops! Your Email is Invalid"
    
    let verificationMessagePending = "Verification Pending"
    let verificationMessageVerify = "Verified"
    
    let emptyPassword = "Oops! Your Password is Empty"
    let validPassword = "Oops! Your Password is Invalid"
    let containPassword = "Password should contain min of 8 characters and at least 1 lowercase, 1 symbol, 1 uppercase and 1 numeric value"
    let misMatchPassword = "Oops! Your Password Mismatch"

    //Add Address
    
    let addressType  = "Please Enter Valid Address Type"
    let addName = "Please Enter Name"
    let addressLine1 = "Please Enter Address Line 1"
    let zipcode = "Please EEnter Valid Zipcode"
    let landmark = "Please Enter Valid Address Area"
    let city = "Please Enter City"
    let state = "Please Enter State"
    let contact = "Please Enter Valid Contact"
    
    let emptyCancelOrderDescription = "Please write reason"
    
}
