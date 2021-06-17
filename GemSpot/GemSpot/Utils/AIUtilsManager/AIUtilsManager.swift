
//
//  AIUtilsManager.swift
//  Swift3CodeStructure
//
//  Created by Ravi Alagiya on 25/11/2016.
//  Copyright © 2016 Ravi Alagiya. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MessageUI


// MARK: - INTERNET CHECK
func SHOW_INTERNET_ALERT(){
    HIDE_CUSTOM_LOADER()
    displayAlertWithTitle(APP_NAME, andMessage: "Please turn on data to use the \(APP_NAME) App.", buttons: ["Try Again"]) { (index) in
        /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController  = storyboard.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
        appDelegate.window?.rootViewController = tabBarController
        appDelegate.window?.makeKeyAndVisible()*/
    }
}

// MARK: - ALERT
func displayAlertWithMessage(_ message:String) -> Void {
    displayAlertWithTitle(APP_NAME, andMessage: message, buttons: ["Dismiss"], completion: nil)
}

/*
 func displayAlertWithMessageFromVC(_ vc:UIViewController, message:String, buttons:[String], completion:((_ index:Int) -> Void)!) -> Void {
 
 let alertController = UIAlertController(title: APP_NAME, message: message, preferredStyle: .alert)
 
 for index in 0..<buttons.count	{
 
 alertController.setValue(NSAttributedString(string: APP_NAME, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),NSAttributedStringKey.foregroundColor : APP_BLACK_COLOR]), forKey: "attributedTitle")
 
 alertController.setValue(NSAttributedString(string: message, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor : APP_BLACK_COLOR]), forKey: "attributedMessage")
 
 
 let action = UIAlertAction(title: buttons[index], style: .default, handler: {
 (alert: UIAlertAction!) in
 if(completion != nil){
 completion(index)
 }
 })
 
 action.setValue(UIColor.black, forKey: "titleTextColor")
 alertController.addAction(action)
 }
 
 vc.present(alertController, animated: true, completion: nil)
 }
 */
func displayAlertWithTitle(_ title:String, andMessage message:String, buttons:[String], completion:((_ index:Int) -> Void)!) -> Void {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for index in 0..<buttons.count	{
        
        alertController.setValue(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor : APP_THEME_BLACK_COLOR]), forKey: "attributedTitle")
        
        alertController.setValue(NSAttributedString(string: message, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
        
        
        let action = UIAlertAction(title: buttons[index], style: .default, handler: {
            (alert: UIAlertAction!) in
            if(completion != nil){
                completion(index)
            }
        })
        
        action.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(action)
    }
    UIApplication.shared.delegate!.window!?.rootViewController!.present(alertController, animated: true, completion:nil)
}

/*
 func displayAlertWithTitle(_ vc:UIViewController, title:String, andMessage message:String, buttons:[String], completion:((_ index:Int) -> Void)!) -> Void {
 
 let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
 for index in 0..<buttons.count	{
 
 alertController.setValue(NSAttributedString(string: title, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16),NSAttributedStringKey.foregroundColor : APP_BLACK_COLOR]), forKey: "attributedTitle")
 
 alertController.setValue(NSAttributedString(string: message, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor : APP_BLACK_COLOR]), forKey: "attributedMessage")
 
 
 let action = UIAlertAction(title: buttons[index], style: .default, handler: {
 (alert: UIAlertAction!) in
 if(completion != nil){
 completion(index)
 }
 })
 
 action.setValue(UIColor.black, forKey: "titleTextColor")
 alertController.addAction(action)
 }
 vc.present(alertController, animated: true, completion: nil)
 }
 */


//MARK:- Decryption Method
/*
func DecryptionDataDictionary(strData:String) -> [String:Any]? {
    // Decryption
    do {
        let originalData = try RNCryptor.decrypt(data: Data(base64Encoded: strData)!, withPassword: DCRYPTION_KEY)
        print(String(data: originalData, encoding: .utf8)!)
        do {
            return try JSONSerialization.jsonObject(with: originalData, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
            return nil
        }
    } catch {
        print(error)
        return nil
    }
}

func DecryptionDataArray(strData:String) -> [Any]? {
    // Decryption
    do {
        let originalData = try RNCryptor.decrypt(data: Data(base64Encoded: strData)!, withPassword: DCRYPTION_KEY)
        print(String(data: originalData, encoding: .utf8) ?? "")
        do {
            return try JSONSerialization.jsonObject(with: originalData, options: []) as? [Any]
        } catch {
            print(error.localizedDescription)
            return nil
        }
    } catch {
        print(error)
        return nil
    }
}

*/
func dataToJSON(data: Data) -> Any? {
    do {
        return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    } catch let myJSONError {
        print(myJSONError)
    }
    return nil
}

