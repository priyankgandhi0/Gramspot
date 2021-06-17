//
//  CustomButton.swift
//  Pocket
//
//  Created by Jaydeep on 29/5/19.
//  Copyright © 2019 Jaydeep. All rights reserved.
//

import UIKit

@IBDesignable class CustomButton: UIButton {

    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    @IBInspectable
    var shadow : Float
    {
        get {
            return layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
            self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.layer.shadowRadius = 10.0
            self.layer.masksToBounds = false
        }
        
    }
    /*@IBInspectable
    var underline : CGFloat {
        get {
            return self.underline
        }
        set {
            
            let space:CGFloat = newValue
            let border = CALayer()
            border.backgroundColor = UIColor.red.cgColor
            border.frame = CGRect(x: 0, y: space, width: (self.titleLabel?.frame.size.width)!, height: 1)
            self.titleLabel?.layer.addSublayer(border)
        }
    }*/

    
    /*
 
     let space:CGFloat = 10
     
     button.setNeedsLayout()
     button.layoutIfNeeded()
     
     let border = CALayer()
     border.backgroundColor = UIColor.red.cgColor
     border.frame = CGRect(x: 0, y: (button.titleLabel?.frame.size.height)! + space, width: (button.titleLabel?.frame.size.width)!, height: 1)
     button.titleLabel?.layer.addSublayer(border)
    */
    
   /* @IBInspectable var borderColor:UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
//            layer.masksToBounds = cornerRadius > 0
        }
    }
//    MARK:- Shadow
    @IBInspectable var shadowOpacity:CGFloat = 0
    @IBInspectable var shadowRadius:CGFloat = 0
    @IBInspectable var shadowColor:UIColor = .clear
    @IBInspectable var shadowOffset:CGSize = CGSize(width: 0.0, height: 0.0)*/
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
