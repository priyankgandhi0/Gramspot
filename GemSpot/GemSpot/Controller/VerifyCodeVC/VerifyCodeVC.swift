//
//  VerifyCodeVC.swift
//  GemSpot
//
//  Created by Jaydeep on 11/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit

class VerifyCodeVC: UIViewController {
    
    //MARK:- Varialble Declaration
    
    var strEmail = String()
    
    //MARK:- Outlet Zone
        
       @IBOutlet weak var txtVerifyCode: UITextField!
       @IBOutlet weak var txtNewPassword: UITextField!
       @IBOutlet weak var txtConfirmPassword: UITextField!
    
    //MARK:- ViewLife Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        let btnBack = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(btnBackAction(_:)))
        btnBack.tintColor = .white
        
        let btnBackTitle = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        btnBackTitle.tintColor = .white
        
        self.navigationItem.leftBarButtonItems = [btnBack,btnBackTitle]
    }
    
    //MARK:- Set Validation
    func validateUserInput() -> Bool {
        var error = ""
        if (txtVerifyCode.text?.trimString().isEmpty)! {
            error = "Please enter verify code"
        }  else if (txtNewPassword.text?.isEmpty)! {
            error = "Please enter new password"
        } else if (txtConfirmPassword.text?.isEmpty)! {
            error = "Please enter confirm password"
        } else if txtNewPassword.text != txtConfirmPassword.text {
            error = "Password and confirm password must be same"
        }
        if !error.isEmpty {
            makeToast(strMessage: error)
        }
        return error.isEmpty
    }

}

//MARK:- Action Zone

extension VerifyCodeVC {
    
    @IBAction func btnSendAction(_ sender:UIButton) {
        self.view.endEditing(true)
        guard self.validateUserInput() else {
           return
        }
        var param = [String:AnyObject]()
        param["email"] = strEmail as AnyObject
        param["verify_code"] = txtVerifyCode.text as AnyObject
        param["new_password"] = txtNewPassword.text as AnyObject
        apiCallingForVerifyForgotPassword(param: param)
    }
    
    @IBAction func btnPasswordToggleAction(_ sender:UIButton) {
        if sender.tag == 0 {
            sender.isSelected = !sender.isSelected
            txtNewPassword.isSecureTextEntry = sender.isSelected ? true : false
        } else {
            sender.isSelected = !sender.isSelected
            txtConfirmPassword.isSecureTextEntry = sender.isSelected ? true : false
        }
    }
}

//MARK:- API

extension VerifyCodeVC {
    
    func apiCallingForVerifyForgotPassword(param:[String:AnyObject])  {
        ServiceManager.callAPI(url: URL_CHANGE_PASSWORD_VERIFY, parameter: param, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: LoginVC.self) {
                            _ =  self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
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


