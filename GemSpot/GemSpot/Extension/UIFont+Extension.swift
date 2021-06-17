//
//  UIFont+Extension.swift
//  SEStatus
//
//  Created by Jaydeep on 03/06/19.
//  Copyright © 2019 Jaydeep. All rights reserved.
//

import Foundation
import UIKit

enum themeFonts : String
{
    case regular = "NunitoSans-Regular"
    case extraBold = "NunitoSans-ExtraBold"   
    case light = "NunitoSans-Light"
    case bold = "NunitoSans-Bold"
    case italic = "NunitoSans-Italic"
    case semiBold = "NunitoSans-SemiBold"
    case black = "NunitoSans-Black"
}

extension UIFont
{
    
}

func themeFont(size : Float,fontname : themeFonts) -> UIFont
{
    if UIScreen.main.bounds.width <= 320
    {
        return UIFont(name: fontname.rawValue, size: CGFloat(size) - 2.0)!
    }
    else
    {
        return UIFont(name: fontname.rawValue, size: CGFloat(size))!
    }
    
}
