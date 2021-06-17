//
//  ForgotPasswordVC.swift
//  GemSpot
//
//  Created by Jaydeep on 11/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var txtEmail: UITextField!
    
    //MARK:- View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let btnBack = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(btnBackAction(_:)))
        btnBack.tintColor = .white
        
        let btnBackTitle = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        btnBackTitle.tintColor = .white
        
        self.navigationItem.leftBarButtonItems = [btnBack,btnBackTitle]
    }
    
    //MARK:- Set Validation
       func validateUserInput() -> Bool {
           var error = ""
           if txtEmail.text!.isEmpty {
               error = "Please enter email"
           } else if !(txtEmail.text?.trimString().isValidEmail())!{
               error = "Please enter valid email"
           }
           if !error.isEmpty {
               makeToast(strMessage: error)
           }
           return error.isEmpty
       }
}

//MARK:- Action Zone

extension ForgotPasswordVC {
    
    @IBAction func btnSendAction(_ sender:UIButton) {
        self.view.endEditing(true)
        guard self.validateUserInput() else {
           return
        }
        var dict = [String:AnyObject]()
        dict["email"] = txtEmail.text?.trimString() as AnyObject
        apiCallingForForgotPassword(param: dict)
    }
}

//MARK:- TextField delagate

extension ForgotPasswordVC:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

//MARK:- API

extension ForgotPasswordVC {
    
    func apiCallingForForgotPassword(param:[String:AnyObject])  {
        ServiceManager.callAPI(url: URL_FORGOT_PASSWORD, parameter: param, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                    let obj = mainStoryboard.instantiateViewController(withIdentifier: "VerifyCodeVC") as! VerifyCodeVC
                    obj.strEmail = self.txtEmail.text!
                    self.navigationController?.pushViewController(obj, animated: true)
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
