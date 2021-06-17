//
//  FollowerChildVC.swift
//  GemSpot
//
//  Created by Jaydeep on 02/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll
import SDWebImage

class FollowerChildVC: UIViewController {
    
    //MARK:- Variable Declaration
    
    var arrFollowerList = [ClsFollowerListModel]()
    var selectedParentStatus = followStatus.followers
    var page = 1
    var limit = 50
    let upperRefresh = UIRefreshControl()
    var dictUserDetail = ClsUserLoginModel()
    var updateFollowCount:(Int,Int,ClsFollowerListModel) -> Void = {_,_,_ in}
    var totalFollowerCount:Int = 0
    var totalFollowingCount:Int = 0
    var selectedUserStatus = userProfileStatus.own
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var tblFollowerList:UITableView!
    
    
    //MARK:- ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblFollowerList.tableFooterView = UIView()
        upperRefresh.addTarget(self, action: #selector(self.upperRefreshTable), for: .valueChanged)
        tblFollowerList.addSubview(upperRefresh)
        
        reloadFollowerList(isShowLoader: true)
        // Do any additional setup after loading the view.
    }
    
    func reloadFollowerList(searchText:String = "",isShowLoader:Bool = true) {
        var param:[String:AnyObject] = [:]
        param["page"] = page as AnyObject
        param["limit"] = limit as AnyObject
        param["search"] = searchText as AnyObject
        param["is_following"] = selectedParentStatus.rawValue as AnyObject
        param["user_token"] = dictUserDetail.userToken as AnyObject
        param["is_own_profile"] = selectedUserStatus == .own ? "" as AnyObject: "1" as AnyObject
        apiCallForGetFollowerList(param: param,isShowLoader:isShowLoader)
        
        tblFollowerList.addInfiniteScroll(handler: { (tblview) in
            self.reloadFollowerList(searchText: "",isShowLoader:false)
        })
    }
    
    @objc func upperRefreshTable() {
        page = 1
        let searchText = ""
        var param:[String:AnyObject] = [:]
        param["page"] = page as AnyObject
        param["limit"] = limit as AnyObject
        param["search"] = searchText as AnyObject
        param["is_following"] = selectedParentStatus.rawValue as AnyObject
        param["user_token"] = dictUserDetail.userToken as AnyObject
        param["is_own_profile"] = selectedUserStatus == .own ? "" as AnyObject: "1" as AnyObject
        apiCallForGetFollowerList(param: param,isShowLoader:false)
        
        tblFollowerList.addInfiniteScroll(handler: { (tblview) in
            self.reloadFollowerList(searchText: "",isShowLoader:false)
        })
    }
    
    @objc func btnFollowAction(_ sender:UIButton) {
        let dict = arrFollowerList[sender.tag]
        var param:[String:AnyObject] = [:]
        param["is_follow"] = dict.isFollow == 0 ? "1" as AnyObject : "0" as AnyObject
        param["opposite_user_token"] = dict.userToken as AnyObject
        apiCallForUpdateFollowerList(param: param, tag: sender.tag)
    }
    
    
}

//MARK:- TableView Delegate

extension FollowerChildVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrFollowerList.count == 0 {
            let lbl = UILabel()
            lbl.text = selectedParentStatus == .followers ? "No followers found" : "No following found"
            lbl.textAlignment = NSTextAlignment.center
            lbl.textColor = UIColor.black
            lbl.font = themeFont(size: 14, fontname: .regular)
            lbl.center = tableView.center
            tableView.backgroundView = lbl
            return 0
        }
        tableView.backgroundView = nil
        return arrFollowerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowerCell") as! FollowerCell
        let dict = arrFollowerList[indexPath.row]
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgProfile.sd_setImage(with: URL(string: URL_USER_PROFILE_IMAGES+dict.profileImage), placeholderImage: UIImage(named: "user_placeholder"), options: .lowPriority, context: nil)
        cell.lblUserName.text = "\(dict.firstName ?? "") \(dict.lastName ?? "")"
        
        cell.btnFollowOutlet.tag = indexPath.row
        cell.btnFollowOutlet.backgroundColor = dict.isFollow == 1 ? APP_THEME_BLACK_COLOR.withAlphaComponent(0.2) : APP_THEME_BLUE_COLOR
        cell.btnFollowOutlet.isSelected = dict.isFollow == 1 ? false : true
        cell.btnFollowOutlet.tintColor = .clear
        cell.btnFollowOutlet.addTarget(self, action: #selector(btnFollowAction(_:)), for: .touchUpInside)
        if dict.userToken == appDelegate.objUser?.userToken {
            cell.btnFollowOutlet.isHidden = true
        } else {
             cell.btnFollowOutlet.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = arrFollowerList[indexPath.row]
        let obj = profileStoryboard.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC
        obj.isComeFromOwn = selectedUserStatus
        obj.dictProfile = ClsUserLoginModel(fromDictionary: dict.toDictionary())
        obj.updateFollowCount = {[weak self] follower,follwing,model in
            self?.updateFollowCount(follower,follwing,model)
        }
        self.navigationController?.pushViewController(obj, animated: true)
    }
}

//MARK:- API

extension FollowerChildVC
{
    func apiCallForGetFollowerList(param:[String:AnyObject],isShowLoader:Bool = true)  {
        ServiceManager.callAPI(url: URL_GET_FOLLOWER_LIST, parameter: param, isShowLoader: isShowLoader,success: { (response) in
            print("Response \(response)")
            self.upperRefresh.endRefreshing()
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let arr = dictData["data"] as? NSArray {
                        if arr.count == 0 {
                            if self.page == 1 {
                                self.arrFollowerList.removeAll()
                            }
                            self.tblFollowerList.finishInfiniteScroll()
                            self.tblFollowerList.reloadData()
                            return
                        }
                        if self.page <= 1 {
                            self.arrFollowerList.removeAll()
                        }
                        self.page += 1
                        for dict in arr {
                            let model = ClsFollowerListModel(fromDictionary: dict as! NSDictionary)
                            self.arrFollowerList.append(model)
                        }
                    }else{
                        makeToast(strMessage: DEFAULT_ERROR)
                    }
                } else {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                    self.arrFollowerList.removeAll()
                }
                self.tblFollowerList.reloadData()
            }else{
                makeToast(strMessage: DEFAULT_ERROR)
            }
        }, failure: { (error) in
            self.tblFollowerList.finishInfiniteScroll()
            self.upperRefresh.endRefreshing()
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            self.tblFollowerList.finishInfiniteScroll()
            self.upperRefresh.endRefreshing()
            makeToast(strMessage: msg)
        })
    }
    
    func apiCallForUpdateFollowerList(param:[String:AnyObject],isShowLoader:Bool = false,tag:Int)  {
        ServiceManager.callAPI(url: URL_USER_FOLLOWER, parameter: param, isShowLoader: isShowLoader,success: { (response) in
            print("Response \(response)")
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    let followStatus = param["is_follow"] as! String
                    let dict = self.arrFollowerList[tag]
                    if followStatus == "1" {
                        dict.isFollow = 1
                    } else {
                        dict.isFollow = 0
                    }
                    self.arrFollowerList[tag] = dict
                    self.tblFollowerList.reloadData()
//                    self.upperRefreshTable()
                    let dictFollowData = dictData["data"] as? NSDictionary
                    if let totalFollowerCount = dictFollowData?["followers"] as? Int, let totalFollowingCount = dictFollowData?["following"] as? Int {
                        self.updateFollowCount(totalFollowerCount,totalFollowingCount, dict)
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