func convertDictionaryToJson(Dict: NSDictionary) -> String?
{
    let jsonData = try? JSONSerialization.data(withJSONObject: Dict, options: [])
    let jsonString = String(data: jsonData!, encoding: .utf8)
    return jsonString
}

func convertToDictionary(text: String) -> [String: AnyObject]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}


func gateStringToDateString(strDate:String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    guard let date = dateFormatter.date(from: strDate) else {
        return ""
    }
    dateFormatter.dateFormat = "MMM dd, yyyy"
    let dateString = dateFormatter.string(from: date)
    return dateString
}

func gateStringToTimeString(strDate:String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    guard let date = dateFormatter.date(from: strDate) else {
        return ""
    }
    dateFormatter.dateFormat = "h:mm a"
    let dateString = dateFormatter.string(from: date)
    return dateString
}


func gateStringToDateTimeString(strDate:String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    guard let date = dateFormatter.date(from: strDate) else {
        return ""
    }
    dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
    let dateString = dateFormatter.string(from: date)
    return dateString
}



func gateStringToDate(strDate:String) -> Date?{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    guard let date = dateFormatter.date(from: strDate) else {
        return nil
    }
    return date
}

func getDateToString(date:Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE"
    let dateString = dateFormatter.string(from: date)
    return dateString
}

func getStringToMonthForCompare(strDate:String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    guard let date = dateFormatter.date(from: strDate) else {
        return ""
    }
    dateFormatter.dateFormat = "MM,yyyy"
    let dateString = dateFormatter.string(from: date)
    return dateString
}

func getDateToStringMonthForCompare(date:Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM,yyyy"
    let dateString = dateFormatter.string(from: date)
    return dateString
}

func getDayFroPecificMonth(date:Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd,MM,yyyy"
    let dateString = dateFormatter.string(from: date)
    return dateString
}

func gateStringToDateFroPecificMonth(strDate:String) -> Date?{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd,MM,yyyy"
    
    guard let date = dateFormatter.date(from: strDate) else {
        return nil
    }
    return date
}

func dateToUTCFormate(date:Date) -> String {
    let dateFormatter = DateFormatter()
    let timeZone = TimeZone(identifier: "UTC")
    dateFormatter.timeZone = timeZone
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: date)
}

func getDateFromStringUTC(strDate:String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    guard let date = dateFormatter.date(from: strDate) else {
        return ""
    }
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy"
    return formatter.string(from: date)
}

func UTCStringToDateFormate(strDate:String) -> String{
    let dateFormatter = DateFormatter()
    let timeZone = TimeZone(identifier: "UTC")
    dateFormatter.timeZone = timeZone
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    guard let date = dateFormatter.date(from: strDate) else {
        return ""
    }
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "MM/dd/yyyy, h:mm a"
    let dateString = dateFormatter1.string(from: date)
    return dateString
}

func getDateFromUTCTime(strDate:String) -> Date?{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    guard let date = dateFormatter.date(from: strDate) else {
        return nil
    }
    return date
}

func getPastTime(for date : Date) -> String {
    
    var secondsAgo = Int(Date().timeIntervalSince(date))
    if secondsAgo < 0 {
        secondsAgo = secondsAgo * (-1)
    }
    
    let minute = 60
    let hour = 60 * minute
    let day = 24 * hour
    let week = 7 * day
    
    if secondsAgo < minute  {
        if secondsAgo < 2{
            return "just now"
        }else{
            return "\(secondsAgo) secs ago"
        }
    } else if secondsAgo < hour {
        let min = secondsAgo/minute
        if min == 1{
            return "\(min) min ago"
        }else{
            return "\(min) mins ago"
        }
    } else if secondsAgo < day {
        let hr = secondsAgo/hour
        if hr == 1{
            return "\(hr) hr ago"
        } else {
            return "\(hr) hrs ago"
        }
    } else if secondsAgo < week {
        let day = secondsAgo/day
        if day == 1{
            return "\(day) day ago"
        }else{
            return "\(day) days ago"
        }
    } else {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, hh:mm a"
        formatter.timeZone = TimeZone.current
        let strDate: String = formatter.string(from: date)
        return strDate
    }
}

//MARK:- Phone Number Formatter String
func formattedMobileNumber(number: String) -> String {
    
    if number.contains("(")
    {
        return number
    }
    
    let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    let mask = "(XXX) XXX-XXXX"
    
    var result = ""
    var index = cleanPhoneNumber.startIndex
    for ch in mask {
        if index == cleanPhoneNumber.endIndex {
            break
        }
        if ch == "X" {
            result.append(cleanPhoneNumber[index])
            index = cleanPhoneNumber.index(after: index)
        } else {
            result.append(ch)
        }
    }
    return result
}

