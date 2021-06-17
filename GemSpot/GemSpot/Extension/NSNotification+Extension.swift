//
//  NSNotification+Extension.swift
//  GoodPaws
//
//  Created by Jaydeep on 15/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    static let didReloadPostList = Notification.Name("reloadPostList")
    static let didOpenAnnotation = Notification.Name("didOpenAnnotation")
    static let didClickAnnotaion = Notification.Name("didClickAnnotaion")
    static let didReloadMyPostList = Notification.Name("didReloadMyPostList")
}
