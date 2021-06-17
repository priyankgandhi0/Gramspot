//
//  AIServiceManager.swift
//  Swift3CodeStucture
//
//  Created by Ravi Alagiya on 11/24/16.
//  Copyright © 2016 agilepc-100. All rights reserved.
//

import Alamofire
import UIKit


class AIServiceManager: NSObject {
    
    static let sharedManager : AIServiceManager = {
        let instance = AIServiceManager()
        return instance
    }()
    
    
    // MARK: - ERROR HANDLING
    func handleError(_ errorToHandle : NSError){
        
        if(errorToHandle.domain == CUSTOM_ERROR_DOMAIN)	{
            //let dict = errorToHandle.userInfo as NSDictionary
            displayAlertWithTitle(APP_NAME, andMessage:DEFAULT_ERROR, buttons: ["Dismiss"], completion: nil)
            
        }else if(errorToHandle.code == -1009){
            displayAlertWithTitle(APP_NAME, andMessage: INTERNET_ERROR, buttons: ["Dismiss"], completion: nil)
        }
        else{
            if(errorToHandle.code == -999){
                return
            }
            displayAlertWithTitle(APP_NAME, andMessage:errorToHandle.localizedDescription, buttons: ["Dismiss"], completion:nil)
        }
    }
    
    func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    /*
     // MARK: - ************* COMMON API METHOD **************
     
     */
    
    func makeRequest(with url: String, method: Alamofire.HTTPMethod, parameter: [String:Any]?, success: @escaping (_ response: Any) -> Void, failure: @escaping (_ error: String) -> Void, connectionFailed: @escaping (_ error: String) -> Void) {
        
        if !isConnectedToInternet()
        {
            SHOW_INTERNET_ALERT()
            connectionFailed(INTERNET_ERROR)
            return
        }
        
        AF.request(url, method: method,parameters: parameter,encoding: JSONEncoding.default,headers: nil).responseJSON(completionHandler: { res in
            
            HIDE_CUSTOM_LOADER()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            print("Result \(res.result)")
            switch res.result {
            case .success(let value):
                if let dictData = value as? NSDictionary {
                    if let force_logout = dictData["force_logout"] as? Int, force_logout == 1 {
                        forceLogout()
                    } else {
                        success(value)
                    }
                } else {
                    success(value)
                }
                break
            case .failure(let error):
                failure(DEFAULT_ERROR)
                break
            }
        })
        
    }
    
    func makeReqeusrWithMultipartData(with url: String, method: Alamofire.HTTPMethod = .post, parameter: [String:AnyObject]?,image:UIImage?,image_name:String = "pet_image",isShowLoader:Bool = true,success: @escaping (_ response: Any) -> Void, failure: @escaping (_ error: String) -> Void, connectionFailed: @escaping (_ error: String) -> Void) {
        
        if !isConnectedToInternet()
        {
            SHOW_INTERNET_ALERT()
            connectionFailed(INTERNET_ERROR)
            return
        }
        
        if  isShowLoader
        {
            SHOW_CUSTOM_LOADER()
        }
        
        let url = url.URLEncode()
        print("url>> \(url)")
        
        print(parameter ?? "")
        
        var header : HTTPHeaders = ["App-Track-Version":"v1",
                                    "App-Device-Type":"iOS",
                                    "App-Store-Version":VERSION_NUMBER,
                                    "App-Device-Model":UIDevice().type.rawValue,
                                    "App-Os-Version":SYSTEM_VERSION,
                                    "App-Secret":APP_SECRET,
                                    "User-Agent":USER_AGENT,
                                    "App-Store-Build-Number":BUILD_NUMBER,
                                    "Content-Type":"application/json"]
        
        if let objUser = appDelegate.objUser  {
            header["Auth-Token"] = objUser.authToken
            print("Auth token : \(objUser.authToken ?? "")")
        } else {
            header["Auth-Token"] = ""
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameter! {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
                if image != nil {
                    multipartFormData.append(image!.jpegData(compressionQuality: 0.7)!, withName: image_name , fileName: "file.png", mimeType: "image/png")
                }
        },
            to: url, method: method , headers: header)
            .validate(statusCode: 200..<300)
            .responseJSON { res in
                HIDE_CUSTOM_LOADER()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print("Result \(res.result)")
                switch res.result{
                case .success(let value):
                    print("value \(value)")
                    if let dictData = value as? NSDictionary {
                        if let force_logout = dictData["force_logout"] as? Int, force_logout == 1 {
                            forceLogout()
                        } else {
                            success(value)
                        }
                    } else {
                        success(value)
                    }
                    break
                case .failure(let error):
                    let alamoCode = error._code
                    if alamoCode == -1001 {
                        failure((res.error?.localizedDescription)!)
                    } else {
                        failure((res.error?.localizedDescription)!)
                    }
                    break
                }
        }
    }
    
