
//
//  CommentCell.swift
//  GemSpot
//
//  Created by Jaydeep on 18/03/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var btnLikeOutlet: UIButton!
    @IBOutlet weak var imgProfile:UIImageView!
    @IBOutlet weak var lblUsername:UILabel!
    @IBOutlet weak var lblComment:UILabel!
    
    //MARK:- View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
