//
//  AIGlobals.swift
//  Swift3CodeStructure
//
//  Created by Ravi Alagiya on 25/11/2016.
//  Copyright © 2016 Ravi Alagiya. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

//MARK: - GENERAL
let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

//MARK: - MANAGERS
let ServiceManager = AIServiceManager.sharedManager
//let UserManager = AIUser.sharedManager

//MARK: - APP SPECIFIC
let APP_NAME = "Sights"

let DCRYPTION_KEY = "ActKnock1xW"

let APP_SECRET = "Gram1042020Spot"
let USER_AGENT = "Gram1042020Spot"

let AKLATITUDE = "AKLATITUDE"
let AKLONGITUDE = "AKLONGITUDE"

let AKUSERNAME = "AKUSERNAME"
let AKPASSWORD = "AKPASSWORD"


//MARK: - ERROR
let CUSTOM_ERROR_DOMAIN = "CUSTOM_ERROR_DOMAIN"
let CUSTOM_ERROR_USER_INFO_KEY = "CUSTOM_ERROR_USER_INFO_KEY"
let DEFAULT_ERROR = "Something went wrong, please try again later."
let INTERNET_ERROR = "Please check your internet connection and try again."

let VERSION_NUMBER = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
let BUILD_NUMBER = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
var SYSTEM_VERSION = UIDevice.current.systemVersion
var DEVICE_UUID = UIDevice.current.identifierForVendor?.uuidString

//MARK:- Key Store
let USER_LOGIN_INFO = "USER_LOGIN_INFO"


//MARK: - SCREEN SIZE
let NAVIGATION_BAR_HEIGHT:CGFloat = 64
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_WIDTH = UIScreen.main.bounds.size.width

func GET_PROPORTIONAL_WIDTH (_ width:CGFloat) -> CGFloat {
	return ((SCREEN_WIDTH * width)/375)
}
func GET_PROPORTIONAL_HEIGHT (_ height:CGFloat) -> CGFloat {
	return ((SCREEN_HEIGHT * height)/667)
}

func GET_PROPORTIONAL_WIDTH_CELL (_ width:CGFloat) -> CGFloat {
	return ((SCREEN_WIDTH * width)/375)
}
func GET_PROPORTIONAL_HEIGHT_CELL (_ height:CGFloat) -> CGFloat {
	return ((SCREEN_WIDTH * height)/667)
}

// MARK: - KEYS FOR USERDEFAULTS

let DeviceToken = "DeviceToken"

let IS_SIGNUP = "isSignup"

var kCurrentUserLocation = CLLocation()


func convertIntoJSONString(arrayObject: [Any]) -> String? {

    do {
        let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
        if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
            return jsonString as String
        }
        
    } catch let error as NSError {
        print("Array convertIntoJSON - \(error.description)")
    }
    return nil
}

