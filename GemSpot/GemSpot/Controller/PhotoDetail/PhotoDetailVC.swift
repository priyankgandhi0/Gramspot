//
//  PhotoDetailVC.swift
//  GemSpot
//
//  Created by Jaydeep on 04/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import TagListView
import CoreLocation
import AVKit
import SDWebImage
import ImageSlideshow
import DropDown

class PhotoDetailVC: UIViewController {
    
    //MARK:- Variable Declaration
    
    var imgSelected = UIImage()
    var selectedLatLong = CLLocationCoordinate2D()
    let datePicker = UIDatePicker()
    var selectDate:Date?
    var selectedPostStatus = checkPostStatus.add
    var dictPostDetail = ClsPostListModel()
    var selectedIndex = Int()
    var handlerUpdatePost:(ClsPostListModel) -> Void = {_ in}
    var handlerUpdateImages:(ClsPostListModel,Int) -> Void = {_,_ in}
    var arrSelectedTag = [ClsTagListModel]()
    var ddTag = DropDown()
    
    //MARK:- Outlet zone
    
    @IBOutlet weak var imgPost:UIImageView!
    @IBOutlet weak var txtView: CustomTextview!
    @IBOutlet weak var lblPlaceholder: UILabel!
    @IBOutlet weak var viewPhotoTag: TagListView!
    @IBOutlet weak var txtAddTag: CustomTextField!
    @IBOutlet weak var txtPostDate: CustomTextField!
    @IBOutlet weak var btnAddTagOutlet: CustomButton!
    @IBOutlet weak var btnVideoPlayOutlet: UIButton!
    @IBOutlet weak var viewConfirm: UIView!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionOfImage: UICollectionView!
    
    
    //MARK:- ViewLife Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrSelectedTag = arrDefaultTagList
        self.lblPlaceholder.text = "Description...\nSuggestions: How did you get here? \nWhat else is around?"
        
        setupTagView()
        showDatePicker()
        txtAddTag.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        ddTag.selectionAction = {[weak self] index,item in
            self?.viewPhotoTag.addTag("#\(item)")
            self?.txtAddTag.text = ""
            self?.txtAddTag.resignFirstResponder()
        }
  
        self.txtView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        if selectedPostStatus == .edit {
            print("dict \(dictPostDetail)")
            arrMainSelectedImage = dictPostDetail.postImages
            for i in 0..<arrMainSelectedImage.count {
                let dict = arrMainSelectedImage[i]
                dict.isUploaded = 1
                arrMainSelectedImage[i] = dict
            }
            self.viewConfirm.isHidden = true
            self.txtView.text = dictPostDetail.postDescription
            textViewDidChange(self.txtView!)
            if dictPostDetail.postTag != "" {
                let arr = dictPostDetail.postTag.components(separatedBy: ",")
                for i in 0..<arr.count {
                    let str = arr[i]
                    if str.contains("#") {
                        viewPhotoTag.addTag(str)
                    } else {
                       viewPhotoTag.addTag("#\(str)")
                    }
                }
            }
            
            var formatter = DateFormatter()
            formatter.dateFormat = dateFormatter.dateFormate2.rawValue
            formatter.locale = .current
            formatter.timeZone = .current
            let postDate = formatter.date(from: dictPostDetail.postDate) ?? Date()
            formatter = DateFormatter()
            formatter.dateFormat = dateFormatter.dateFormate1.rawValue
            formatter.locale = .current
            formatter.timeZone = .current
            let strDate = formatter.string(from: postDate)
            txtPostDate.text = strDate
            selectedLatLong = CLLocationCoordinate2D(latitude: dictPostDetail.latitude, longitude: dictPostDetail.longitude)
        } else {
            
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormatter.dateFormate1.rawValue
            let strDate = formatter.string(from: selectDate ?? Date())
            txtPostDate.text = strDate
            self.viewDelete.isHidden = true
            self.viewEdit.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        pageControl.numberOfPages = arrMainSelectedImage.count
        self.collectionOfImage.reloadData()
        setupNavigationBar()
        
        let btnBack = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(btnBackAction(_:)))
        btnBack.tintColor = .white
        