func removeValidationMobile(string:String) -> String {
    var cleanPhoneNumber = string.replacingOccurrences(of: " ", with: "")
    cleanPhoneNumber = cleanPhoneNumber.replacingOccurrences(of: "(", with: "")
    cleanPhoneNumber = cleanPhoneNumber.replacingOccurrences(of: ")", with: "")
    cleanPhoneNumber = cleanPhoneNumber.replacingOccurrences(of: "-", with: "")
    return cleanPhoneNumber
}


//MARK: - IMAGE
func ImageNamed(_ name:String) -> UIImage?{
    return UIImage(named: name)
}
//MARK:- DEVICE CHECK


//Check IsiPhone Device
func IS_IPHONE_DEVICE()->Bool{
    let deviceType = UIDevice.current.userInterfaceIdiom == .phone
    return deviceType
}

//Check IsiPad Device
func IS_IPAD_DEVICE()->Bool{
    let deviceType = UIDevice.current.userInterfaceIdiom == .pad
    return deviceType
}


//iPhone 4 OR 4S
func IS_IPHONE_4_OR_4S()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 480
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == SCREEN_HEIGHT)	{
        device = true
    }
    return device
}

//iPhone 5 OR OR 5C OR 4S
func IS_IPHONE_5_OR_5S()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 568
    var device:Bool = false
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == SCREEN_HEIGHT)	{
        device = true
    }
    return device
}

//iPhone 6 OR 6S
func IS_IPHONE_6_OR_6S()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 667
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == SCREEN_HEIGHT)	{
        device = true
    }
    return device
}

//iPhone 6Plus OR 6SPlus
func IS_IPHONE_6P_OR_6SP()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 736
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == SCREEN_HEIGHT)	{
        device = true
    }
    return device
}

//MARK:- DEVICE ORIENTATION CHECK
func IS_DEVICE_PORTRAIT() -> Bool {
    return UIDevice.current.orientation.isPortrait
}

func IS_DEVICE_LANDSCAPE() -> Bool {
    return UIDevice.current.orientation.isLandscape
}

// MARK: - Custom object Functions Save User Default
 func setCustomObject(value:AnyObject,key:String)
{
    let data = NSKeyedArchiver.archivedData(withRootObject: value)
    UserDefaults.standard.set(data, forKey: key)
    UserDefaults.standard.synchronize()
}

 func getCustomObject(key:String) -> Any?
{
    let data = UserDefaults.standard.object(forKey: key) as? NSData
    if data == nil
    {
        return nil
    }
    let value = NSKeyedUnarchiver.unarchiveObject(with: data! as Data)
    return value
}

 func removeObjectForKey(_ objectKey: String) {
    
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: objectKey)
    defaults.synchronize()
}

 func removeAllKeyFromDefault(){
    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
}

 func setImageObject(value:UIImage,key:String)
{
    UserDefaults.standard.set(value.pngData(), forKey: key)
    UserDefaults.standard.synchronize()
}
 func getImageObject(key:String) -> UIImage
{
    let data = UserDefaults.standard.object(forKey: key) as? NSData
    if data == nil
    {
        let img = UIImage.init()
        img.accessibilityIdentifier = "nil"
        return img
    }
    return UIImage.init(data: data! as Data)!
}

// MARK: - String Functions
 func setString(value:String,key:String)
{
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

 func getString(key:String) -> String?
{
    let value : String? = UserDefaults.standard.object(forKey: key) as? String
    return value
}

// MARK: - Int Functions
 func setInt(value:Int,key:String)
{
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

 func getInt(key:String) -> Int?
{
    let value : Int? = UserDefaults.standard.object(forKey: key) as? Int
    return value
}

// MARK: - Float Functions
 func setFloat(value:Float,key:String)
{
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

 func getFloat(key:String) -> Float?
{
    let value : Float? = UserDefaults.standard.object(forKey: key) as? Float
    return value
}

// MARK: - Double Functions
 func setDouble(value:Double,key:String)
{
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

 func getDouble(key:String) -> Double?
{
    let value : Double? = UserDefaults.standard.object(forKey: key) as? Double
    return value
}


func getDistance(startLatitude:Double,StartLongitude:Double,latitude:Double,longitude:Double) -> Double
{
    let userCoOrdinate = CLLocation(latitude:startLatitude, longitude:StartLongitude)
    let desinationCoOrdinate = CLLocation(latitude: latitude, longitude:longitude)
    let distance = userCoOrdinate.distance(from: desinationCoOrdinate) / 1000
    
    print(userCoOrdinate)
    print(desinationCoOrdinate)
    
  //  let miles = (distanceInMeters * 0.000621371).rounded(toPlaces: 2)
    return distance
}
