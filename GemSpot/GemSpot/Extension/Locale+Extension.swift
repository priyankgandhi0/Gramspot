//
//  Locale+Extension.swift
//  Doctor
//
//  Created by Jaydeep on 18/11/19.
//  Copyright © 2019 Jaydeep. All rights reserved.
//

import Foundation
import UIKit

extension Locale {
    
    static func locales(strCountryName : String) -> String {
        let locale : String = ""
        for localeCode in NSLocale.isoCountryCodes {
            let countryName = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: localeCode)
            if strCountryName.lowercased() == countryName?.lowercased() {
                return localeCode
            }
        }
        return locale
    }    
}




