//
//  PostListVC.swift
//  GemSpot
//
//  Created by Jaydeep on 03/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll
import SDWebImage

class PostListVC: UIViewController {
    
    //MARK:- Variable Declaration
    
    var page = 1
    var limit = 50
    var arrPostList = [ClsPostListModel]()
    var dictProfile = ClsUserLoginModel()
    var postStatus = userViewPostStatus.post    
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var postCollection:UICollectionView!
    
    //MARK:- ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadPostList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        
        let btnBack = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(btnBackAction(_:)))
        btnBack.tintColor = .white
        
        let btnBackTitle = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        btnBackTitle.tintColor = .white
        
        self.navigationItem.leftBarButtonItems = [btnBack,btnBackTitle]
        
        let btnRight = UIBarButtonItem(image: UIImage(named: "ic_left_place_pin"), style: .plain, target: self, action: #selector(btnMapViewAction))
        btnRight.tintColor = .white
        self.navigationItem.rightBarButtonItem = btnRight
    }
    
    func reloadPostList(isShowLoader:Bool = true) {
        var param:[String:AnyObject] = [:]
        param["page"] = page as AnyObject
        param["limit"] = limit as AnyObject
        param["user_token"] = dictProfile.userToken as AnyObject
        param["is_save"] = postStatus == .post ? "0" as AnyObject : "1" as AnyObject
        apiCallForGetUserPost(param: param,isShowloader:isShowLoader)
        
        postCollection.addInfiniteScroll(handler: { (tblview) in
            self.reloadPostList(isShowLoader:false)
        })
    }
    
    //MARK:- ACtion
    
    @objc func btnMapViewAction() {
        let obj = homeStoryboard.instantiateViewController(withIdentifier: "MyHomeVC") as! MyHomeVC
        obj.isComeFromOwn = .other
        obj.dictProfile = dictProfile
        obj.postStatus = postStatus
        self.navigationController?.pushViewController(obj, animated: false)
    }
    
    
    
}

//MARK:- Collection View Delegate

extension PostListVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrPostList.count == 0 {
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
        return arrPostList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionCell", for: indexPath) as! ProfileCollectionCell
        let dict = arrPostList[indexPath.row]
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/2)-10, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = arrPostList[indexPath.row]
        let obj = homeStoryboard.instantiateViewController(withIdentifier: "PostDetailVC") as! PostDetailVC
        obj.dictPostDetail = model
        obj.strPostToken = model.postToken
        obj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(obj, animated: true)
    }
}

//MARK:- API

extension PostListVC {
    
    func apiCallForGetUserPost(param:[String:AnyObject],isShowloader:Bool)  {
        ServiceManager.callAPI(url: URL_USER_POST_ALL_IMAGES, parameter: param,isShowLoader: isShowloader, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let arrData  = dictData["data"] as? NSArray {
                        if arrData.count == 0 {
                            self.postCollection.finishInfiniteScroll()
                            self.postCollection.reloadData()
                            return
                        }
                        if self.page <= 1 {
                            self.arrPostList.removeAll()
                        }
                        self.page += 1
                        for dict in arrData {
                            let model = ClsPostListModel(fromDictionary: dict as! NSDictionary)
                            self.arrPostList.append(model)
                        }
                    }
                }  else {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                }
            }else{
                makeToast(strMessage: DEFAULT_ERROR)
            }
            self.postCollection.reloadData()
        }, failure: { (error) in
            self.postCollection.finishInfiniteScroll()
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            self.postCollection.finishInfiniteScroll()
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: msg)
        })
    }
}
