//
//  SignupVC.swift
//  GemSpot
//
//  Created by Jaydeep on 30/03/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import CountryPickerView
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON

class SignupVC: UIViewController {
    
    //MARK:- Variable Declaration
    
    var dictFB = JSON()
    let cpvInternal = CountryPickerView()
    var strFacebookId = String()
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var btnSignInOutlet:UIButton!
    @IBOutlet weak var txtUsename:UITextField!
    @IBOutlet weak var txtFirstName:UITextField!
    @IBOutlet weak var txtLastName:UITextField!
    @IBOutlet weak var txtEmailAddress:UITextField!
    @IBOutlet weak var txtMobileNumber:UITextField!
    @IBOutlet weak var txtCountryCode:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    @IBOutlet weak var btnPasswordShow:UIButton!
    
    //MARK:- ViewLife Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        [cpvInternal].forEach {
            $0.delegate = self
        }
        
        [txtUsename,txtFirstName,txtLastName,txtEmailAddress,txtMobileNumber,txtCountryCode,txtPassword].forEach {
            $0.delegate = self
        }
        
        if dictFB["id"].exists() {
            setupFBData()
        }
    }
    
    func setupFBData() {
        print("dictFB \(dictFB)")
        
        let arrName = dictFB["name"].stringValue.components(separatedBy: " ")
        if arrName.count == 2 {
            self.txtFirstName.text  = arrName[0]
            self.txtLastName.text  = arrName[1]
        }
        
        self.txtEmailAddress.text = dictFB["email"].stringValue
        strFacebookId = dictFB["id"].stringValue
        
    }
    
    //MARK:- Setup UI
    
    func setupUI() {
        let str1 = "Already have an account?"
        let str2 = "Sign in".localized
        
        let str = str1 + " " + str2
        let interactableText = NSMutableAttributedString(string:str)
        
        let rangePolicy = (str as NSString).range(of: str2, options: .caseInsensitive)
        
        interactableText.addAttribute(NSAttributedString.Key.font,
                                      value: themeFont(size: 14, fontname: .regular),
                                      range: NSRange(location: 0, length: interactableText.length))
        
        interactableText.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: APP_THEME_BLACK_COLOR , range: NSRange(location: 0, length: str.length))
        
        interactableText.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: APP_THEME_GREEN_COLOR , range: rangePolicy)
        interactableText.addAttribute(NSAttributedString.Key.font,
                                      value: themeFont(size: 14, fontname: .extraBold),
                                      range: rangePolicy)
        
        btnSignInOutlet.setAttributedTitle(interactableText, for: .normal)
    }


}

//MARK:- Action Zone

extension SignupVC {
    
    @IBAction func btnShowPasswordAction(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        txtPassword.isSecureTextEntry = sender.isSelected ? true : false
    }
    
    @IBAction func btnSignUpAction(_ sender:UIButton) {
        if (txtUsename.text?.trimString().isEmpty)! {
            makeToast(strMessage: "Please enter user name")
        } else if (txtFirstName.text?.trimString().isEmpty)! {
            makeToast(strMessage: "Please enter first name")
        } else if (txtLastName.text?.trimString().isEmpty)! {
            makeToast(strMessage: "Please enter last name")
        } else if (txtEmailAddress.text?.trimString().isEmpty)! {
            makeToast(strMessage: "Please enter email")
        } else if !(txtEmailAddress.text?.trimString().isValidEmail())! {
            makeToast(strMessage: "Please enter valid email")
        } else if (txtCountryCode.text?.trimString().isEmpty)! {
            makeToast(strMessage: "Please enter country code")
        } else if (txtMobileNumber.text?.trimString().isEmpty)! {
            makeToast(strMessage: "Please enter mobile number")
        } else if (txtPassword.text?.isEmpty)! {
            makeToast(strMessage: "Please enter password")
        } else if (txtPassword.text!.count < 6) {
            makeToast(strMessage: "Please enter password at least 6 character long")
        } else {
            var dict = [String:AnyObject]()
            let phone = txtCountryCode.text?.replacingOccurrences(of: "+", with: "")
            dict["username"] = txtFirstName.text?.trimString() as AnyObject
            dict["first_name"] = txtFirstName.text?.trimString() as AnyObject
            dict["last_name"] = txtLastName.text?.trimString() as AnyObject
            dict["email"] = txtEmailAddress.text?.trimString() as AnyObject
            dict["country_code"] = phone!.trimString() as AnyObject
            dict["phone"] = txtMobileNumber.text?.trimString() as AnyObject
            dict["facebook_id"] = strFacebookId as AnyObject
            dict["password"] = txtPassword.text?.trimString() as AnyObject
            apiCallForRegisterUser(param: dict)
        }
    }
    
