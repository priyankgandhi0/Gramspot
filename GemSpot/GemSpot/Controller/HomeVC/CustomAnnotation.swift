//
//  CustomAnnotation.swift
//  GemSpot
//
//  Created by Jaydeep on 01/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: MKPointAnnotation {
  
    var profileImage: String?
    var postedImage: String?
    var date: String?
    var name:String?
    var tag:Int?
    var isVideo:Int?
    var compressImage:String?

    override init() {
        self.profileImage = nil
        self.postedImage = nil
        self.date = nil
        self.name = nil
        self.tag = nil
        self.isVideo = nil
        self.compressImage = nil
    }
    
    
    
    
}
