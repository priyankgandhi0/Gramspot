//
//  SearchUserVC.swift
//  GemSpot
//
//  Created by Jaydeep on 23/06/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll
import SDWebImage

class SearchUserVC: UIViewController {
    
    //MARK:- Variable Declaration
    
    var arrUserList = [ClsFollowerListModel]()
    var page = 1
    var limit = 50
    let upperRefresh = UIRefreshControl()
    var selectedUserStatus = userProfileStatus.own
    var updateFollowCount:(Int,Int,ClsFollowerListModel) -> Void = {_,_,_ in}
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var txtSearch:UITextField!
    @IBOutlet weak var tblUserSearch:UITableView!
    
    //MARK:- ViewLife Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblUserSearch.tableFooterView = UIView()
        upperRefresh.addTarget(self, action: #selector(self.upperRefreshTable), for: .valueChanged)
        tblUserSearch.addSubview(upperRefresh)
        
        reloadUserList(isShowLoader: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let btnBack = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(btnBackAction(_:)))
        btnBack.tintColor = .white
        
        let btnBackTitle = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        btnBackTitle.tintColor = .white
        
        self.navigationItem.leftBarButtonItems = [btnBack,btnBackTitle]
    }
    
    func reloadUserList(searchText:String = "",isShowLoader:Bool = true) {
        var param:[String:AnyObject] = [:]
        param["page"] = page as AnyObject
        param["limit"] = limit as AnyObject
        param["search"] = searchText as AnyObject
        param["user_token"] = appDelegate.objUser?.userToken as AnyObject
        apiCallForGetUserList(param: param,isShowLoader:isShowLoader)
        
        tblUserSearch.addInfiniteScroll(handler: { (tblview) in
            self.reloadUserList(searchText: "",isShowLoader:false)
        })
    }
    
    @objc func upperRefreshTable() {
        page = 1
        let searchText = ""
        var param:[String:AnyObject] = [:]
        param["page"] = page as AnyObject
        param["limit"] = limit as AnyObject
        param["search"] = searchText as AnyObject
        param["user_token"] = appDelegate.objUser?.userToken as AnyObject
        apiCallForGetUserList(param: param,isShowLoader:false)
        
        tblUserSearch.addInfiniteScroll(handler: { (tblview) in
            self.reloadUserList(searchText: "",isShowLoader:false)
        })
    }
    
    @objc func btnFollowAction(_ sender:UIButton) {
        let dict = arrUserList[sender.tag]
        var param:[String:AnyObject] = [:]
        param["is_follow"] = dict.isFollow == 0 ? "1" as AnyObject : "0" as AnyObject
        param["opposite_user_token"] = dict.userToken as AnyObject
        apiCallForUpdateFollowerList(param: param, tag: sender.tag)
    }
   

}

//MARK:- TextField Delagate

extension SearchUserVC:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        page = 1
        reloadUserList(searchText: (textField.text?.trimString())!, isShowLoader: true)
        return textField.resignFirstResponder()
    }
}

//MARK:- TableView Delegate

extension SearchUserVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrUserList.count == 0 {
            let lbl = UILabel()
            lbl.text = "No users found"
            lbl.textAlignment = NSTextAlignment.center
            lbl.textColor = UIColor.black
            lbl.font = themeFont(size: 14, fontname: .regular)
            lbl.center = tableView.center
            tableView.backgroundView = lbl
            return 0
        }
        tableView.backgroundView = nil
        return arrUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowerCell") as! FollowerCell
        let dict = arrUserList[indexPath.row]
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgProfile.sd_setImage(with: URL(string: URL_USER_PROFILE_IMAGES+dict.profileImage), placeholderImage: UIImage(named: "user_placeholder"), options: .lowPriority, context: nil)
        cell.lblUserName.text = "\(dict.firstName ?? "") \(dict.lastName ?? "")"
        
        cell.btnFollowOutlet.tag = indexPath.row
        cell.btnFollowOutlet.backgroundColor = dict.isFollow == 1 ? APP_THEME_BLACK_COLOR.withAlphaComponent(0.2) : APP_THEME_BLUE_COLOR
        cell.btnFollowOutlet.isSelected = dict.isFollow == 1 ? false : true
        cell.btnFollowOutlet.tintColor = .clear
        cell.btnFollowOutlet.addTarget(self, action: #selector(btnFollowAction(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = arrUserList[indexPath.row]
        let obj = profileStoryboard.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC
        obj.dictProfile = ClsUserLoginModel(fromDictionary: model.toDictionary())
        obj.updateFollowCount = {[weak self] followers,following,dict in
            self?.updateFollowCount(followers,following,dict)
        }
        self.navigationController?.pushViewController(obj, animated: true)
    }
}

//MARK:- API

extension SearchUserVC
{
    func apiCallForGetUserList(param:[String:AnyObject],isShowLoader:Bool = true)  {
        ServiceManager.callAPI(url: URL_ALL_USER, parameter: param, isShowLoader: isShowLoader,success: { (response) in
            print("Response \(response)")
            self.upperRefresh.endRefreshing()
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let arr = dictData["data"] as? NSArray {
                        if arr.count == 0 {
                            self.tblUserSearch.finishInfiniteScroll()
                            self.tblUserSearch.reloadData()
                            return
                        }
                        if self.page <= 1 {
                            self.arrUserList.removeAll()
                        }
                        self.page += 1
                        for dict in arr {
                            let model = ClsFollowerListModel(fromDictionary: dict as! NSDictionary)
                            self.arrUserList.append(model)
                        }
                    }else{
                        makeToast(strMessage: DEFAULT_ERROR)
                    }
                } else {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                    self.arrUserList.removeAll()
                }
                self.tblUserSearch.reloadData()
            }else{
                makeToast(strMessage: DEFAULT_ERROR)
            }
        }, failure: { (error) in
            self.upperRefresh.endRefreshing()
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
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
                    let dict = self.arrUserList[tag]
                    if followStatus == "1" {
                        dict.isFollow = 1
                    } else {
                        dict.isFollow = 0
                    }
                    self.arrUserList[tag] = dict
                    let dictFollowData = dictData["data"] as? NSDictionary
                    if let totalFollowerCount = dictFollowData?["followers"] as? Int, let totalFollowingCount = dictFollowData?["following"] as? Int {
                        self.updateFollowCount(totalFollowerCount,totalFollowingCount, dict)
                    }
                } else {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                }
                self.tblUserSearch.reloadData()
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

