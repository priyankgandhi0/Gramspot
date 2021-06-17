//
//  HeaderTabCollectionCell.swift
//  EZCALL
//
//  Created by YASH on 1/11/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit

class HeaderTabCollectionCell: UICollectionViewCell {

    //MARK: - Outlet
    
    @IBOutlet weak var btnTitle: UIButton!
    @IBOutlet weak var vwUnderline: CustomView!
    
    
    //MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnTitle.setTitleColor(APP_THEME_GREEN_COLOR, for: .selected)
        btnTitle.setTitleColor(APP_THEME_GRAY_COLOR, for: .normal)
        
        btnTitle.titleLabel?.font = themeFont(size: 15, fontname: .regular)
        
        vwUnderline.backgroundColor = APP_THEME_GREEN_COLOR
        // Initialization code
    }

}