    func makeReqeusrWithMultipartDataMultipleImageVideo(with url: String, method: Alamofire.HTTPMethod = .post, parameter: [String:AnyObject]?,withName:[String]?,image:[UIImage]?,isVideo:Bool = false,videoData:[Data] = [],withVideoName:[String] = [],isShowLoader:Bool = true,success: @escaping (_ response: Any) -> Void, failure: @escaping (_ error: String) -> Void, connectionFailed: @escaping (_ error: String) -> Void) {
        
        if !isConnectedToInternet()
        {
            SHOW_INTERNET_ALERT()
            connectionFailed(INTERNET_ERROR)
            return
        }
        
        if  isShowLoader
        {
            SHOW_CUSTOM_LOADER()
        }
        
        let url = url.URLEncode()
        print("url>> \(url)")
        
        print(parameter ?? "")
        
        var header : HTTPHeaders = ["App-Track-Version":"v1",
                                    "App-Device-Type":"iOS",
                                    "App-Store-Version":VERSION_NUMBER,
                                    "App-Device-Model":UIDevice().type.rawValue,
                                    "App-Os-Version":SYSTEM_VERSION,
                                    "App-Secret":APP_SECRET,
                                    "User-Agent":USER_AGENT,
                                    "App-Store-Build-Number":BUILD_NUMBER,
                                    "Content-Type":"application/json"]
        
        if let objUser = appDelegate.objUser  {
            header["Auth-Token"] = objUser.authToken
            print("Auth token : \(objUser.authToken ?? "")")
        } else {
            header["Auth-Token"] = ""
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameter! {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
                
                let fileName = ""
                
                print("FileName \(fileName)")
                
                if isVideo {
                    for i in 0..<withVideoName.count {
                        let imageData = videoData[i]
                        multipartFormData.append(imageData, withName: withVideoName[i] , fileName: "\(fileName).mp4", mimeType: "video/mp4")
                    }
                }
                
                for i in 0..<image!.count {
                    let imageData = image?[i]
                    let name = withName![i]
                    if imageData != nil {
                        multipartFormData.append(imageData!.jpegData(compressionQuality: 0.7)!, withName: name , fileName: "\(fileName).png", mimeType: "image/png")
                    }
                }
                
        },
            to: url, method: method , headers: header)
            .validate(statusCode: 200..<300)
            .responseJSON { res in
                HIDE_CUSTOM_LOADER()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print("Result \(res.result)")
                switch res.result{
                case .success(let value):
                    print("value \(value)")
                    if let dictData = value as? NSDictionary {
                        if let force_logout = dictData["force_logout"] as? Int, force_logout == 1 {
                            forceLogout()
                        } else {
                            success(value)
                        }
                    } else {
                        success(value)
                    }
                    break
                case .failure(let error):
                    let alamoCode = error._code
                    if alamoCode == -1001 {
                        failure((res.error?.localizedDescription)!)
                    } else {
                        failure((res.error?.localizedDescription)!)
                    }
                    break
                }
        }
    }
    
    
    func callAPI(url:String,parameter: [String : AnyObject]?,isShowLoader:Bool = true, httpMethod : HTTPMethod = .post,parseToClass : String = "",
                 success: @escaping (_ response: Any) -> Void, failure: @escaping (_ error: String) -> Void, connectionFailed: @escaping (_ error: String) -> Void)
    {
        
        if !isConnectedToInternet()
        {
            SHOW_INTERNET_ALERT()
            connectionFailed(INTERNET_ERROR)
            return
        }
        
        if  isShowLoader
        {
            SHOW_CUSTOM_LOADER()
        }
        
        let url = url.URLEncode()
        print("url>> \(url)")
        
        print(parameter ?? "")
        
        var header : HTTPHeaders = ["App-Track-Version":"v1",
                                    "App-Device-Type":"iOS",
                                    "App-Store-Version":VERSION_NUMBER,
                                    "App-Device-Model":UIDevice().type.rawValue,
                                    "App-Os-Version":SYSTEM_VERSION,
                                    "App-Secret":APP_SECRET,
                                    "User-Agent":USER_AGENT,
                                    "App-Store-Build-Number":BUILD_NUMBER,
                                    "Content-Type":"application/json"]
        
        if let objUser = appDelegate.objUser  {
            header["Auth-Token"] = objUser.authToken
            print("Auth token : \(objUser.authToken ?? "")")
        } else {
            header["Auth-Token"] = ""
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        AF.request(url, method: httpMethod,parameters: parameter,encoding: JSONEncoding.default,headers: header).responseJSON(completionHandler: { res in
            
            HIDE_CUSTOM_LOADER()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            print("Result \(res.result)")
            switch res.result {
            case .success(let value):
                if let dictData = value as? NSDictionary {
                    if let force_logout = dictData["force_logout"] as? Int, force_logout == 1 {
                        forceLogout()
                    } else {
                        success(value)
                    }
                } else {
                    success(value)
                }
                break
            case .failure(let error):
                let alamoCode = error._code
                if alamoCode == -1001 {
                    failure((res.error?.localizedDescription)!)
                } else {
                    failure((res.error?.localizedDescription)!)
                }
                break
            }
        })
    }
    
    func retry_api_call(originalRequest : URLRequest, parseToClass : String, isShowLoader:Bool = true,
                        success: @escaping (_ response: Any) -> Void, failure: @escaping (_ error: String) -> Void, connectionFailed: @escaping (_ error: String) -> Void)
    {
        
        SHOW_CUSTOM_LOADER()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        AF.request(originalRequest).responseJSON { res in
            
            HIDE_CUSTOM_LOADER()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            switch res.result {
            case .success(let value):
                success(value)
                break
            case .failure(let error):
                let alamoCode = error._code
                if alamoCode == -1001 {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: APP_NAME, message: (res.error?.localizedDescription)!, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                            failure((res.error?.localizedDescription)!)
                            
                        })
                        //                        alert.view.tintColor = app
                        alert.addAction(UIAlertAction(title: "Reload", style: .default) { action in
                            //                            self.retry_api_call(originalRequest: res.request!, parseToClass: "",isShowLoader:isShowLoader, su)
                        })
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                } else {
                    displayAlertWithMessage((res.error?.localizedDescription)! + " Please try again!")
                    failure((res.error?.localizedDescription)!)
                }
                break
            }
        }        
    }
    
    func makeReqeusrWithMultipartData(with url: String, method: Alamofire.HTTPMethod = .post, parameter: [String:AnyObject]?,arrObject:[ClsPostListPostImage],isShowLoader:Bool = true,success: @escaping (_ response: Any) -> Void, failure: @escaping (_ error: String) -> Void, connectionFailed: @escaping (_ error: String) -> Void) {
        
        if !isConnectedToInternet()
        {
            SHOW_INTERNET_ALERT()
            connectionFailed(INTERNET_ERROR)
            return
        }
        
        if  isShowLoader
        {
            SHOW_CUSTOM_LOADER()
        }
        
        let url = url.URLEncode()
        print("url>> \(url)")
        
        print(parameter ?? "")
        
        var header : HTTPHeaders = ["App-Track-Version":"v1",
                                    "App-Device-Type":"iOS",
                                    "App-Store-Version":VERSION_NUMBER,
                                    "App-Device-Model":UIDevice().type.rawValue,
                                    "App-Os-Version":SYSTEM_VERSION,
                                    "App-Secret":APP_SECRET,
                                    "User-Agent":USER_AGENT,
                                    "App-Store-Build-Number":BUILD_NUMBER,
                                    "Content-Type":"application/json"]
        
        if let objUser = appDelegate.objUser  {
            header["Auth-Token"] = objUser.authToken
            print("Auth token : \(objUser.authToken ?? "")")
        } else {
            header["Auth-Token"] = ""
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        AF.upload(
            multipartFormData: { multipartFormData in
                
                var cnt = 0
                for i in 0..<arrObject.count {
                    let fileName = randomString(length: 10)
                    print("FileName \(fileName)")
                    let dict = arrObject[i]
                    if dict.isUploaded == 0 {
                        cnt += 1
                        let isVideo = dict.isVideo
                        if isVideo == 1 {
                            multipartFormData.append(dict.allData, withName: "post_image_\(cnt)" , fileName: "\(fileName).mp4", mimeType: "video/mp4")
                        } else {
                            multipartFormData.append(dict.allData, withName: "post_image_\(cnt)" , fileName: "\(fileName).png", mimeType: "image/png")
                        }
                    }
                }
                
                for (key, value) in parameter! {
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                }
        },
            to: url, method: method , headers: header)
            .validate(statusCode: 200..<300)
            .responseJSON { res in
                HIDE_CUSTOM_LOADER()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print("Result \(res.result)")
                switch res.result{
                case .success(let value):
                    print("value \(value)")
                    if let dictData = value as? NSDictionary {
                        if let force_logout = dictData["force_logout"] as? Int, force_logout == 1 {
                            forceLogout()
                        } else {
                            success(value)
                        }
                    } else {
                        success(value)
                    }
                    break
                case .failure(let error):
                    let alamoCode = error._code
                    if alamoCode == -1001 {
                        failure((res.error?.localizedDescription)!)
                    } else {
                        failure((res.error?.localizedDescription)!)
                    }
                    break
                }
        }
    }
    
    /*func makeReqeusrWithMultipartData(with url: String, method: Alamofire.HTTPMethod = .post, parameter: [String:AnyObject]?,withName:[String]?,image:[UIImage]?,isVideo:Bool = false,videoData:[Data] = [],withVideoName:[String] = [],isShowLoader:Bool = true,success: @escaping (_ response: Any) -> Void, failure: @escaping (_ error: String) -> Void, connectionFailed: @escaping (_ error: String) -> Void) {
        
        if !isConnectedToInternet()
        {
            SHOW_INTERNET_ALERT()
            connectionFailed(INTERNET_ERROR)
            return
        }
        
        if  isShowLoader
        {
            SHOW_CUSTOM_LOADER()
        }
        
        let url = url.URLEncode()
        print("url>> \(url)")
        
        print(parameter ?? "")
        
        var header : HTTPHeaders = ["App-Track-Version":"v1",
                                    "App-Device-Type":"iOS",
                                    "App-Store-Version":VERSION_NUMBER,
                                    "App-Device-Model":UIDevice().type.rawValue,
                                    "App-Os-Version":SYSTEM_VERSION,
                                    "App-Secret":APP_SECRET,
                                    "User-Agent":USER_AGENT,
                                    "App-Store-Build-Number":BUILD_NUMBER,
                                    "Content-Type":"application/json"]
        
        if let objUser = appDelegate.objUser  {
            header["Auth-Token"] = objUser.authToken
            print("Auth token : \(objUser.authToken ?? "")")
        } else {
            header["Auth-Token"] = ""
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameter! {
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                }
                
                let fileName = randomString(length: 10)
                
                print("FileName \(fileName)")
                
                if isVideo {
                    for i in 0..<withVideoName.count {
                        let imageData = videoData[i]
                        multipartFormData.append(imageData, withName: withVideoName[i] , fileName: "\(fileName).mp4", mimeType: "video/mp4")
                    }
                }
                
                for i in 0..<image!.count {
                    let imageData = image?[i]
                    let name = withName![i]
                    if imageData != nil {
                        multipartFormData.append(imageData!.jpegData(compressionQuality: 0.7)!, withName: name , fileName: "\(fileName).png", mimeType: "image/png")
                    }
                }
                
        },
            to: url, method: method , headers: header)
            .validate(statusCode: 200..<300)
            .responseJSON { res in
                HIDE_CUSTOM_LOADER()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print("Result \(res.result)")
                switch res.result{
                case .success(let value):
                    print("value \(value)")
                    success(value)
                    break
                case .failure(let error):
                    let alamoCode = error._code
                    if alamoCode == -1001 {
                        failure((res.error?.localizedDescription)!)
                    } else {
                        failure((res.error?.localizedDescription)!)
                    }
                    break
                }
        }
    }*/
}

