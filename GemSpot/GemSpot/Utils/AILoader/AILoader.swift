//
//  AILoader.swift
//
//  Created by Ravi Alagiya on 13/05/17.
//  Copyright © 2016 Agile Infoways. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


private var activityRestorationIdentifier: String {
    return "NVActivityIndicatorViewContainer"
}

public func ShowLoaderWithMessage(message:String) {
    startActivityAnimating(size: CGSize(width:56, height:56), message: message, type: NVActivityIndicatorType.ballScaleMultiple, color: APP_THEME_GREEN_COLOR, padding: 2,isFromOnView: false)
}


//MARK:- ShowLoader
//Mark:-


public func SHOW_CUSTOM_LOADER() {
    startActivityAnimating(size: CGSize(width:56, height:56), message: nil, type: NVActivityIndicatorType.ballScaleMultiple, color: APP_THEME_GREEN_COLOR, padding: 2,isFromOnView: false)
}


//MARK:- Hide Loader
//MARK:-


public func HIDE_CUSTOM_LOADER() {
    stopActivityAnimating(isFromOnView: false)
}


//MARK:- ShowLoaderOnView
//Mark:-


public func ShowLoaderOnView() {
    startActivityAnimating(size: CGSize(width:56, height:56), message: nil, type: NVActivityIndicatorType.ballScaleMultiple, color: APP_THEME_GREEN_COLOR, padding: 2,isFromOnView: true)
}


//MARK:- HideLoaderOnView
//MARK:-
public func HideLoaderOnView() {
    stopActivityAnimating(isFromOnView: true)
}

private func startActivityAnimating(size: CGSize? = nil, message: String? = nil, type: NVActivityIndicatorType? = nil, color: UIColor? = nil, padding: CGFloat? = nil, isFromOnView:Bool) {
    let activityContainer: UIView = UIView(frame: CGRect(x:0, y:0,width:SCREEN_WIDTH, height:SCREEN_HEIGHT))
    
    let colorBG = message == nil ? UIColor.black.withAlphaComponent(0.5) : UIColor.white.withAlphaComponent(1)
    let color = message == nil ? color : APP_THEME_BLACK_COLOR
    activityContainer.backgroundColor = colorBG
    activityContainer.restorationIdentifier = activityRestorationIdentifier
    
    activityContainer.isUserInteractionEnabled = false
    let actualSize = size ?? CGSize(width:56,height:56)
    
    let activityIndicatorView = NVActivityIndicatorView(
        frame: CGRect(x:0, y:0, width:actualSize.width, height:actualSize.height),
        type: type!,
        color: color!,
        padding: padding!)
    
    activityIndicatorView.center = activityContainer.center
    activityIndicatorView.startAnimating()
    activityContainer.addSubview(activityIndicatorView)
    

    if message != nil {
        let width = activityContainer.frame.size.width / 2
        if let message = message , !message.isEmpty {
            let label = UILabel(frame: CGRect(x:0, y:0,width:width, height:120))
            label.center = CGPoint(
                x:activityIndicatorView.center.x, y:
                activityIndicatorView.center.y + actualSize.height)
            label.textAlignment = .center
            label.text = message
            label.numberOfLines = 0
  //          label.font = UIFont.appFont_OpenSans_Regular_WithSize(16.0)
            label.textColor = activityIndicatorView.color
            activityContainer.addSubview(label)
        }
    }
    UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
    if isFromOnView == true {
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(activityContainer)
    }
    else {
        UIApplication.shared.keyWindow?.addSubview(activityContainer)
    }
}

/**
 Stop animation and remove from view hierarchy.
 */

private func stopActivityAnimating(isFromOnView:Bool) {
    UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
    if isFromOnView == true {
        let sub = UIApplication.shared.keyWindow?.rootViewController?.view.subviews ?? [UIView]()
        for item in sub
            where item.restorationIdentifier == activityRestorationIdentifier {
                item.removeFromSuperview()
        }
    }
    else {
        let sub = UIApplication.shared.keyWindow?.subviews ?? [UIView]()
        for item in sub
            where item.restorationIdentifier == activityRestorationIdentifier {
                item.removeFromSuperview()
        }
    }
}
