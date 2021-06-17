//
//  UIViewController+Extension.swift
//  Doctor
//
//  Created by Jaydeep on 02/07/19.
//  Copyright © 2019 Jaydeep. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import CoreLocation
import DropDown
import Photos

extension UIViewController:NVActivityIndicatorViewable {
            
    //MARK:- Action Zone
    
    @IBAction func btnBackAction(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- SetupNavigation bar
    
    func setNavigationTitle(_ title : String)
    {
        self.navigationController?.navigationBar.barTintColor = APP_THEME_GREEN_COLOR
        self.navigationItem.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : themeFont(size: 18, fontname: .bold),
        NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = APP_THEME_GREEN_COLOR
        self.navigationController?.navigationBar.backgroundColor = APP_THEME_GREEN_COLOR
    }
    
    
    func getCurrencyCode() -> String{
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol!
        return currencySymbol
    }
    
    func setRightBarButtonHome(_ title:String) {
        btnHomeRight.titleLabel?.font = themeFont(size: 12, fontname: .bold)
        btnHomeRight.borderColor = .white
        btnHomeRight.borderWidth = 1
        btnHomeRight.setTitle(title, for: .normal)
        btnHomeRight.setTitleColor(.white, for: .normal)        
        btnHomeRight.sizeToFit()
        btnHomeRight.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        btnHomeRight.cornerRadius = btnHomeRight.frame.height/2
        btnHomeRight.addTarget(self, action: #selector(btnHomeRightAction(_:)), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: btnHomeRight)
        configureDropdown(dropdown: rigthHomeDD, sender: btnHomeRight)
        self.navigationItem.rightBarButtonItem = rightBarButton        
    }
    
    func setRightBarButtonDiscover(_ title:String) {
        btnDiscoverRight.titleLabel?.font = themeFont(size: 12, fontname: .bold)
        btnDiscoverRight.borderColor = .white
        btnDiscoverRight.borderWidth = 1
        btnDiscoverRight.setTitle(title, for: .normal)
        btnDiscoverRight.setTitleColor(.white, for: .normal)
        btnDiscoverRight.sizeToFit()
        btnDiscoverRight.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        btnDiscoverRight.cornerRadius = btnHomeRight.frame.height/2
        btnDiscoverRight.addTarget(self, action: #selector(btnHomeRightAction(_:)), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: btnDiscoverRight)
        configureDropdown(dropdown: rigthDiscoverDD, sender: btnDiscoverRight)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @IBAction func btnHomeRightAction(_ sender:UIButton) {
        
    }
    
    
    func getImageFromAsset(asset:PHAsset,callback:@escaping (_ result:UIImage) -> Void) -> Void {
        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.fast
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.isSynchronous = true
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: requestOptions, resultHandler: { (currentImage, info) in
            callback(currentImage!)
        })
    }
    
    //MARK: - Configure Dropdown
    func configureDropdown(dropdown : DropDown,sender:UIControl,isWidth:Bool = false)
    {
        dropdown.clearSelection()
        dropdown.anchorView = sender
        dropdown.direction = .any
        dropdown.dismissMode = .automatic
        dropdown.bottomOffset = CGPoint(x: 0, y: sender.frame.height)
        //        dropdown.topOffset = CGPoint(x: 0, y: sender.bounds.height)
        if isWidth {
            dropdown.width = sender.frame.width
        }
        dropdown.cellHeight = 40.0
        dropdown.backgroundColor = UIColor.white
        dropdown.cancelAction = { [unowned self] in
            print("Drop down dismissed")
        }
    }
    
    func configureDropdown(dropdown : DropDown,sender:UIBarButtonItem,isWidth:Bool=true)
    {
        dropdown.clearSelection()
        dropdown.anchorView = sender
        dropdown.direction = .any
        dropdown.dismissMode = .automatic
        dropdown.bottomOffset = CGPoint(x: 0, y: (self.navigationController?.navigationBar.frame.height)!)
        //        dropdown.topOffset = CGPoint(x: 0, y: sender.bounds.height)
        if isWidth {
            dropdown.width = 150
        }        
        dropdown.cellHeight = 40.0
        dropdown.backgroundColor = UIColor.white
        dropdown.cancelAction = { [unowned self] in
            print("Drop down dismissed")
        }
    }
    
    //MARK: - StartAnimating
    
    func showLoader()
    {
        startAnimating(type: NVActivityIndicatorType.ballSpinFadeLoader)
    }
    
    func stopLoader()
    {
        self.stopAnimating()
    }
    
    func getAddressFromLatLon(isGetCurrency:Bool = false,latitude: Double, longitude: Double,completion:@escaping(String)-> ()) {
        
        let ceo: CLGeocoder = CLGeocoder()
        
        let loc: CLLocation = CLLocation(latitude:latitude, longitude: longitude)
        
        var addressString : String = ""
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                if let pm = placemarks {
                    if pm.count > 0 {
                        
                        let pm = placemarks![0]
                        print("country",pm.country ?? "")
                        print("locality",pm.locality ?? "")
                        print("subLocality",pm.subLocality ?? "")
                        print("thoroughfare",pm.thoroughfare ?? "")
                        print("postalCode",pm.postalCode ?? "")
                        print("subThoroughfare",pm.subThoroughfare ?? "")
                        print("isoCountryCode",pm.isoCountryCode ?? "")
                        if pm.isoCountryCode != "" {
                            //                            strCountryDialingCode = self.getCountryCallingCode(countryRegionCode: pm.isoCountryCode!)
                        }
                        if isGetCurrency == true {
                            //                            kUserCurrency = self.getCurrency(countryName: pm.country ?? "")
                        }
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        
                        print("addressString \(addressString)")
                        completion(addressString)
                    }
                }
                completion(addressString)
                
        })
        
    }
    
    func getCountryCallingCode(countryRegionCode:String)->String{
        
        let prefixCodes = ["AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263"]
        let countryDialingCode = prefixCodes[countryRegionCode]
        return countryDialingCode!
    }
    
    func getSymbolForCurrencyCode(code: String) -> String {
        var candidates: [String] = []
        let locales: [String] = NSLocale.availableLocaleIdentifiers
        for localeID in locales {
            guard let symbol = findMatchingSymbol(localeID: localeID, currencyCode: code) else {
                continue
            }
            if symbol.count == 1 {
                return symbol
            }
            candidates.append(symbol)
        }
        let sorted = sortAscByLength(list: candidates)
        if sorted.count < 1 {
            return ""
        }
        return sorted[0]
    }
    
    func findMatchingSymbol(localeID: String, currencyCode: String) -> String? {
        let locale = Locale(identifier: localeID as String)
        guard let code = locale.currencyCode else {
            return nil
        }
        if code != currencyCode {
            return nil
        }
        guard let symbol = locale.currencySymbol else {
            return nil
        }
        return symbol
    }
    
    func sortAscByLength(list: [String]) -> [String] {
        return list.sorted(by: { $0.count < $1.count })
    }
    
    func getCurrency(countryName:String) -> String{
        if countryName == ""{
            return ""
        }
        let countryCode = Locale.locales(strCountryName: countryName)
        let countryCodeCA = countryCode
        let localeIdCA = NSLocale.localeIdentifier(fromComponents: [ NSLocale.Key.countryCode.rawValue : countryCodeCA])
        let localeCA = NSLocale(localeIdentifier: localeIdCA)
        if let currencyCodeCA = localeCA.object(forKey: NSLocale.Key.currencyCode) as? String{
            return getSymbolForCurrencyCode(code: currencyCodeCA)
        }
        return getSymbolForCurrencyCode(code: "India")
    }    
        
    func addDoneButtonOnKeyboard(textfield : UITextField)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:0,y: 0,width: UIScreen.main.bounds.width,height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem:  UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        done.tintColor = UIColor(red: 35/255, green: 141/255, blue: 250/255, alpha: 1.0)
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        textfield.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    //MARK: - Date
    func StringToDate(Formatter : String,strDate : String) -> Date
    {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = Formatter
        //        dateformatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let convertedDate = dateformatter.date(from: strDate) else {
            let str = dateformatter.string(from: Date())
            return dateformatter.date(from: str)!
            
        }
        //        print("convertedDate - ",convertedDate)
        return convertedDate
    }
    func DateToString(Formatter : String,date : Date) -> String
    {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = Formatter
        //    dateformatter.timeZone = TimeZone(abbreviation: "UTC")
        let convertedString = dateformatter.string(from: date)
        return convertedString
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

//MARK:- UITableCell Extension

extension UITableViewCell {
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(_ label: UILabel, targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x:(labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y:(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x:locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y : locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: lineWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UINavigationController {

   func backToViewController(vc: Any) {
      // iterate to find the type of vc
      for element in viewControllers as Array {
        if "\(type(of: element)).Type" == "\(type(of: vc))" {
            self.popToViewController(element, animated: true)
            break
         }
      }
   }

}
