//
//  ProfileTableCell.swift
//  GemSpot
//
//  Created by Jaydeep on 02/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileTableCell: UITableViewCell {
    
    var handlerSelection:(ClsPostListModel) -> Void = {_ in}
    var arrPost = [ClsPostListModel]()
    var currentIndex = Int()
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var profileCollection:UICollectionView!
    @IBOutlet weak var btnViewAll:UIButton!
    @IBOutlet weak var lblTitle:UILabel!
    
    //MARK:- ViewLife Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK:- Collection View Delegate

extension ProfileTableCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrPost.count == 0 {
            let lbl = UILabel()
            lbl.text = "No post available"
            lbl.textAlignment = NSTextAlignment.center
            lbl.textColor = UIColor.black
            lbl.font = themeFont(size: 14, fontname: .regular)
            lbl.center = collectionView.center
            collectionView.backgroundView = lbl
            return 0
        }
        collectionView.backgroundView = nil
        return arrPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionCell", for: indexPath) as! ProfileCollectionCell
        let dict = arrPost[indexPath.row]
        if currentIndex == 0 {
            if dict.isVideo == 0 {
                cell.imgPost.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imgPost.sd_setImage(with: URL(string: URL_POST_PIC+(dict.postImage ?? "")), placeholderImage: UIImage(named: "image_placehoder"), options: .lowPriority, context: nil)
            } else {
                cell.imgPost.sd_imageIndicator = SDWebImageActivityIndicator.gray
                let image = dict.postImage.replacingOccurrences(of: "mp4", with: "png")
                cell.imgPost.sd_setImage(with: URL(string: URL_POST_PIC+image), placeholderImage: UIImage(named: "image_placehoder"), options: .lowPriority, context: nil)
            }
            return cell
        }
        if arrPost[indexPath.row].postImages.count == 0 {
            cell.imgPost.image = UIImage(named: "image_placehoder")
            return cell
        }
        let dictImages = arrPost[indexPath.row].postImages[0]
        if dict.isVideo == 0 {
            cell.imgPost.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgPost.sd_setImage(with: URL(string: URL_POST_PIC+(dictImages.postImages ?? "")), placeholderImage: UIImage(named: "image_placehoder"), options: .lowPriority, context: nil)
        } else {
            cell.imgPost.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let image = dictImages.postImages.replacingOccurrences(of: "mp4", with: "png")
            cell.imgPost.sd_setImage(with: URL(string: URL_POST_PIC+image), placeholderImage: UIImage(named: "image_placehoder"), options: .lowPriority, context: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/2), height: 115)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
        handlerSelection(arrPost[indexPath.row])
    }
}
