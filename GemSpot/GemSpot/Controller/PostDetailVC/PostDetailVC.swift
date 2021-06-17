//
//  OtherProfileVC.swift
//  GemSpot
//
//  Created by Jaydeep on 02/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit
import MapKit
import ImageSlideshow
import ActiveLabel

class PostDetailVC: UIViewController {
    
    //MARK:- Variable Declaration
    
    var dictPostDetail = ClsPostListModel()
    var arrPostList = [ClsPostListModel]()
    var handlerUpdateList:(ClsPostListModel) -> Void = {_ in}
    var arrPostImage = [ClsPostListPostImage]()
    var selectedIndex = Int()
    var arrCommentList = [ClsCommentModel]()
    var isComeFromPush = false
    var strPostToken = String()
    var isCommentPush = false
//    var handlerOpen
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var tblPostDetail: UITableView!
    @IBOutlet weak var collectionPost: UICollectionView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPostDate: UILabel!
    @IBOutlet weak var imgUserProfile: CustomImageView!
    @IBOutlet weak var btnLikeOutlet: UIButton!
    @IBOutlet weak var btnSaveOutlet: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTag: ActiveLabel!
    @IBOutlet weak var heightTblConstant: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionOfImage: UICollectionView!
    
    //MARK:- ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if self.isComeFromPush {
            var dict = [String:AnyObject]()
            dict["post_token"] = strPostToken as AnyObject?
            apiCallForGetPostDetail(param: dict)
       /* } else {
            setupUI()
        }*/
        
        
    }
    
    func setupUI() {
        isComeFromPush = false
        setupData()
        var dict = [String:AnyObject]()
        dict["latitude"] = dictPostDetail.latitude as AnyObject?
        dict["longitude"] = dictPostDetail.longitude as AnyObject?
        dict["post_token"] = dictPostDetail.postToken as AnyObject?
        apiCallForGetPostList(param: dict)
        
        var dictComment = [String:AnyObject]()
        dictComment["page"] = "1" as AnyObject?
        dictComment["limit"] = "5" as AnyObject?
        dictComment["post_token"] = dictPostDetail.postToken as AnyObject?
        apiCallForGetPostCommentList(param: dictComment)
        
        self.tblPostDetail.tableFooterView = UIView()
        
        if isCommentPush {
            self.isCommentPush = false
            self.btnViewAllAction(UIButton())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        
        let btnBack = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(btnBackAction(_:)))
        btnBack.tintColor = .white
        
        let btnBackTitle = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        btnBackTitle.tintColor = .white
        
        self.navigationItem.leftBarButtonItems = [btnBack,btnBackTitle]
        
        let btnRight = UIBarButtonItem(image: UIImage(named: "ic_left_place_pin"), style: .plain, target: self, action: #selector(btnGoToPostAction))
        btnRight.tintColor = .white
        self.navigationItem.rightBarButtonItem = btnRight
        
        tblPostDetail.addObserver(self, forKeyPath: "contentSize", options: [.new], context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tblPostDetail.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is UITableView {
            print("contentSize:= \(tblPostDetail.contentSize.height)")
            self.heightTblConstant.constant = tblPostDetail.contentSize.height
            if self.heightTblConstant.constant == 0 {
                self.heightTblConstant.constant = 100
            }
        }
    }
    
    func setupData() {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter.dateFormate2.rawValue
        formatter.locale = .current
        formatter.timeZone = .current
        let createDate = formatter.date(from: dictPostDetail.postDate)
        formatter.dateFormat = dateFormatter.dateFormate1.rawValue
        formatter.locale = .current
        formatter.timeZone = .current
        let strDate = formatter.string(from: createDate ?? Date())
        
        self.lblUserName.text = dictPostDetail.username
        self.lblPostDate.text = strDate
        
        arrPostImage = dictPostDetail.postImages
        self.pageControl.numberOfPages = arrPostImage.count
        self.collectionOfImage.reloadData()
        
        self.imgUserProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgUserProfile.sd_setImage(with: URL(string: "\(URL_USER_PROFILE_IMAGES)\(dictPostDetail.profileImage ?? "")"), placeholderImage: UIImage(named: "ic_username"), options: .lowPriority, context: nil)
        /*self.imgPost.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgPost.sd_setImage(with: URL(string: URL_POST_PIC+(dictPostDetail.postImage ?? "")), placeholderImage: UIImage(named: "image_placehoder"), options: .lowPriority, context: nil)*/
        
        self.lblDescription.text = "\(dictPostDetail.postDescription ?? "")"
        
        var strTag = dictPostDetail.postTag
        strTag = strTag?.replacingOccurrences(of: ",", with: " ")
        self.lblTag.text = strTag
        self.lblTag.textColor = .blue
        self.lblTag.enabledTypes = [.hashtag]
        self.lblTag.mentionColor = .blue
        self.lblTag.mentionSelectedColor = .blue

        self.btnLikeOutlet.isSelected = dictPostDetail.likeStatus == 0 ? false : true
        self.btnSaveOutlet.isSelected = dictPostDetail.saveStatus == 0 ? false : true
        self.btnLikeOutlet.setTitle("\(dictPostDetail.cntLike ?? 0)", for: .normal)
    }
    
    //MARK:- Action Zone
    
    @objc func btnGoToPostAction() {
        /*let obj = homeStoryboard.instantiateViewController(withIdentifier: "ShowOnePostVC") as! ShowOnePostVC
        obj.dictPost = dictPostDetail
        self.navigationController?.pushViewController(obj, animated: true)*/
        dictSelectedAnnotation = dictPostDetail
        appDelegate.objTabbar.selectedIndex = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.navigationController?.popToRootViewController(animated: true)
        })
        
        
    }
    
    @IBAction func btnViewAllAction(_ sender:UIButton) {
        let obj = homeStoryboard.instantiateViewController(withIdentifier: "ShowCommentVC") as! ShowCommentVC
        obj.dictPostDetail = dictPostDetail
        obj.handlerAddComment = {[weak self] arr in
            self?.arrCommentList = arr
            self?.tblPostDetail.reloadData()
        }
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnSaveAction(_ sender: UIButton) {
        var param:[String:AnyObject] = [:]
        param["save_status"] = dictPostDetail.saveStatus == 0 ? 1 as AnyObject : 0 as AnyObject
        param["post_token"] = dictPostDetail.postToken as AnyObject?
        apiCallForUpdateSaveStatus(param: param)
    }
    
    @IBAction func btnLikeAction(_ sender: UIButton) {
        var param:[String:AnyObject] = [:]
        param["like_status"] = dictPostDetail.likeStatus == 0 ? 1 as AnyObject : 0 as AnyObject
        param["post_token"] = dictPostDetail.postToken as AnyObject?
        apiCallForUpdateLikeStatus(param: param)
    }
    
    @IBAction func btnDireactionAction(_ sender: UIButton) {        
        let coordinate = CLLocationCoordinate2D(latitude: dictPostDetail.latitude, longitude: dictPostDetail.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    @IBAction func btnVideoPlayAction(_ sender: UIButton) {
        /*if dictPostDetail.isVideo == 1 {
            guard var str = dictPostDetail.postImage else { return }
            str = str.replacingOccurrences(of: ".png", with: ".mp4")
            str = URL_POST_PIC+str
            let videoURL = URL(string:str)
            guard let videoUrl = videoURL else { return }
            playVideo(url: videoUrl)
        }
        else {
            let fullScreenController = self.viewPost.presentFullScreenController(from: self)
            // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
            fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .gray, color: nil)
        }*/
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
//        vc.videoGravity = .resizeAspectFill
        vc.player = player
        self.present(vc, animated: true) { vc.player?.play() }
    }
    
    @IBAction func btnLikeUnlikeCommentAction(_ sender : UIButton) {
        let dictComment = self.arrCommentList[sender.tag]
        var param:[String:AnyObject] = [:]
        param["like_status"] = dictComment.likeStatus == 0 ? 1 as AnyObject : 0 as AnyObject
        param["comment_token"] = dictComment.commentToken as AnyObject?
        param["post_token"] = dictComment.postToken as AnyObject?
        apiCallForUpdateCommentLikeStatus(param: param, tag: sender.tag)
    }
    
    @IBAction func btnGoToProfileAction(_ sender:UIButton) {       
        let obj = profileStoryboard.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC
        obj.isComeFromOwn = dictPostDetail.userToken == appDelegate.objUser?.userToken ? .own : .other
        obj.dictProfile = ClsUserLoginModel(fromDictionary: dictPostDetail.toDictionary())
        self.navigationController?.pushViewController(obj, animated: true)
    }
}

//MARK:- TableView Delegate

extension PostDetailVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrCommentList.count == 0 {
            let lbl = UILabel()
            lbl.text = "No comments available"
            lbl.textAlignment = NSTextAlignment.center
            lbl.textColor = UIColor.black
            lbl.font = themeFont(size: 14, fontname: .regular)
            lbl.center = tableView.center
            tableView.backgroundView = lbl
            return 0
        }
        tableView.backgroundView = nil
        return arrCommentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        let dict = arrCommentList[indexPath.row]
        cell.lblComment.text = dict.commentText
        cell.lblUsername.text = dict.username
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgProfile.sd_setImage(with: URL(string: "\(URL_USER_PROFILE_IMAGES)\(dict.profileImage ?? "")"), placeholderImage: UIImage(named: "ic_username"), options: .lowPriority, context: nil)
        cell.btnLikeOutlet.isSelected = dict.likeStatus == 0 ? false : true
        cell.btnLikeOutlet.tag = indexPath.row
        cell.btnLikeOutlet.addTarget(self, action: #selector(btnLikeUnlikeCommentAction(_:)), for: .touchUpInside)
        return cell
    }
}

//MARK:- TableView Delegate

extension PostDetailVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionPost {
            if arrPostList.count == 0 {
                let lbl = UILabel()
                lbl.text = "No near by post available"
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
        return arrPostImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionPost {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionCell", for: indexPath) as! ProfileCollectionCell
            let dict = arrPostList[indexPath.row].postImages[0]
            if dict.isVideo == 0 {
                cell.imgPost.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imgPost.sd_setImage(with: URL(string: URL_POST_PIC+(dict.postImages ?? "")), placeholderImage: UIImage(named: "image_placehoder"), options: .lowPriority, context: nil)
            } else {
                cell.imgPost.sd_imageIndicator = SDWebImageActivityIndicator.gray
                let image = dict.postImages.replacingOccurrences(of: "mp4", with: "png")
                cell.imgPost.sd_setImage(with: URL(string: URL_POST_PIC+image), placeholderImage: UIImage(named: "image_placehoder"), options: .lowPriority, context: nil)
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageFilterCell", for: indexPath) as! ImageFilterCell
        let dict = arrPostImage[indexPath.row]
        
        if dict.isVideo == 0 {
            cell.imgFilter.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgFilter.sd_setImage(with: URL(string: URL_POST_PIC+(dict.postImages ?? "")), placeholderImage: UIImage(named: "image_placehoder"), options: .lowPriority, context: nil)
            let sdWebImageSource = [SDWebImageSource(urlString:URL_POST_PIC+(dict.postImages ?? ""))!]
            cell.viewPost.activityIndicator = DefaultActivityIndicator()
            cell.viewPost.setImageInputs(sdWebImageSource)
        } else {
            cell.imgFilter.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let image = dict.postImages.replacingOccurrences(of: "mp4", with: "png")
            cell.imgFilter.sd_setImage(with: URL(string: URL_POST_PIC+image), placeholderImage: UIImage(named: "image_placehoder"), options: .lowPriority, context: nil)
        }
        cell.btnVideoPlayOutlet.isHidden = dict.isVideo == 0 ? true : false
        cell.btnDeleteOutlet.isHidden = true
        return cell
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionPost {
            return CGSize(width: 120, height: 70)
        }
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionOfImage {
            let pageWidth = scrollView.frame.size.width
            selectedIndex = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            pageControl.currentPage = selectedIndex
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionPost {
            let obj = homeStoryboard.instantiateViewController(withIdentifier: "PostDetailVC") as! PostDetailVC
            obj.strPostToken = arrPostList[indexPath.row].postToken
            obj.dictPostDetail = arrPostList[indexPath.row]
            obj.hidesBottomBarWhenPushed = true
            obj.handlerUpdateList = {[weak self] dict in
                if let index = self?.arrPostList.firstIndex(where: {$0.postId == dict.postId}) {
                    print("index \(index)")
                    self?.arrPostList[index] = dict
                    if dict.postId == self?.dictPostDetail.postId {
                        self?.dictPostDetail = dict
                        self?.setupData()
                        self?.handlerUpdateList(dict)
                    }
                }
            }
            self.navigationController?.pushViewController(obj, animated: true)
        } else {
            let dict = arrPostImage[indexPath.row]
            if dict.isVideo == 0 {
                if let cell = collectionOfImage.cellForItem(at: IndexPath(row: indexPath.row, section: 0)) as? ImageFilterCell {
                    let fullScreenController = cell.viewPost.presentFullScreenController(from: self)
                    fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .gray, color: nil)
                }
            } else {
                let url =  URL(string: URL_POST_PIC+(dict.postImages ?? ""))!
                playVideo(url: url)
            }
        }
    }
}

//MARK:- API

extension PostDetailVC {
    
    func apiCallForGetPostList(param:[String:AnyObject])  {
        
        ServiceManager.callAPI(url: URL_GET_NEAR_BY_POST_LIST, parameter: param, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let arrData  = dictData["data"] as? NSArray {
                        self.arrPostList.removeAll()
                        for dict in arrData {
                            let model = ClsPostListModel(fromDictionary: dict as! NSDictionary)
                            if model.postImages.count != 0 {
                              self.arrPostList.append(model)
                            }
                            
                        }
                    }
                }  else {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                }
                self.collectionPost.reloadData()
            }else{
                makeToast(strMessage: DEFAULT_ERROR)
            }
        }, failure: { (error) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: msg)
        })
    }
    
    func apiCallForUpdateLikeStatus(param:[String:AnyObject])  {
        ServiceManager.callAPI(url: URL_UPDATE_LIKE_STATUS, parameter: param,isShowLoader: false, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    let fav = param["like_status"] as! Int
                    if fav == 1 {
                        self.dictPostDetail.cntLike += 1
                        self.dictPostDetail.likeStatus = 1
                    } else {
                        self.dictPostDetail.cntLike -= 1
                        self.dictPostDetail.likeStatus = 0
                    }
                    self.setupData()
                    self.handlerUpdateList(self.dictPostDetail)
                }  else {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                }
            }else{
                makeToast(strMessage: DEFAULT_ERROR)
            }
        }, failure: { (error) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: msg)
        })
    }
    
    func apiCallForUpdateSaveStatus(param:[String:AnyObject])  {
        ServiceManager.callAPI(url: URL_UPDATE_SAVE_STATUS, parameter: param,isShowLoader: false, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    let fav = param["save_status"] as! Int
                    if fav == 1 {
                        self.dictPostDetail.saveStatus = 1
                    } else {
                        self.dictPostDetail.saveStatus = 0
                    }
                    self.setupData()
                    self.handlerUpdateList(self.dictPostDetail)
                }  else {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                }
            }else{
                makeToast(strMessage: DEFAULT_ERROR)
            }
        }, failure: { (error) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: msg)
        })
    }
    
    func apiCallForGetPostCommentList(param:[String:AnyObject])  {
        
        ServiceManager.callAPI(url: URL_GET_ALL_COMMENT, parameter: param, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let arrData  = dictData["data"] as? NSArray {
                        self.arrCommentList.removeAll()
                        for dict in arrData {
                            let model = ClsCommentModel(fromDictionary: dict as! NSDictionary)
                            self.arrCommentList.append(model)
                        }
                    }
                }  else {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                }
                self.tblPostDetail.reloadData()
            }else{
                makeToast(strMessage: DEFAULT_ERROR)
            }
        }, failure: { (error) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: msg)
        })
    }
    
    func apiCallForUpdateCommentLikeStatus(param:[String:AnyObject],tag:Int)  {
        ServiceManager.callAPI(url: URL_UPDATE_COMMENT_LIKE_STATUS, parameter: param,isShowLoader: false, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    let fav = param["like_status"] as! Int
                    let dict = self.arrCommentList[tag]
                    if fav == 1 {
                        dict.likeStatus = 1
                    } else {
                        dict.likeStatus = 0
                    }
                    self.arrCommentList[tag] = dict
                }  else {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                }
            }else{
                makeToast(strMessage: DEFAULT_ERROR)
            }
            self.tblPostDetail.reloadData()
        }, failure: { (error) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: msg)
        })
    }
    
    func apiCallForGetPostDetail(param:[String:AnyObject])  {
        
        ServiceManager.callAPI(url: URL_POST_DETAIL, parameter: param, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let dictData  = dictData["data"] as? NSDictionary {
                        self.dictPostDetail = ClsPostListModel(fromDictionary: dictData)
                        self.setupUI()
                    }
                }  else {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                }
            }else{
                makeToast(strMessage: DEFAULT_ERROR)
            }
        }, failure: { (error) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: msg)
        })
    }
   
}
