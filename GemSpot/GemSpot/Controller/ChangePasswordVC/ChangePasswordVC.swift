//
//  ChangePasswordVC.swift
//  GemSpot
//
//  Created by Jaydeep on 02/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var txtOldPassword:UITextField!
    @IBOutlet weak var txtNewPassword:UITextField!
    @IBOutlet weak var txtConfirmPassword:UITextField!
    
    //MARK:- ViewLife Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [txtOldPassword,txtNewPassword,txtConfirmPassword].forEach { (txtField) in
            txtField?.delegate = self
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        
        let btnBack = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(btnBackAction(_:)))
        btnBack.tintColor = .white
        
        let btnBackTitle = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        btnBackTitle.tintColor = .white
        
        self.navigationItem.leftBarButtonItems = [btnBack,btnBackTitle]
    }
    
}

//MARK:- Action Zone

extension ChangePasswordVC {
    
    @IBAction func btnSubmitAction(_ sender:UIButton) {
        if (txtOldPassword.text?.isEmpty)! {
            makeToast(strMessage: "Please enter old password")
        } else if (txtNewPassword.text?.isEmpty)! {
            makeToast(strMessage: "Please enter new password")
        } else if (txtNewPassword.text!.count < 6) {
            makeToast(strMessage: "New password at least 6 character long")
        } else if (txtConfirmPassword.text?.isEmpty)! {
            makeToast(strMessage: "Please enter confirm password")
        } else if txtNewPassword.text != txtConfirmPassword.text {
             makeToast(strMessage: "Password and confirm password must be same")
        } else {
            var param = [String:AnyObject]()
            param["old_password"] = txtOldPassword.text as AnyObject
            param["new_password"] = txtNewPassword.text as AnyObject
            apiCallingForChangePassword(param: param)
        }
    }
    
    @IBAction func btnHideShowOldPasswordAction(_ sender:UIButton) {
        sender.isSelected.toggle()
        txtOldPassword.isSecureTextEntry = sender.isSelected
    }
    
    @IBAction func btnHideShowNewPasswordAction(_ sender:UIButton) {
        sender.isSelected.toggle()
        txtNewPassword.isSecureTextEntry = sender.isSelected
    }
    
    @IBAction func btnHideShowConfirmPasswordAction(_ sender:UIButton) {
        sender.isSelected.toggle()
        txtConfirmPassword.isSecureTextEntry = sender.isSelected
    }
    
}

//MARK:- Textfield Delegate

extension ChangePasswordVC:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

//MARK:- API

extension ChangePasswordVC {
    
    func apiCallingForChangePassword(param:[String:AnyObject])  {
        ServiceManager.callAPI(url: URL_CHANGE_PASSWORD, parameter: param, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                    appDelegate.objUser?.authToken = dictData["new_token"] as? String
                    setCustomObject(value: appDelegate.objUser!, key: USER_LOGIN_INFO)
                    self.navigationController?.popViewController(animated: true)
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
