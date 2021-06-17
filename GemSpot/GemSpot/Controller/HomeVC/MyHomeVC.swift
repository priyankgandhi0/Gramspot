//
//  MyHomeVC.swift
//  GemSpot
//
//  Created by Jaydeep on 01/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SDWebImage

class MyHomeVC: UIViewController {
    
    //MARK:- Variable Declaration
    
    var isComeFromOwn = userProfileStatus.own
    var arrPostList = [ClsPostListModel]()
    var dictProfile = ClsUserLoginModel()
    var postStatus = userViewPostStatus.post
    var selectedAnnotaion : CustomAnnotation?
    var isNoLikePost = false
    var searchCoOrdinate = CLLocationCoordinate2D()
    
    //MARK:- OutetZone
    
    @IBOutlet weak var viewMap:MKMapView!
    
    //MARK:- ViewLife cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if isComeFromOwn == .own {
            setupPin()
            apiCallForGetTagList()
        } else {
            var dict:[String:AnyObject] = ["user_token":dictProfile.userToken as AnyObject]
            dict["is_save"] = postStatus == .post ? "0" as AnyObject : "1" as AnyObject
            apiCallForGetAllPostList(param: dict)
        }
        viewMap.register(UserClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        viewMap.register(UserClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPostList), name: .didReloadPostList, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arrMainSelectedImage = [ClsPostListPostImage]()
       
        if isComeFromOwn == .own {
            
            setupNavigationBar()
            
            let lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 21))
            lblTitle.font = themeFont(size: 18, fontname: .bold)
            lblTitle.text = "Explore"
            lblTitle.textColor = .white
            let leftBarButton = UIBarButtonItem(customView: lblTitle)
            
