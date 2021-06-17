//
//  FollowerCell.swift
//  GemSpot
//
//  Created by Jaydeep on 02/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit

class FollowerCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile:CustomImageView!
    @IBOutlet weak var lblUserName:UILabel!
    @IBOutlet weak var btnFollowOutlet:CustomButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
