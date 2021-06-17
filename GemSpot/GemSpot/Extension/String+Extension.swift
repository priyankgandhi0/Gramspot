//
//  String+Extension.swift
//  Doctor
//
//  Created by Jaydeep on 22/07/19.
//  Copyright © 2019 Jaydeep. All rights reserved.
//

import Foundation
import UIKit

extension String{
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
        //        return localizedString(self)
    }
    
    func isValidEmail() -> Bool
    {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9","*","+"]
        return Set(self).isSubset(of: nums)
    }
    
    func isStrongPassword(_ stringToCheckForPassword:String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\dd$@$.!%*?&#]{8,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: stringToCheckForPassword)
    }
}