//            let btnSearch = UIBarButtonItem(title: "search this area", style: .plain, target: self, action: #selector(btnSearchAction))
//            btnSearch.tintColor = .white
//
            self.navigationItem.leftBarButtonItems = [leftBarButton]
            if dictSelectedAnnotation == nil{
                reloadPostList()
                
                rigthHomeDD.dataSource = ["Recommended Sights","Recent Sights","Saved Sights","Search this area"]
                           
                selectionDropDown()
            } else {
                let arrAllAnnotation = self.viewMap.annotations
                var isAnyFound = Bool()
                if arrPostList.count != 0 {
                    for i in 0..<arrAllAnnotation.count {
                        if let anno = arrAllAnnotation[i] as? CustomAnnotation {
                            if let tag = anno.tag {
                                if arrPostList[tag].postToken == dictSelectedAnnotation?.postToken {
                                    self.viewMap.selectAnnotation(anno, animated: true)
                                    let center = CLLocationCoordinate2D(latitude: dictSelectedAnnotation!.latitude, longitude: dictSelectedAnnotation!.longitude)
                                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                                   
                                    viewMap.setRegion(region, animated: true)
                                    isAnyFound = true
                                    break
                                }
                            }
                        }
                    }
                }
                
                if !isAnyFound && dictSelectedAnnotation != nil {
                    let anno = createAnnocation(dict: dictSelectedAnnotation!, tag: 0)
                    if arrAllAnnotation.count == 0 {
                        self.viewMap.addAnnotation(anno)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.viewMap.selectAnnotation(anno, animated: true)
                        }
                    }
                    let center = CLLocationCoordinate2D(latitude: dictSelectedAnnotation!.latitude, longitude: dictSelectedAnnotation!.longitude)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                   
                    viewMap.setRegion(region, animated: true)
//                    viewMap.tintColor = APP_THEME_GREEN_COLOR
                }
            }
           
        } else {
            setupNavigationBar()
            
            let btnBack = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(btnBackAction(_:)))
            btnBack.tintColor = .white
            
            let btnBackTitle = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
            btnBackTitle.tintColor = .white
            
            self.navigationItem.leftBarButtonItems = [btnBack,btnBackTitle]
            
            let btnRight = UIBarButtonItem(image: UIImage(named: "ic_list"), style: .plain, target: self, action: #selector(btnBackAction(_:)))
            btnRight.tintColor = .white
            self.navigationItem.rightBarButtonItem = btnRight
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectAnnotation), name: .didClickAnnotaion, object: nil)
        
    }
    
    override func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    @objc func btnSearchAction() {
        apiCallForGetNearByPostList()
    }
    
    override func btnHomeRightAction(_ sender: UIButton) {
        btnHomeRight.isSelected = true
        configureDropdown(dropdown: rigthHomeDD, sender: btnHomeRight)
        rigthHomeDD.show()
    }
    
    override func viewDidLayoutSubviews() {
        btnHomeRight.cornerRadius = btnHomeRight.frame.height/2
    }
    
    @objc func didSelectAnnotation(_ notification:Notification) {
        if let obj = notification.object as? CustomAnnotation {
            self.viewMap.selectAnnotation(obj, animated: true)
        } else if let obj = notification.object as? MKClusterAnnotation {
            openClustringAnnotation(cluster: obj)
        }
    }
    
    func selectionDropDown() {
        
        rigthHomeDD.selectionAction =  {[weak self] index,titel in
            dictSelectedAnnotation = nil
            btnHomeRight.isSelected = false
            self?.setRightBarButtonHome(titel)
            if titel == "Recommended Sights" {
                self?.apiCallForGetRecomamndedPostList()
            } else if titel == "Recent Sights" {
                self?.apiCallForGetRecentPostList()
            } else if titel == "Saved Sights" {
                let dict:[String:AnyObject] = ["user_token":appDelegate.objUser?.userToken as AnyObject]
                self?.apiCallForGetUserSavePostList(param: dict)
            } else if titel == "Search Sights"{
                
            } else if titel == "Search this area" {
                self?.btnSearchAction()
            }
        }
        
        rigthHomeDD.cancelAction =  { [unowned self] in
            print("Drop down dismissed")
            btnHomeRight.isSelected = false
        }
    }
    
    @objc func reloadPostList() {
        dictSelectedAnnotation = nil
        if let title = btnHomeRight.title(for: .normal) {
            if title == "Recommended Sights" {
                self.apiCallForGetRecomamndedPostList()
            } else if title == "Recent Sights" {
                self.apiCallForGetRecentPostList()
            } else if title == "Saved Sights" {
                let dict:[String:AnyObject] = ["user_token":appDelegate.objUser?.userToken as AnyObject]
                self.apiCallForGetUserSavePostList(param: dict)
            } else if title == "Search Sights" {
                
            } else if title == "Search this area" {
                self.btnSearchAction()
            }
            setRightBarButtonHome(title)
        } else {
            setRightBarButtonHome("Recommended Sights")
            self.apiCallForGetRecomamndedPostList()
        }
    }
    
    func setupPin() {
        viewMap.showsUserLocation = false
        let currentLocation = viewMap.userLocation.location
        let center = CLLocationCoordinate2D(latitude: currentLocation?.coordinate.latitude ?? kCurrentUserLocation.coordinate.latitude, longitude: currentLocation?.coordinate.longitude ?? kCurrentUserLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        searchCoOrdinate = center
        //set region on the map
        viewMap.setRegion(region, animated: true)
        viewMap.tintColor = APP_THEME_GREEN_COLOR
    }
    
}

//MARK:- Action Zone

