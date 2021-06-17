//
//  AppDelegate.swift
//  GemSpot
//
//  Created by Jaydeep on 30/03/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import IQKeyboardManagerSwift
import CoreLocation
import Firebase
import FirebaseCrashlytics
import FirebaseMessaging
import SwiftyJSON
import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK:- Variable Declaration
    
    var window: UIWindow?
    var objTabbar = TabBarController()
    var objUser: ClsUserLoginModel?
    var locationManager = CLLocationManager()
    var lattitude  = Double()
    var longitude = Double()
    let notificationCenter = UNUserNotificationCenter.current()
    
    //MARK:- Appdelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        //        UserDefaults.standard.value(forKey: "test") as! String
        //        fatalError()
        printFonts()
        
        IQKeyboardManager.shared.enable = true
        
        if(getCustomObject(key: USER_LOGIN_INFO) != nil){
            self.objUser = getCustomObject(key: USER_LOGIN_INFO) as? ClsUserLoginModel
        }
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        setUpQuickLocationUpdate()
        
        application.registerForRemoteNotifications()
        
        notificationCenter.delegate = self
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        
        Messaging.messaging().delegate = self
        
        DropDown.startListeningToKeyboard()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }

}

//MARK:- Location Delegate

extension AppDelegate:CLLocationManagerDelegate {
    
    func setUpQuickLocationUpdate()
    {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 10
        locationManager.activityType = .automotiveNavigation
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latestLocation = locations.last {
            
            print("latestLocation:=\(latestLocation.coordinate.latitude), *=\(latestLocation.coordinate.longitude)")
            
            if latestLocation == nil
            {
                setUpQuickLocationUpdate()
                return
            }
            
            kCurrentUserLocation = latestLocation
            
            if lattitude != latestLocation.coordinate.latitude && longitude != latestLocation.coordinate.longitude
            {
                kCurrentUserLocation = latestLocation
                lattitude = latestLocation.coordinate.latitude
                longitude = latestLocation.coordinate.longitude
                //                self.delegate?.didUpdateLocation(lat:lattitude,lon:longitude)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            // setupUserCurrentLocation()
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // If always authorized
            //  setupUserCurrentLocation()
            manager.startUpdatingLocation()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            if #available(iOS 10.0, *) {
                openSetting()
            } else {
                // Fallback on earlier versions
            }
            break
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            if #available(iOS 10.0, *) {
                openSetting()
            } else {
                // Fallback on earlier versions
            }
            break
            //   default:
        // break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error :- \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        locationManager.stopUpdatingLocation()
    }
    
    //MARK:- open Setting
    
    func openSetting()
    {
        let alertController = UIAlertController (title: APP_NAME, message: "Go to setting?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Setting", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        alertController.addAction(settingsAction)
        //     let cancelAction = UIAlertAction(title: mapping.string(forKey: "Cancel_key"), style: .default, handler: nil)
        //    alertController.addAction(cancelAction)
        
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
}

//MARK:- Firebase Delegate

extension AppDelegate:MessagingDelegate {
    

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        print("device token \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined())")
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        Messaging.messaging().apnsToken = deviceToken
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(8), execute: {
            InstanceID.instanceID().instanceID { (result, error) in
                if let error = error {
                    print("Error fetching remote instance ID: \(error)")
                } else if let result = result {
                    print("Remote instance ID token: \(result.token)")
                    if(getCustomObject(key: USER_LOGIN_INFO) != nil){
                        self.updateFCMToken(token: result.token)
                    }
                }
            }
        })
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error Notification register: \(error.localizedDescription)")
    }
    
    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        print("Firebase registration token: \(fcmToken)")
//
//        let dataDict:[String: String] = ["token": fcmToken]
//        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
//    }
    
