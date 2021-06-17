//
//  SplashLoginVC.swift
//  GemSpot
//
//  Created by Jaydeep on 30/03/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON

class SplashLoginVC: UIViewController {
    
    //MARK:- Variable Declaration
       
    var dictFBUser = JSON()

    //MARK:- Outlet Zone
    
    @IBOutlet weak var btnSignUpOutlet:UIButton!
    
    //MARK:- ViewLife Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        if (getCustomObject(key: USER_LOGIN_INFO) != nil) {
            appDelegate.objTabbar = TabBarController()
            appDelegate.objTabbar.selectedIndex = 0
            self.navigationController?.pushViewController(appDelegate.objTabbar, animated: true)
        }
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
                                      value: UIColor.white,
                                      range: NSRange(location: 0, length: interactableText.length))
        
        interactableText.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: UIColor.white , range: rangePolicy)
        interactableText.addAttribute(NSAttributedString.Key.font,
                                      value: themeFont(size: 14, fontname: .extraBold),
                                      range: rangePolicy)
        
        btnSignUpOutlet.setAttributedTitle(interactableText, for: .normal)
    }


    //MARK:- Action Zone
    
    @IBAction func btnLoginEmailAction(_ sender:UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnSignUpction(_ sender:UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnFBLoginAction(_ sender:UIButton) {
        facebooklogin()
    }
}

//MARK:- Login With Facebook

extension SplashLoginVC{
    
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
                self.dictFBUser = JSON(result)
                print("\n\n  fetched user: \(self.dictFBUser)")
                var param = [String:AnyObject]()
                param["facebook_id"] = self.dictFBUser["id"].stringValue as AnyObject
                self.apiCallForSocialLoginUser(param: param)
             }
        })
     }
}

//MARK:- API

extension SplashLoginVC {
    
    func apiCallForSocialLoginUser(param:[String:AnyObject])  {
        ServiceManager.callAPI(url: URL_CHECK_FB_ID, parameter: param, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
                    obj.dictFB = self.dictFBUser
                    self.navigationController?.pushViewController(obj, animated: true)
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
    
}
