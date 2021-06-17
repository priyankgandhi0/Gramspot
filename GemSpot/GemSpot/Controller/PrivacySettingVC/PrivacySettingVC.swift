//
//  PrivacySettingVC.swift
//  GemSpot
//
//  Created by Jaydeep on 04/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import DropDown

class PrivacySettingVC: UIViewController {
    
    //MARK:- Variable Declaration
    
    var ddPrivacyMenu = DropDown()
    var activeTextfield = UITextField()
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var txtPost:UITextField!
    @IBOutlet weak var txtSavedPost:UITextField!
    
    //MARK:- View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let arrPrivacy =  ["Anyone","Only my followers","Only me"]
        ddPrivacyMenu.dataSource = arrPrivacy
        
        self.txtPost.text = arrPrivacy[appDelegate.objUser?.isPrivacyPost ?? 0]
        self.txtSavedPost.text = arrPrivacy[appDelegate.objUser?.isPrivacySavePost ?? 0]
        
        selectionIndex()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        
        let btnBack = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(btnBackAction(_:)))
        btnBack.tintColor = .white
        
        let btnBackTitle = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        btnBackTitle.tintColor = .white
        
        self.navigationItem.leftBarButtonItems = [btnBack,btnBackTitle]
    }

    func selectionIndex() {
        ddPrivacyMenu.selectionAction = {[weak self] index,item in
            
            if self?.txtPost == self?.activeTextfield {
                self?.txtPost.text =  item
                
                let param = ["status":index as AnyObject,
                             "flag":"1" as AnyObject]
                self?.updatePrivacySetting(param: param)
                let dict = appDelegate.objUser
                dict?.isPrivacyPost = index
                appDelegate.objUser = dict
                setCustomObject(value: appDelegate.objUser!, key: USER_LOGIN_INFO)
            } else {
                self?.txtSavedPost.text =  item
                let param = ["status":index as AnyObject,
                             "flag":"2" as AnyObject]
                self?.updatePrivacySetting(param: param)
                let dict = appDelegate.objUser
                dict?.isPrivacySavePost = index
                appDelegate.objUser = dict
                setCustomObject(value: appDelegate.objUser!, key: USER_LOGIN_INFO)
            }
            
        }
    }

}

//MARK:- textfiedl Delegate

extension PrivacySettingVC:UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtPost {
            configureDropdown(dropdown: ddPrivacyMenu, sender: txtPost)
        } else {
            configureDropdown(dropdown: ddPrivacyMenu, sender: txtSavedPost)
        }
        activeTextfield = textField
        ddPrivacyMenu.show()
        return false
    }
}

//MARK:- API

extension PrivacySettingVC {
    
    func updatePrivacySetting(param : [String : AnyObject])
    {
        ServiceManager.callAPI(url: URL_UPDATE_PRIVACY_SETTING, parameter: param,isShowLoader: false,success: { (response) in
            print("Response \(response)")
            
        }, failure: { (error) in
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            makeToast(strMessage: msg)
        })
        
    }
}
