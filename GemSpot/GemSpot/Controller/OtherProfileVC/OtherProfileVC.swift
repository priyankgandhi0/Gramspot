//
//  OtherProfileVC.swift
//  GemSpot
//
//  Created by Jaydeep on 01/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import SDWebImage

class OtherProfileVC: UIViewController {
    
    //MARK:- Variable Declration
    
    var dictProfile = ClsUserLoginModel()
    var isComeFromOwn = userProfileStatus.own
    var arrPost = [ClsPostListModel]()
    var updateFollowCount:(Int,Int,ClsFollowerListModel) -> Void = {_,_,_ in}
    var isComeFromPush = false
    var userToken = String()
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var tblProfile:UITableView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblFollowers:UILabel!
    @IBOutlet weak var lblFollowing:UILabel!
    @IBOutlet weak var imgProfile:UIImageView!
    @IBOutlet weak var btnFollow:CustomButton!
    
    //MARK:- ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isComeFromPush {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setupNavigationBar()
        
        let btnBack = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(btnBackAction(_:)))
        btnBack.tintColor = .white
        
        let btnBackTitle = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        btnBackTitle.tintColor = .white
        
        self.navigationItem.leftBarButtonItems = [btnBack,btnBackTitle]
        if isComeFromPush {
            let dict:[String:AnyObject] = ["user_token":userToken as AnyObject]
            apiCallForGetUserDetail(param: dict)
           isComeFromPush = false
        } else {
            let dict:[String:AnyObject] = ["user_token":dictProfile.userToken as AnyObject]
            apiCallForGetUserDetail(param: dict)
        }
        
    }
    
    func setupData() {
        self.lblName.text = dictProfile.username
        self.imgProfile.sd_setImage(with: URL(string: "\(URL_USER_PROFILE_IMAGES)\(dictProfile.profileImage ?? "")"), placeholderImage: UIImage(named: "ic_username"), options: .lowPriority, context: nil)
        self.lblFollowers.text = "Followers : \(dictProfile.followers ?? 0)"
        self.lblFollowing.text = "Following : \(dictProfile.following ?? 0)"
        self.arrPost = dictProfile.post
        self.btnFollow.backgroundColor = dictProfile.isFollow == 1 ? APP_THEME_BLACK_COLOR.withAlphaComponent(0.2) : APP_THEME_BLUE_COLOR
        self.btnFollow.isSelected = dictProfile.isFollow == 1 ? true : false
        self.btnFollow.tintColor = .clear
        self.tblProfile.reloadData()
        if dictProfile.userToken == appDelegate.objUser?.userToken {
            btnFollow.isHidden = true
        } else {
            btnFollow.isHidden = false
        }
    }
    
    //MARK:- Action Zone
    
    @IBAction func btnFollowAction(_ sender:UIButton) {
        var param:[String:AnyObject] = [:]
        param["is_follow"] = dictProfile.isFollow == 0 ? "1" as AnyObject : "0" as AnyObject
        param["opposite_user_token"] = dictProfile.userToken as AnyObject
        apiCallForUpdateFollowerList(param: param)
    }
    
    
    @IBAction func btnFollowerAction(_ sender:UIButton) {
        let obj = profileStoryboard.instantiateViewController(withIdentifier: "FollowerParentVC") as! FollowerParentVC
        obj.dictUserDetail = self.dictProfile
        obj.selectedParentStatus = sender.tag == 0 ? .followers : .following
        obj.selectedUserStatus = .other
        obj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(obj, animated: true)        
    }
    
    @IBAction func btnViewAllAction(_ sender:UIButton) {
        let obj = profileStoryboard.instantiateViewController(withIdentifier: "PostListVC") as! PostListVC
        obj.dictProfile = dictProfile
        obj.postStatus = sender.tag == 0 ? .post : .saved
        obj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(obj, animated: true)
    }

}

//MARK:- TableView Delegate

extension OtherProfileVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableCell") as! ProfileTableCell
        cell.currentIndex = indexPath.row
        let dict = arrPost[indexPath.row]
        cell.lblTitle.text = dict.title
        cell.arrPost = dict.post
        cell.handlerSelection = {[weak self] model in
             let obj = homeStoryboard.instantiateViewController(withIdentifier: "PostDetailVC") as! PostDetailVC
//            obj.dictPostDetail = model
            obj.strPostToken = model.postToken
            obj.isComeFromPush = true
            obj.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(obj, animated: true)
        }
        cell.btnViewAll.addTarget(self, action: #selector(btnViewAllAction(_:)), for: .touchUpInside)
        cell.btnViewAll.tag = indexPath.row
        return cell
    }
}

//MARK:- API

extension OtherProfileVC {
    
    func apiCallForGetUserDetail(param:[String:AnyObject])  {
        ServiceManager.callAPI(url: URL_USER_PROFILE, parameter: param, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let dict  = dictData["data"] as? NSDictionary {
                        self.dictProfile = ClsUserLoginModel(fromDictionary: dict)
                        self.setupData()
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
    
    func apiCallForUpdateFollowerList(param:[String:AnyObject],isShowLoader:Bool = false)  {
            ServiceManager.callAPI(url: URL_USER_FOLLOWER, parameter: param, isShowLoader: isShowLoader,success: { (response) in
                print("Response \(response)")
                if let dictData = response as? NSDictionary {
                    if let status = dictData["status"] as? Int, status == 1 {
                        
                        let followStatus = param["is_follow"] as! String
                        self.btnFollow.backgroundColor = followStatus == "1" ? APP_THEME_BLACK_COLOR.withAlphaComponent(0.2) : APP_THEME_BLUE_COLOR
                        self.btnFollow.isSelected = followStatus == "1" ? true : false
                        
                        if followStatus == "1" {
                            self.dictProfile.isFollow = 1
                        } else {
                            self.dictProfile.isFollow = 0
                        }
                        
    //                    self.upperRefreshTable()
                        let dictFollowData = dictData["data"] as? NSDictionary
                        if let totalFollowerCount = dictFollowData?["followers"] as? Int, let totalFollowingCount = dictFollowData?["following"] as? Int {
                            let model = ClsFollowerListModel(fromDictionary: self.dictProfile.toDictionary())
                            self.updateFollowCount(totalFollowerCount,totalFollowingCount, model)
                        }
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
}