    func updateFCMToken(token : String)
    {
        if(getCustomObject(key: USER_LOGIN_INFO) != nil){
            let param : [String : AnyObject] = ["device_token":token as AnyObject]
            print(param)
            ServiceManager.callAPI(url: URL_UPDATE_DEVICE_TOKEN, parameter: param,isShowLoader: false,success: { (response) in
                print("Response \(response)")
                
               ServiceManager.callAPI(url: URL_RESET_BADGE, parameter: param,isShowLoader: false,success: { (response) in
                   print("Response \(response)")
                   
               }, failure: { (error) in
                   makeToast(strMessage: error)
               }, connectionFailed: {(msg) in
                   makeToast(strMessage: msg)
               })
                
            }, failure: { (error) in
                makeToast(strMessage: error)
            }, connectionFailed: {(msg) in
                makeToast(strMessage: msg)
            })
        }
    }
}

//MARK:- Notifcation Delegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Push response \(JSON(notification.request.content.userInfo))")
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if(getCustomObject(key: USER_LOGIN_INFO) == nil){
            return
        }
        
        let dictPush = JSON(response.notification.request.content.userInfo)
        print("dictPushData \(dictPush)")
        if dictPush["type"].stringValue == "post_like" {
            /*if isOnSocialTab {
             NotificationCenter.default.post(name: .didUpdateFeedOnPush, object: nil, userInfo: nil)
             } else if isOnCommentTab {
             NotificationCenter.default.post(name: .didUpdateFeedOnPush, object: nil, userInfo: nil)
             } else{*/
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                if let currentNavController = self.objTabbar.selectedViewController as? UINavigationController {
                    let obj = homeStoryboard.instantiateViewController(withIdentifier: "PostDetailVC") as! PostDetailVC
                    obj.hidesBottomBarWhenPushed = true
                    obj.isComeFromPush = true
                    obj.strPostToken = dictPush["post_token"].stringValue
                    currentNavController.isNavigationBarHidden = false
                    currentNavController.pushViewController(obj, animated: true)
                }
            })
            //            }
        } else if dictPush["type"].stringValue == "post_comment" || dictPush["type"].stringValue == "comment_like"{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                if let currentNavController = self.objTabbar.selectedViewController as? UINavigationController {
                    let obj = homeStoryboard.instantiateViewController(withIdentifier: "PostDetailVC") as! PostDetailVC
                    obj.hidesBottomBarWhenPushed = true
                    obj.isComeFromPush = true
                    obj.isCommentPush = true
                    obj.strPostToken = dictPush["post_token"].stringValue
                    currentNavController.isNavigationBarHidden = false
                    currentNavController.pushViewController(obj, animated: true)
                }
            })
        }
        else if dictPush["type"].stringValue == "user_follow" {
            /*if isOnProfileTab {
             NotificationCenter.default.post(name: .didUpdateUserOnPush, object: nil, userInfo: nil)
             } else if isOnOtherProfileTab {
             NotificationCenter.default.post(name: .didUpdateUserOnPush, object: nil, userInfo: nil)
             } else {*/
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                if let currentNavController = self.objTabbar.selectedViewController as? UINavigationController {
                    let obj = profileStoryboard.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC
                    obj.hidesBottomBarWhenPushed = true
                    obj.isComeFromPush = true
                    obj.userToken = dictPush["user_token"].stringValue
                    currentNavController.isNavigationBarHidden = false
                    currentNavController.pushViewController(obj, animated: true)
                }
            })
            //            }
        } else if dictPush["type"].stringValue == "post_added" {
            /*if isOnProfileTab {
             NotificationCenter.default.post(name: .didUpdateUserOnPush, object: nil, userInfo: nil)
             } else if isOnOtherProfileTab {
             NotificationCenter.default.post(name: .didUpdateUserOnPush, object: nil, userInfo: nil)
             } else {*/
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                if let currentNavController = self.objTabbar.selectedViewController as? UINavigationController {
                    let obj = homeStoryboard.instantiateViewController(withIdentifier: "PostDetailVC") as! PostDetailVC
                    obj.hidesBottomBarWhenPushed = true
                    obj.isComeFromPush = true
                    obj.strPostToken = dictPush["post_token"].stringValue
                    currentNavController.isNavigationBarHidden = false
                    currentNavController.pushViewController(obj, animated: true)
                }
            })
            //            }
        }
        
        completionHandler()
    }

}



