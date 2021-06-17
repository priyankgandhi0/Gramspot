//
//  LoginVC.swift
//  GemSpot
//
//  Created by Jaydeep on 30/03/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import FirebaseMessaging

class LoginVC: UIViewController {
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var btnSignUpOutlet:UIButton!
    @IBOutlet weak var txtEmailAddress:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    
    //MARK:- ViewLife Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        [txtEmailAddress,txtPassword].forEach {
            $0.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK:- Setup UI
    
    func setupUI() {
        let str1 = "Don't have an account?"
        let str2 = "Sign Up"
        
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
        
        btnSignUpOutlet.setAttributedTitle(interactableText, for: .normal)
    }


    //MARK: Action
    
    @IBAction func btnLoginAction(_ sender:UIButton) {
        if (txtEmailAddress.text?.trimString().isEmpty)! {
            makeToast(strMessage: "Please enter email")
        } else if !(txtEmailAddress.text?.trimString().isValidEmail())! {
            makeToast(strMessage: "Please enter valid email")
        } else if (txtPassword.text?.trimString().isEmpty)! {
            makeToast(strMessage: "Please enter password")
        } else {
            var dict = [String:AnyObject]()
            dict["email"] = txtEmailAddress.text?.trimString() as AnyObject
            dict["password"] = txtPassword.text?.trimString() as AnyObject
            apiCallForLoginUser(param: dict)
        }
    }
    
    @IBAction func btnSignupAction(_ sender:UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnShowPasswordAction(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        txtPassword.isSecureTextEntry = sender.isSelected ? true : false
    }
    
    @IBAction func btnForgotPassword(_ sender:UIButton) {
        let obj = mainStoryboard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
}

//MARK:- Textfield Delegate

extension LoginVC:UITextFieldDelegate {
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}

//MARK:- API

extension LoginVC {
    
    func apiCallForLoginUser(param:[String:AnyObject])  {
        ServiceManager.callAPI(url: URL_LOGIN, parameter: param, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let dict  = dictData["data"] as? NSDictionary {
                        appDelegate.updateFCMToken(token: Messaging.messaging().fcmToken ?? "")
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
