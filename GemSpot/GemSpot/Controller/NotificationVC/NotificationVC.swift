//
//  NotificationVC.swift
//  GemSpot
//
//  Created by Jaydeep on 01/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll
import SDWebImage

class NotificationVC: UIViewController {
    
    //MARK:- Variable Declaration
    
    var page = 1
    var limit = 50
    var arrNotificationList = [ClsNotificationModel]()
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var tblNotificationList:UITableView!
    
    
    //MARK:- ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadPostList()
        self.tblNotificationList.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationTitle("Notifications")
    }
    
    func reloadPostList(isShowLoader:Bool = true) {
        var param:[String:AnyObject] = [:]
        param["page"] = page as AnyObject
        param["limit"] = limit as AnyObject
        apiCallForGetUserPost(param: param,isShowloader:isShowLoader)
        
        tblNotificationList.addInfiniteScroll(handler: { (tblview) in
            self.reloadPostList(isShowLoader:false)
        })
    }
    
    
}

//MARK:- TableView Delegate

extension NotificationVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrNotificationList.count == 0 {
            let lbl = UILabel()
            lbl.text = "No post available"
            lbl.textAlignment = NSTextAlignment.center
            lbl.textColor = UIColor.black
            lbl.font = themeFont(size: 14, fontname: .regular)
            lbl.center = tableView.center
            tableView.backgroundView = lbl
            return 0
        }
        tableView.backgroundView = nil
        return arrNotificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        let dict = arrNotificationList[indexPath.row]
        cell.lblUsername.text = dict.username
        cell.lblSubtitle.text = dict.notificationText
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgProfile.sd_setImage(with: URL(string: "\(URL_USER_PROFILE_IMAGES)\(dict.profileImage ?? "")"), placeholderImage: UIImage(named: "ic_username"), options: .lowPriority, context: nil)
       
        var df = DateFormatter()
        df.dateFormat = dateFormatter.dateFormate3.rawValue
        df.timeZone = TimeZone(abbreviation: "UTC")
        
        let now = df.date(from: dict.createAt) ?? Date()

        df = DateFormatter()
        df.dateStyle = .medium
        df.doesRelativeDateFormatting = true
        df.timeZone = .current
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = dateFormatter.dateFormate4.rawValue

        let time = "\(df.string(from: now)) | \(timeFormatter.string(from: now))"
        cell.lblDate.text = time
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = arrNotificationList[indexPath.row]
        let obj = homeStoryboard.instantiateViewController(withIdentifier: "PostDetailVC") as! PostDetailVC
        obj.dictPostDetail = ClsPostListModel(fromDictionary: model.toDictionary())
        obj.strPostToken = model.postToken
        obj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    
}

//MARK:- API

extension NotificationVC {
    
    func apiCallForGetUserPost(param:[String:AnyObject],isShowloader:Bool)  {
        ServiceManager.callAPI(url: URL_GET_NOTIFICATION, parameter: param,isShowLoader: isShowloader, success: { (response) in
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let arrData  = dictData["data"] as? NSArray {
                        if arrData.count == 0 {
                            self.tblNotificationList.finishInfiniteScroll()
                            self.tblNotificationList.reloadData()
                            return
                        }
                        if self.page <= 1 {
                            self.arrNotificationList.removeAll()
                        }
                        self.page += 1
                        for dict in arrData {
                            let model = ClsNotificationModel(fromDictionary: dict as! NSDictionary)
                            self.arrNotificationList.append(model)
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
            self.tblNotificationList.reloadData()
        }, failure: { (error) in
            self.tblNotificationList.finishInfiniteScroll()
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            self.tblNotificationList.finishInfiniteScroll()
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: msg)
        })
    }
}

