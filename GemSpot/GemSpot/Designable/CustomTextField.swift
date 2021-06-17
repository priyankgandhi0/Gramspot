//
//  CustomTextField.swift
//  Pocket
//
//  Created by Jaydeep on 29/5/19.
//  Copyright © 2019 Jaydeep. All rights reserved.
//

import UIKit

@IBDesignable class CustomTextField: UITextField {

    @IBInspectable
    var leftPaddingView: Int {
        get{
            return self.leftPaddingView
        }
        set {
            let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: 10))
            leftViewMode = .always
            leftView = paddingView
        }
    }
    
    @IBInspectable
    var rightPaddingView: Int {
        get{
            return self.rightPaddingView
        }
        set {
            let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: 10))
            rightViewMode = .always
            rightView = paddingView
        }
    }
    @IBInspectable var leftImage : UIImage? {
        didSet {
            if let image = leftImage {
                leftViewMode = .always
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                imageView.image = image
                imageView.tintColor = tintColor
                let view = UIView(frame : CGRect(x:0, y: 0, width: 40, height: frame.height))
                imageView.center = view.center
                view.addSubview(imageView)
                leftView = view
            }else {
                leftViewMode = .never
            }
        }
    }
    
    @IBInspectable var rightImage : UIImage? {
        didSet {
            if let image = rightImage {
                rightViewMode = .always
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                imageView.image = image
                imageView.tintColor = tintColor
                let view = UIView(frame : CGRect(x: -15, y: 0, width: 30, height: frame.height))
                imageView.center = view.center
                view.addSubview(imageView)
                rightView = view
            } else {
                rightViewMode = .never
            }
        }
    }

    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
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
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
