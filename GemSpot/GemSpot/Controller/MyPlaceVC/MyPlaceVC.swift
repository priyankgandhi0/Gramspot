//
//  MyPlaceVC.swift
//  GemSpot
//
//  Created by Jaydeep on 01/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll
import SDWebImage

class MyPlaceVC: UIViewController {
    
    //MARK:- Variable Declaration
    
    var page = 1
    var limit = 50
    var arrPostList = [ClsPostListModel]()
    var refresher:UIRefreshControl!
    var strCurrentTitle = String()
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var postCollection:UICollectionView!
    
  //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let arr:[String] = arrDefaultTagList.map({$0.tagName})
        rigthDiscoverDD.dataSource = arr
        
        setRightBarButtonDiscover(arr[0])
        reloadPostList(tag: arr[0])
        strCurrentTitle = arr[0]
        selectionDropDown()
        
        self.refresher = UIRefreshControl()
        self.postCollection!.alwaysBounceVertical = true
        self.refresher.tintColor = APP_THEME_BLACK_COLOR
        self.refresher.addTarget(self, action: #selector(pullToReload), for: .valueChanged)
        self.postCollection!.addSubview(refresher)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationTitle("Discover")
        NotificationCenter.default.removeObserver(self, name: .didReloadMyPostList, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPostlist), name: .didReloadMyPostList, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        btnDiscoverRight.cornerRadius = btnDiscoverRight.frame.height/2
    }
  
    override func btnHomeRightAction(_ sender: UIButton) {
        configureDropdown(dropdown: rigthDiscoverDD, sender: btnDiscoverRight)
        rigthDiscoverDD.show()
    }
    
    func selectionDropDown() {
        rigthDiscoverDD.selectionAction =  {[weak self] index,titel in
            dictSelectedAnnotation = nil
            self?.setRightBarButtonDiscover(titel)
            btnDiscoverRight.sizeToFit()
            btnDiscoverRight.cornerRadius = btnDiscoverRight.frame.height/2
            self?.page = 1
            self?.reloadPostList(tag: titel)
            self?.strCurrentTitle = titel
        }
    }
    
    func reloadPostList(isShowLoader:Bool = true,tag:String) {
        var param:[String:AnyObject] = [:]
        param["page"] = page as AnyObject
        param["limit"] = limit as AnyObject
        param["tag"] = tag as AnyObject
        apiCallForGetUserPost(param: param,isShowloader:isShowLoader)
        
        postCollection.addInfiniteScroll(handler: { (tblview) in
            self.reloadPostList(isShowLoader:false, tag: tag)
        })
    }
    
    @objc func pullToReload(){
        page = 1
        reloadPostList(tag: strCurrentTitle)
    }
    
    @objc func refreshPostlist() {
        if let tag = btnDiscoverRight.title(for: .normal) {
            arrPostList.removeAll()
            self.postCollection.reloadData()
            page = 1
            strCurrentTitle = tag
            reloadPostList(isShowLoader: false, tag: strCurrentTitle)
        }
        
    }
   

}

//MARK:- Collection View Delegate

extension MyPlaceVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
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

extension MyPlaceVC {
    func apiCallForGetUserPost(param:[String:AnyObject],isShowloader:Bool)  {
        ServiceManager.callAPI(url: URL_GET_DISCOVER_POST_LIST, parameter: param,isShowLoader: isShowloader, success: { (response) in
            self.refresher.endRefreshing()
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
            self.refresher.endRefreshing()
            self.postCollection.finishInfiniteScroll()
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            self.refresher.endRefreshing()
            self.postCollection.finishInfiniteScroll()
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: msg)
        })
    }
}