    @IBAction func btnFBLoginAction(_ sender:UIButton) {
        facebooklogin()
    }
}

//MARK:- Textfield Delegate

extension SignupVC:UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtCountryCode {
            cpvInternal.showCountriesList(from: self)
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFirstName || textField == txtLastName {
            let aSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        } else if textField == txtMobileNumber {
            let aSet = NSCharacterSet(charactersIn:"1234567890").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")            
            let maxLength = 11
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return string == numberFiltered && newString.length <= maxLength
        }
        return true
    }
}

//MARK:- CountryPickerViewDelegate Delegate

extension SignupVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        print("Message \(message)")
        self.txtCountryCode.text = country.phoneCode
        self.txtMobileNumber.becomeFirstResponder()
    }
}

//MARK:- Login With Facebook

extension SignupVC{
    
    func facebooklogin() {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn(permissions: ["email"], from: self, handler: { (result, error) -> Void in
         if (error == nil) {
            let fbloginresult : LoginManagerLoginResult = result!
           if(fbloginresult.isCancelled) {
              //Show Cancel alert
           } else if(fbloginresult.grantedPermissions.contains("email")) {
               self.returnUserData()
               //fbLoginManager.logOut()
           }
          }
        })
    }

    func returnUserData() {
        let accessToken = AccessToken.current
        
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,picture.width(480).height(480)"], tokenString: accessToken != nil ? accessToken?.tokenString : nil, version: nil, httpMethod: .get)
       graphRequest.start(completionHandler: { (connection, result, error) -> Void in
          if ((error) != nil) {
              // Process error
            print("\n\n Error: \(String(describing: error))")
           } else {
                self.dictFB = JSON(result)
                print("\n\n  fetched user: \(self.dictFB)")
                var param = [String:AnyObject]()
                param["facebook_id"] = self.dictFB["id"].stringValue as AnyObject
                self.apiCallForSocialLoginUser(param: param)
             }
        })
     }
}

//MARK:- API

extension SignupVC {
    
    func apiCallForSocialLoginUser(param:[String:AnyObject])  {
        ServiceManager.callAPI(url: URL_CHECK_FB_ID, parameter: param, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    self.setupFBData()
                } else if let status = dictData["status"] as? Int, status == 2 {
                    if let dict  = dictData["data"] as? NSDictionary {
                        let dictRegi = ClsUserLoginModel(fromDictionary: dict)
                        appDelegate.objUser = dictRegi
                        setCustomObject(value: appDelegate.objUser!, key: USER_LOGIN_INFO)
                        appDelegate.objTabbar = TabBarController()
                        appDelegate.objTabbar.selectedIndex = 0
                        self.navigationController?.pushViewController(appDelegate.objTabbar, animated: true)
                    }
                } else {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                }
            }else{
                makeToast(strMessage: DEFAULT_ERROR)
            }
        }, failure: { (error) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: msg)
        })
    }
    
    func apiCallForRegisterUser(param:[String:AnyObject])  {
        ServiceManager.callAPI(url: URL_REGISTRATION, parameter: param, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let dict  = dictData["data"] as? NSDictionary {
                        let dictRegi = ClsUserLoginModel(fromDictionary: dict)
                        appDelegate.objUser = dictRegi
                        setCustomObject(value: appDelegate.objUser!, key: USER_LOGIN_INFO)
                        appDelegate.objTabbar = TabBarController()
                        appDelegate.objTabbar.selectedIndex = 0
                        self.navigationController?.pushViewController(appDelegate.objTabbar, animated: true)
                    }
                }  else {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                }
            }else{
                makeToast(strMessage: DEFAULT_ERROR)
            }
        }, failure: { (error) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: msg)
        })
    }
    
}