        var btnStatus = UIBarButtonItem()
        if selectedPostStatus == .add {
            btnStatus = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
            btnStatus.tintColor = .white
            self.navigationItem.leftBarButtonItems = [btnBack,btnStatus]
            
            let btnRight = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(btnAddPhotoAction))
            btnRight.tintColor = .white
            self.navigationItem.rightBarButtonItem = btnRight
            
        } else {
            /*btnStatus = UIBarButtonItem(image: UIImage(named: "ic_left_place_pin"), style: .plain, target: self, action: #selector(btnSelectLocation))
            btnStatus.tintColor = .white
            self.navigationItem.leftBarButtonItems = nil*/
            
            self.navigationItem.setHidesBackButton(true, animated: true)
            
            let btnRight = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(btnAddPhotoAction))
            btnRight.tintColor = .white
            self.navigationItem.rightBarButtonItem = btnRight
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        configureDropdown(dropdown: ddTag, sender: txtAddTag,isWidth: true)
    }
    
    @objc func btnAddPhotoAction() {
        let obj = customeCameraStoryboard.instantiateViewController(withIdentifier: "CustomCameraVC") as! CustomCameraVC
        obj.statusAddMoreImage = .add
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func setupTagView() {
        viewPhotoTag.tagBackgroundColor = APP_THEME_BLACK_COLOR.withAlphaComponent(0.2)
        viewPhotoTag.textFont = themeFont(size: 12, fontname: .bold)
        viewPhotoTag.textColor = APP_THEME_BLACK_COLOR
        viewPhotoTag.marginX = 5
        viewPhotoTag.marginY = 5
        viewPhotoTag.paddingX = 10
        viewPhotoTag.paddingY = 10
        viewPhotoTag.cornerRadius = 16
        viewPhotoTag.enableRemoveButton = true
        viewPhotoTag.removeIconLineColor = APP_THEME_BLACK_COLOR
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode =  .date
        datePicker.maximumDate = Date()
        datePicker.backgroundColor = .white
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.tintColor = APP_THEME_BLACK_COLOR
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        txtPostDate.inputAccessoryView = toolbar
        txtPostDate.inputView = datePicker
        
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
        selectDate = nil
        txtPostDate.text = ""
    }
    
    @objc func doneDatePicker(){
        let date = datePicker.date
        selectDate = date
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter.dateFormate1.rawValue
        let strDate = formatter.string(from: date)
        txtPostDate.text = strDate
        
        self.view.endEditing(true)
    }
    
    @objc func btnSelectLocation() {
        let obj = customeCameraStoryboard.instantiateViewController(withIdentifier: "PictureLocationVC") as! PictureLocationVC
        obj.selectedPostStatus = selectedPostStatus
        obj.dictPostDetail = dictPostDetail
        obj.handlerUpdateLatLong = {[weak self] updatedLatLong in
            self?.selectedLatLong = updatedLatLong
        }
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    
}

//MARK:- Action Zone

extension PhotoDetailVC {
    
    @IBAction func btnAddTagAction(_ sender:UIButton) {
        
        let arr = self.txtAddTag.text?.components(separatedBy: "#")
        for i in 0..<arr!.count {
            let strTag = arr![i].trimString()
            if strTag != "" {
                if strTag.contains("#") {
                    viewPhotoTag.addTag("\(strTag)")
                } else {
                    viewPhotoTag.addTag("#\(strTag)")
                }
            }
        }
        
        txtAddTag.text = ""
        textFieldDidChange(txtAddTag)
    }
    
    @IBAction func btnPost(_ sender:UIButton) {
        print("TagList \(viewPhotoTag.tagViews.map({($0.titleLabel?.text)!}).joined(separator: ","))")
        if arrMainSelectedImage.count == 0 {
            makeToast(strMessage: "You can not post add image, please add at least one image")
            return
        }
        addNewPost()
    }
    
    @IBAction func btnDeleteAction(_ sender:UIButton) {
        displayAlertWithTitle(APP_NAME, andMessage: "Are you sure want to delete this post?", buttons: ["Yes","No"]) { (tag) in
            if tag == 0 {
                let dict:[String:AnyObject] = ["post_token":self.dictPostDetail.postToken as AnyObject,
                                               "user_token":self.dictPostDetail.userToken as AnyObject]
                self.apiCallForDeletePost(param: dict)
            }
        }
    }
    
    @IBAction func btnEditAction(_ sender:UIButton) {
        if arrMainSelectedImage.count == 0 {
            makeToast(strMessage: "You can not edit post, please add at least one image")
            return
        }
        editNewPost()
    }
 
    @IBAction func btnDeleteImageAction(_ sender:UIButton) {
        let dict = arrMainSelectedImage[sender.tag]
        if dict.isUploaded == 0 {
            arrMainSelectedImage.remove(at: sender.tag)
            self.pageControl.numberOfPages = arrMainSelectedImage.count
            self.collectionOfImage.reloadData()
        } else {
            var param = [String:AnyObject]()
            param["user_post_image_id"] = dict.userPostImageId as AnyObject?
            apiCallForDeleteSignleImages(param: param, tag: sender.tag)
        }
        
    }
       
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
//        vc.videoGravity = .resizeAspectFill
        vc.player = player
        self.present(vc, animated: true) { vc.player?.play() }
    }
    
    
    
}


