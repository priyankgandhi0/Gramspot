//
//  NotificationCell.swift
//  GemSpot
//
//  Created by Jaydeep on 04/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgProfile: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
