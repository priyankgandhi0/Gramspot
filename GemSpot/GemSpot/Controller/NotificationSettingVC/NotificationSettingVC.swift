//
//  NotificationSettingVC.swift
//  GemSpot
//
//  Created by Jaydeep on 04/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit

class NotificationSettingVC: UIViewController {
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var btnFollowerPostOutlet:UIButton!
    @IBOutlet weak var btnOwnPostOutlet:UIButton!
    
    //MARK:- ViewLife Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnOwnPostOutlet.isSelected = appDelegate.objUser?.isPushOwnPost == 0 ? true : false
        self.btnFollowerPostOutlet.isSelected = appDelegate.objUser?.isPushFollowerPost == 0 ? true : false
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

extension NotificationSettingVC {
    
    @IBAction func btnChangeAction(_ sender:UIButton) {
        sender.isSelected.toggle()
        if sender.tag == 0 {
            let param = ["status":sender.isSelected == true ? "0" as AnyObject : "1" as AnyObject,
                         "flag":"1" as AnyObject]
            updateNotificationSetting(param: param)
            let dict = appDelegate.objUser
            dict?.isPushFollowerPost = sender.isSelected == true ? 0 : 1
            appDelegate.objUser = dict
            setCustomObject(value: appDelegate.objUser!, key: USER_LOGIN_INFO)
        } else if sender.tag == 1 {
            
        } else if sender.tag == 2 {
            let param = ["status":sender.isSelected == true ? "0" as AnyObject : "1" as AnyObject,
                         "flag":"2" as AnyObject]
            updateNotificationSetting(param: param)
            let dict = appDelegate.objUser
            dict?.isPushOwnPost = sender.isSelected == true ? 0 : 1
            appDelegate.objUser = dict
            setCustomObject(value: appDelegate.objUser!, key: USER_LOGIN_INFO)
        }
    }
}

//MARK:- API

extension NotificationSettingVC {
    
    func updateNotificationSetting(param : [String : AnyObject])
    {
        ServiceManager.callAPI(url: URL_UPDATE_NOTIFICATION_SETTING, parameter: param,isShowLoader: false,success: { (response) in
            print("Response \(response)")
            
        }, failure: { (error) in
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            makeToast(strMessage: msg)
        })
        
    }
}
