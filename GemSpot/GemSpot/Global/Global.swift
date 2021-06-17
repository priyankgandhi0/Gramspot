//
//  Global.swift
//  GemSpot
//
//  Created by Jaydeep on 30/03/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import Foundation
import UIKit
import DropDown
import MaterialComponents
import AVFoundation
import SwiftyJSON

let rigthHomeDD = DropDown()
let rigthProfileDD = DropDown()
let rigthDiscoverDD = DropDown()
var btnHomeRight = CustomButton()
var btnDiscoverRight = CustomButton()
//var isComeFromPush:Bool = false
//var dictPushData = JSON()
var dictSelectedAnnotation : ClsPostListModel?

//MARK:- Appdelegate

let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
let notificationStoryboard = UIStoryboard(name: "Notification", bundle: nil)
let postStoryboard = UIStoryboard(name: "MyPost", bundle: nil)
let customeCameraStoryboard = UIStoryboard(name: "CustomCamera", bundle: nil)

//MARK: - COLORS
let APP_THEME_RED_COLOR                 = #colorLiteral(red: 0.9960784314, green: 0.3490196078, blue: 0.3490196078, alpha: 1)
let APP_THEME_GRAY_COLOR                = #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)
let APP_THEME_GREEN_COLOR               = #colorLiteral(red: 0.2274509804, green: 0.8784313725, blue: 0.4039215686, alpha: 1)
let APP_THEME_BLUE_COLOR                = #colorLiteral(red: 0.231372549, green: 0.3490196078, blue: 0.6, alpha: 1)
let APP_THEME_BLACK_COLOR               = #colorLiteral(red: 0.2549019608, green: 0.262745098, blue: 0.2588235294, alpha: 1)

let mapEdgePadding = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)

//MARK:- print fonts

func printFonts()
{
    let fontFamilyNames = UIFont.familyNames
    for familyName in fontFamilyNames {
        print("------------------------------")
        print("Font Family Name = [\(familyName)]")
        let names = UIFont.fontNames(forFamilyName: familyName)
        print("Font Names = [\(names)]")
    }
}

var arrDefaultTagList = [ClsTagListModel]()

//MARK: - Set Toaster

func makeToast(strMessage : String){
    let messageSnack = MDCSnackbarMessage()
    messageSnack.text = strMessage
    MDCSnackbarManager.show(messageSnack)
}

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

var arrMainSelectedImage = [ClsPostListPostImage]()

func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
    DispatchQueue.global().async { //1
        let asset = AVAsset(url: url) //2
        let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
        avAssetImageGenerator.appliesPreferredTrackTransform = true //4
        let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
        do {
            let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
            let thumbImage = UIImage(cgImage: cgThumbImage) //7
            DispatchQueue.main.async { //8
                completion(thumbImage) //9
            }
        } catch {
            print(error.localizedDescription) //10
            DispatchQueue.main.async {
                completion(nil) //11
            }
        }
    }
}

func apiCallingFromLogout() {
    ServiceManager.callAPI(url: URL_LOGOUT, parameter: [:],isShowLoader: false,success: { (response) in
        print("Response \(response)")
        appDelegate.notificationCenter.removeAllPendingNotificationRequests()
        appDelegate.notificationCenter.removeAllDeliveredNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
        appDelegate.objUser = nil
        removeObjectForKey(USER_LOGIN_INFO)
        let obj = mainStoryboard.instantiateViewController(withIdentifier: "SplashLoginVC") as! SplashLoginVC
        let nav = UINavigationController(rootViewController: obj)
        nav.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = nav
    }, failure: { (error) in
        makeToast(strMessage: error)
    }, connectionFailed: {(msg) in
        makeToast(strMessage: msg)
    })
}

func forceLogout() {
    appDelegate.notificationCenter.removeAllPendingNotificationRequests()
    appDelegate.notificationCenter.removeAllDeliveredNotifications()
    UIApplication.shared.applicationIconBadgeNumber = 0
    appDelegate.objUser = nil
    removeObjectForKey(USER_LOGIN_INFO)
    let obj = mainStoryboard.instantiateViewController(withIdentifier: "SplashLoginVC") as! SplashLoginVC
    let nav = UINavigationController(rootViewController: obj)
    nav.isNavigationBarHidden = true
    appDelegate.window?.rootViewController = nav
}