extension MyHomeVC {
    @IBAction func btnPostDetailAction(_ sender: UIButton) {
        let obj = homeStoryboard.instantiateViewController(withIdentifier: "PostDetailVC") as! PostDetailVC
        if dictSelectedAnnotation == nil {
            obj.dictPostDetail = arrPostList[sender.tag]
            obj.strPostToken = arrPostList[sender.tag].postToken
        } else {
            obj.dictPostDetail = dictSelectedAnnotation!
            obj.strPostToken = (dictSelectedAnnotation?.postToken)!
        }
        obj.hidesBottomBarWhenPushed = true
        obj.handlerUpdateList = {[weak self] dict in
            if let index = self?.arrPostList.firstIndex(where: {$0.postId == dict.postId}) {
                print("index \(index)")
                self?.arrPostList[index] = dict
            }
        }
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnEditPostAction(_ sender: UIButton) {        
        let obj = customeCameraStoryboard.instantiateViewController(withIdentifier: "PhotoDetailVC") as! PhotoDetailVC
        if dictSelectedAnnotation == nil {
            obj.dictPostDetail = arrPostList[sender.tag]
        } else {
            obj.dictPostDetail = dictSelectedAnnotation!
        }
        obj.selectedPostStatus = .edit
        obj.handlerUpdatePost = {[weak self] dict in
            if let index = self?.arrPostList.firstIndex(where: {$0.postToken == dict.postToken}){
                self?.arrPostList.remove(at: index)
            }
            self?.addPinOnMap()
        }
        obj.handlerUpdateImages = {[weak self] dict,strImageToken in
            if let index = self?.arrPostList.firstIndex(where: {$0.postToken == dict.postToken}){
                let dictPost = self?.arrPostList[index]
                var arrPostImage = dictPost?.postImages
                if let imgIndex = arrPostImage?.firstIndex(where: {$0.userPostImageId == strImageToken}) {
                    arrPostImage?.remove(at: imgIndex)
                    dictPost?.postImages = arrPostImage
                    self?.arrPostList[index] = dictPost!
                    self?.addPinOnMap()
                }
            }
        }
        obj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnCurrentLocation(_ sender:UIButton) {
        setupPin()
    }
}

//MARK:- MKMap delegate

extension MyHomeVC :MKMapViewDelegate {
    
    func addPinOnMap() {
        let allAnnotations = self.viewMap.annotations
        self.viewMap.removeAnnotations(allAnnotations)
        for i in 0..<arrPostList.count {
            let dict = arrPostList[i]
            if dict.postImages.count != 0 {
                let anno = createAnnocation(dict: dict, tag: i)
                viewMap.addAnnotation(anno)
            }
        }
        if isComeFromOwn == .other {
            self.viewMap.showAnnotations(self.viewMap.annotations, animated: true)
        } else {
            var zoomRect = MKMapRect.null
//            if isNoLikePost {
                let arr = self.arrPostList.prefix(5)
                for i in 0..<arr.count {
                    let dict = arr[i]
                    let annotationPoint = MKMapPoint(CLLocationCoordinate2D(latitude: dict.latitude, longitude: dict.longitude))
                    let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
                    if zoomRect.isNull {
                        zoomRect = pointRect
                    } else {
                        zoomRect = zoomRect.union(pointRect)
                    }
                }
            /*} else {
                
                for i in 0..<arrPostList.count {
                    if i > 5{
                        break
                    }
                    if let dict = arrPostList.randomElement() {                        
                        let annotationPoint = MKMapPoint(CLLocationCoordinate2D(latitude: dict.latitude, longitude: dict.longitude))
                        let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
                        if zoomRect.isNull {
                            zoomRect = pointRect
                        } else {
                            zoomRect = zoomRect.union(pointRect)
                        }
                       
                    }
                }
            }*/
            
            viewMap.setVisibleMapRect(zoomRect, edgePadding: mapEdgePadding, animated: true)
        }
        
    }
    
    func createAnnocation(dict:ClsPostListModel,tag:Int) -> CustomAnnotation {
        let myAnnotation = CustomAnnotation()
        myAnnotation.name = dict.username
        myAnnotation.coordinate = CLLocationCoordinate2D(latitude: dict.latitude, longitude: dict.longitude)
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter.dateFormate2.rawValue
        formatter.locale = .current
        formatter.timeZone = .current
        let createDate = formatter.date(from: dict.postDate)
        
        formatter.dateFormat = dateFormatter.dateFormate1.rawValue
        formatter.locale = .current
        formatter.timeZone = .current
        let strDate = formatter.string(from: createDate ?? Date())
        
        myAnnotation.date = strDate
        myAnnotation.profileImage = dict.profileImage
        
        myAnnotation.postedImage = dict.postImages[0].postImages
        myAnnotation.isVideo = dict.postImages[0].isVideo
        myAnnotation.tag = tag
        myAnnotation.compressImage = dict.postImages[0].postCompressImage
        return myAnnotation
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        return UserAnnotationView(annotation: annotation, reuseIdentifier: UserAnnotationView.preferredClusteringIdentifier)
        
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotationView = view as? MKMarkerAnnotationView {
            if let customAnnotation = view.annotation as? CustomAnnotation {
                view.subviews.filter { $0 is CustomAnnotationView }.forEach{
                    $0.removeFromSuperview()
                }
                openAnnotation(annotationView: annotationView, annotaion: customAnnotation)
            } else if let cluster = view.annotation as? MKClusterAnnotation {
                openClustringAnnotation(cluster: cluster)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("co-ordinate \(mapView.centerCoordinate)")
        searchCoOrdinate = mapView.centerCoordinate
    }
    
    func openClustringAnnotation(cluster:MKClusterAnnotation) {
        
        var zoomRect = MKMapRect.null
        for annotation in cluster.memberAnnotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
            if zoomRect.isNull {
                zoomRect = pointRect
            } else {
                zoomRect = zoomRect.union(pointRect)
            }
        }
        viewMap.setVisibleMapRect(zoomRect, edgePadding: mapEdgePadding, animated: true)
    }
   
    func openAnnotation(annotationView:MKAnnotationView,annotaion:CustomAnnotation) {
        let views = Bundle.main.loadNibNamed("CustomAnnotationView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomAnnotationView
        selectedAnnotaion = annotaion
        print("tag = \(annotaion.tag ?? 0)")
        calloutView.lblUserName.text = annotaion.name
        calloutView.lblDate.text = annotaion.date
        if annotaion.isVideo == 0 {
            calloutView.imgPost.sd_imageIndicator = SDWebImageActivityIndicator.gray
            calloutView.imgPost.sd_setImage(with: URL(string: URL_POST_PIC+(annotaion.postedImage ?? "")), placeholderImage: UIImage(named: "image_placehoder"), options: .lowPriority, context: nil)
        } else {
            calloutView.imgPost.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let image = annotaion.postedImage?.replacingOccurrences(of: "mp4", with: "png") ?? ""
            calloutView.imgPost.sd_setImage(with: URL(string: URL_POST_PIC+image), placeholderImage: UIImage(named: "image_placehoder"), options: .lowPriority, context: nil)
        }
        calloutView.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        calloutView.imgProfile.sd_setImage(with: URL(string: "\(URL_USER_PROFILE_IMAGES)\(annotaion.profileImage ?? "")"), placeholderImage: UIImage(named: "ic_username"), options: .lowPriority, context: nil)
        calloutView.translatesAutoresizingMaskIntoConstraints = false
        calloutView.btnPostDetailOutlet.addTarget(self, action: #selector(btnPostDetailAction(_:)), for: .touchUpInside)
        calloutView.btnEditOutlet.addTarget(self, action: #selector(btnEditPostAction(_:)), for: .touchUpInside)
        if isComeFromOwn == .own {
            if dictSelectedAnnotation == nil {
                let dict = arrPostList[annotaion.tag!]
                if dict.userToken != appDelegate.objUser?.userToken {
                    calloutView.btnEditOutlet.isHidden = true
                } else {
                    calloutView.btnEditOutlet.isHidden = false
                }
            } else {
                if appDelegate.objUser?.userToken != dictSelectedAnnotation?.userToken {
                    calloutView.btnEditOutlet.isHidden = true
                } else {
                    calloutView.btnEditOutlet.isHidden = false
                }
            }
        }        
        calloutView.btnEditOutlet.tag = annotaion.tag ?? 0
        calloutView.btnPostDetailOutlet.tag = annotaion.tag ?? 0
        annotationView.backgroundColor = .clear
        annotationView.detailCalloutAccessoryView = calloutView
    }
       
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        var callout = view.subviews.filter({ (subview) -> Bool in
            subview is CustomAnnotationView
        }).first

        callout?.removeFromSuperview()
        callout = nil
    }
}

//MARK:- API

extension MyHomeVC {
    
    func apiCallForGetPostList(param:[String:AnyObject])  {
        
        ServiceManager.callAPI(url: URL_GET_POST_LIST, parameter: param, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let arrData  = dictData["data"] as? NSArray {
                        self.arrPostList.removeAll()
                        for dict in arrData {
                            let model = ClsPostListModel(fromDictionary: dict as! NSDictionary)
                            self.arrPostList.append(model)
                        }
                        self.addPinOnMap()
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
    
    func apiCallForGetRecomamndedPostList()  {
        let dict = ["latitude":kCurrentUserLocation.coordinate.latitude as AnyObject,
                    "longitude":kCurrentUserLocation.coordinate.longitude as AnyObject]
        ServiceManager.callAPI(url: URL_GET_RECOMMADED_POST_LIST, parameter: dict, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let arrData  = dictData["data"] as? NSArray {
                        self.arrPostList.removeAll()
                        for dict in arrData {
                            let model = ClsPostListModel(fromDictionary: dict as! NSDictionary)
                            self.arrPostList.append(model)
                        }
                        /*if let isLike = dictData["is_with_like"] as? String {
                            if isLike == "0" {
                                self.isNoLikePost = false
                            } else {
                                self.isNoLikePost = true
                            }
                        }
                        if self.isNoLikePost {
                            self.arrPostList = self.arrPostList.sorted{
                                $0.cntLike < $1.cntLike
                            }
                        }*/
                        self.addPinOnMap()
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
    
    func apiCallForGetAllPostList(param:[String:AnyObject])  {
        
        ServiceManager.callAPI(url: URL_USER_POST_FOR_MAP, parameter: param, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let arrData  = dictData["data"] as? NSArray {
                        self.arrPostList.removeAll()
                        for dict in arrData {
                            let model = ClsPostListModel(fromDictionary: dict as! NSDictionary)
                            self.arrPostList.append(model)
                        }
                        self.addPinOnMap()
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
    
    func apiCallForGetUserSavePostList(param:[String:AnyObject])  {
        
        ServiceManager.callAPI(url: URL_GET_USER_SAVE_POST_LIST, parameter: param, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let arrData  = dictData["data"] as? NSArray {
                        self.arrPostList.removeAll()
                        for dict in arrData {
                            let model = ClsPostListModel(fromDictionary: dict as! NSDictionary)
                            self.arrPostList.append(model)
                        }
                        self.addPinOnMap()
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
    
    func apiCallForGetTagList()  {
        
        ServiceManager.callAPI(url: URL_GET_TAG_LIST, parameter: [:], isShowLoader: false ,success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let arrData  = dictData["data"] as? NSArray {
                        arrDefaultTagList.removeAll()
                        for dict in arrData {
                            let model = ClsTagListModel(fromDictionary: dict as! NSDictionary)
                            arrDefaultTagList.append(model)
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
        }, failure: { (error) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: msg)
        })
    }
    
    func apiCallForGetRecentPostList()  {
        
        ServiceManager.callAPI(url: URL_GET_RECENT_POST_LIST, parameter: [:], success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let arrData  = dictData["data"] as? NSArray {
                        self.arrPostList.removeAll()
                        for dict in arrData {
                            let model = ClsPostListModel(fromDictionary: dict as! NSDictionary)
                            self.arrPostList.append(model)
                        }
                        self.addPinOnMap()
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
    
    func apiCallForGetNearByPostList()  {
      
        let param = ["latitude":Double(searchCoOrdinate.latitude),
                     "longitude":Double(searchCoOrdinate.longitude)] as [String:AnyObject]
        ServiceManager.callAPI(url: URL_GET_SEARCH_POST_LIST, parameter: param, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let arrData  = dictData["data"] as? NSArray {
                        if arrData.count != 0 {
                            self.arrPostList.removeAll()
                        }
                        for dict in arrData {
                            let model = ClsPostListModel(fromDictionary: dict as! NSDictionary)
                            self.arrPostList.append(model)
                        }
                        if arrData.count != 0 {
                            self.addPinOnMap()
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
        }, failure: { (error) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: msg)
        })
    }
    
}

