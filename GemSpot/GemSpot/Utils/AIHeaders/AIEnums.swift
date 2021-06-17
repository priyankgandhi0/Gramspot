//
//  AIEnums.swift
//  Swift3CodeStructure
//
//  Created by Ravi Alagiya on 25/11/2016.
//  Copyright © 2016 Ravi Alagiya. All rights reserved.
//

import Foundation
import UIKit

//MARK:- AIEdge
enum AIEdge:Int {
	case
	top,
	left,
	bottom,
	right,
	top_Left,
	top_Right,
	bottom_Left,
	bottom_Right,
	all,
	none
}

enum dateFormatter:String {
    case dateFormate1 = "dd MMM yyyy"
    case dateFormate2 = "yyyy-MM-dd"
    case dateFormate3 = "yyyy-MM-dd HH:mm:ss"
    case dateFormate4 = "hh:mm a"
}

enum checkVideoPhoto {
    case video
    case photo
}

enum checkPostStatus {
    case add
    case edit
}

enum checkAddMore {
    case add
    case initial
}

enum followStatus:String {
    case followers = "0"
    case following = "1"
}

enum userProfileStatus {
    case own
    case other
}

enum userViewPostStatus {
    case post
    case saved
}