//MARK:- TextField Delegate

extension PhotoDetailVC:UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {        
        let arr = arrSelectedTag.filter({$0.tagName.contains(textField.text ?? "")})
        let arrAdded = viewPhotoTag.tagViews.map({($0.titleLabel?.text?.replacingOccurrences(of: "#", with: ""))!})
        let arrFinal:[String] = arr.map({$0.tagName}).difference(from: arrAdded)
        ddTag.dataSource = arrFinal
        ddTag.show()
        self.btnAddTagOutlet.alpha = textField.text == "" ? 0.5 : 1
        self.btnAddTagOutlet.isUserInteractionEnabled = textField.text == "" ? false : true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let arrAdded = viewPhotoTag.tagViews.map({($0.titleLabel?.text?.replacingOccurrences(of: "#", with: ""))!})
        let arrFinal:[String] = arrSelectedTag.map({$0.tagName}).difference(from: arrAdded)
        ddTag.dataSource = arrFinal
        ddTag.show()
        return false
    }
}

//MARK:- UICollectionView Delegate Method

extension PhotoDetailVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMainSelectedImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageFilterCell", for: indexPath) as! ImageFilterCell
        
        let dict = arrMainSelectedImage[indexPath.row]
        cell.btnDeleteOutlet.tag = indexPath.row
        cell.btnDeleteOutlet.addTarget(self, action: #selector(btnDeleteImageAction(_:)), for: .touchUpInside)
        
        if dict.isUploaded == 0 {
            // new
            cell.imgFilter.image = dict.image
            cell.btnDeleteOutlet.isHidden = false
            cell.btnVideoPlayOutlet.isHidden = dict.isVideo == 0 ? true : false
        } else {
            //            already
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
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        selectedIndex = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageControl.currentPage = selectedIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = arrMainSelectedImage[indexPath.row]
        
        if dict.isUploaded == 0 {
            if dict.isVideo == 1 {
                playVideo(url: dict.videoURL)
            }
        } else {
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

//MARK:- TextView Delegate

extension PhotoDetailVC:UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.lblPlaceholder.isHidden = textView.text == "" ? false : true
    }
}

//MARK:- TagView

extension PhotoDetailVC : TagListViewDelegate{
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        sender.removeTagView(tagView)
    }
}

//MARK:- API

extension PhotoDetailVC {
    
