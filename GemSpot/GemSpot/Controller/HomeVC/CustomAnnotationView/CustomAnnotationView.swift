//
//  CustomAnnotationView.swift
//  GemSpot
//
//  Created by Jaydeep on 01/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit

class CustomAnnotationView: UIView {

    @IBOutlet weak var btnPostDetailOutlet:UIButton!
    @IBOutlet weak var imgProfile:CustomImageView!
    @IBOutlet weak var imgPost:UIImageView!
    @IBOutlet weak var lblUserName:UILabel!
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var btnEditOutlet:CustomButton!
    
    override func draw(_ rect: CGRect) {
        imgPost.roundCorners([.bottomLeft,.bottomRight], radius: 5.0)
    }

}