    func addNewPost() {
        
        var dict = [String:AnyObject]()
        dict["latitude"] = String(selectedLatLong.latitude) as AnyObject
        dict["longitude"] = String(selectedLatLong.longitude) as AnyObject
        dict["description"] = txtView.text.trimString() as AnyObject
        if txtPostDate.text != "" {
            let date = StringToDate(Formatter: dateFormatter.dateFormate1.rawValue, strDate: self.txtPostDate.text!)
            let tmpDate = DateToString(Formatter: dateFormatter.dateFormate2.rawValue, date: date)
            dict["post_date"] = tmpDate as AnyObject
        }
        if viewPhotoTag.tagViews.count != 0 {
            dict["post_tag"] = viewPhotoTag.tagViews.map({($0.titleLabel?.text)!}).joined(separator: ",") as AnyObject
        }
        
        ServiceManager.makeReqeusrWithMultipartData(with: URL_ADD_NEW_POST_WITH_MULTIPLE_IMAGE,method: .post, parameter: dict, arrObject: arrMainSelectedImage,success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    arrMainSelectedImage = [ClsPostListPostImage]()
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                    NotificationCenter.default.post(name: .didReloadPostList, object: nil)
//                    self.navigationController?.popToRootViewController(animated: true)
                    appDelegate.objTabbar.selectedIndex = 0
                } else {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                }
            }else{
                makeToast(strMessage: DEFAULT_ERROR)
            }
        }, failure: { (error) in
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            makeToast(strMessage: msg)
        })
    }
    
    func editNewPost() {
        
        var dict = [String:AnyObject]()
        dict["latitude"] = String(selectedLatLong.latitude) as AnyObject
        dict["longitude"] = String(selectedLatLong.longitude) as AnyObject
        dict["description"] = txtView.text.trimString() as AnyObject
        dict["post_token"] = String(dictPostDetail.postToken) as AnyObject
        if txtPostDate.text != "" {
            let date = StringToDate(Formatter: dateFormatter.dateFormate1.rawValue, strDate: self.txtPostDate.text!)
            let tmpDate = DateToString(Formatter: dateFormatter.dateFormate2.rawValue, date: date)
            dict["post_date"] = tmpDate as AnyObject
        }
        if viewPhotoTag.tagViews.count != 0 {
            dict["post_tag"] = viewPhotoTag.tagViews.map({($0.titleLabel?.text)!}).joined(separator: ",") as AnyObject
        }
        
        ServiceManager.makeReqeusrWithMultipartData(with: URL_EDIT_POST_WITH_MULTIPLE_IMAGE,method: .post, parameter: dict, arrObject: arrMainSelectedImage,success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    arrMainSelectedImage = [ClsPostListPostImage]()
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                    NotificationCenter.default.post(name: .didReloadPostList, object: nil)
                    self.navigationController?.backToViewController(vc: MyHomeVC.self)
                } else {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                }
            }else{
                makeToast(strMessage: DEFAULT_ERROR)
            }
        }, failure: { (error) in
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            makeToast(strMessage: msg)
        })
    }
    
    func apiCallForDeletePost(param:[String:AnyObject])  {
        
        ServiceManager.callAPI(url: URL_DELETE_POST, parameter: param, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
//                    NotificationCenter.default.post(name: .didReloadMyPostList, object: nil)
                    arrMainSelectedImage = [ClsPostListPostImage]()
                    self.handlerUpdatePost(self.dictPostDetail)
                    self.navigationController?.backToViewController(vc: MyHomeVC.self)
                } else {
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
    
    func apiCallForDeleteSignleImages(param:[String:AnyObject],tag:Int)  {
        
        ServiceManager.callAPI(url: URL_DELETE_SINGLE_POST, parameter: param, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    /*if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }*/
                    let postToken = arrMainSelectedImage[tag].userPostImageId
                    self.handlerUpdateImages(self.dictPostDetail,postToken ?? 0)
                    arrMainSelectedImage.remove(at: tag)
                    if arrMainSelectedImage.count == 0 {
                        let dict:[String:AnyObject] = ["post_token":self.dictPostDetail.postToken as AnyObject,
                        "user_token":self.dictPostDetail.userToken as AnyObject]
                        self.apiCallForDeletePost(param: dict)
                    }
                    NotificationCenter.default.post(name: .didReloadMyPostList, object: nil)
                    self.collectionOfImage.reloadData()
                    self.pageControl.numberOfPages = arrMainSelectedImage.count
                } else {
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


