//
//  ShowCommentVC.swift
//  GemSpot
//
//  Created by Jaydeep on 04/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UIScrollView_InfiniteScroll
import SDWebImage

class ShowCommentVC: UIViewController {
    
    //MARK:- Variable Declaration
    
    var page = 1
    var limit = 50
    var dictPostDetail = ClsPostListModel()
    var arrCommentList = [ClsCommentModel]()
    var isEditCommentMode = false
    var dictEditComment = ClsCommentModel()
    var handlerAddComment:([ClsCommentModel]) -> Void = {_ in}
    let upperRefresh = UIRefreshControl()
    
    //MARK:- Outlet Zone
    @IBOutlet weak var tblComment: UITableView!
    @IBOutlet weak var txtViewComment: UITextView!
    @IBOutlet weak var lblPlaceholder: UILabel!
    @IBOutlet weak var btnSendOutlet: UIButton!
    @IBOutlet weak var bottomOfMsgView: NSLayoutConstraint!
    @IBOutlet weak var txtVwHeightConstraint: NSLayoutConstraint!
    
    //MARK:- ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textViewDidChange(txtViewComment)
        reloadCommentList()
        self.tblComment.tableFooterView = UIView()
        upperRefresh.addTarget(self, action: #selector(self.upperRefreshTable), for: .valueChanged)
        tblComment.addSubview(upperRefresh)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enable = false
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupNavigationBar()
        
        let btnBack = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(btnBackAction(_:)))
        btnBack.tintColor = .white
        
        let btnBackTitle = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        btnBackTitle.tintColor = .white
        
        self.navigationItem.leftBarButtonItems = [btnBack,btnBackTitle]
    }
    
    override func viewWillDisappear(_ animated: Bool)  {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func reloadCommentList(isShowLoader:Bool = true) {
        var param:[String:AnyObject] = [:]
        param["page"] = page as AnyObject
        param["limit"] = limit as AnyObject
        param["post_token"] = dictPostDetail.postToken as AnyObject
        apiCallForGetPostCommentList(param: param,isShowLoader:isShowLoader)
        
        tblComment.addInfiniteScroll(handler: { (tblview) in
            self.reloadCommentList(isShowLoader:false)
        })
    }
    
    @objc func upperRefreshTable() {
        page = 1
        reloadCommentList(isShowLoader: false)
    }

}

 //MARK: - keyboard show/hide method
extension ShowCommentVC {
   
    @objc func keyboardWillShow(_ notification: NSNotification) {
        // Do something here
        if let keyboardRectValue = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        {
            let keyboardHeight = keyboardRectValue.height
            print("keyBorad Height : \(keyboardHeight) ")
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomOfMsgView.constant = keyboardHeight
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification){
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomOfMsgView.constant = 0.0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
}

//MARK: - UITextview Methods
extension ShowCommentVC : UITextViewDelegate
{
    func textView(_ textView: UITextView, shouldChangeTextIn shouldChangeTextInRange: NSRange, replacementText text: String) -> Bool {
       
        if text == "\n"  // Recognizes enter key in keyboard
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    private func textViewShouldReturn(_ textView: UITextView!) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        self.lblPlaceholder.isHidden = textView.text == "" ? false : true
        var txtHeight = txtVwHeightConstraint.constant
        let fixedWidth = textView.frame.size.width
        
        let newSize = textView.sizeThatFits(CGSize.init(width: fixedWidth, height: CGFloat(MAXFLOAT)))
        var newFrame = textView.frame
        
        newFrame.size = CGSize.init(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))), height: newSize.height)
        
        if (newSize.height <= 81) {
            textView.isScrollEnabled = false
            txtVwHeightConstraint.constant = newSize.height
            txtHeight = newSize.height
        }
        else {
           textView.isScrollEnabled = true
            txtVwHeightConstraint.constant = txtHeight
        }
        
        if(textView.text.count == 0)   {
            self.btnSendOutlet.isUserInteractionEnabled = false
            self.btnSendOutlet.alpha = 0.5
        }
        else{
            self.btnSendOutlet.isUserInteractionEnabled = true
            self.btnSendOutlet.alpha = 1
        }
    }
}

//MARK:- Action

extension ShowCommentVC {
    
    @IBAction func btnSendCommentAction(_ sender : UIButton) {
        if self.txtViewComment.text.trimString().isEmpty {
            makeToast(strMessage: "Please enter comment")
            return
        }
        var param:[String:AnyObject] = [:]
        if isEditCommentMode {
            param["comment_token"] = self.dictEditComment.commentToken as AnyObject?
            param["post_token"] = self.dictPostDetail.postToken as AnyObject?
            param["comment_text"] = self.txtViewComment.text as AnyObject
            apiCallForEditComment(param: param)
        } else {
            param["post_token"] = self.dictPostDetail.postToken as AnyObject?
            param["comment_text"] = self.txtViewComment.text as AnyObject
            apiCallForAddComment(param: param)
        }
    }
    
    @IBAction func btnLikeUnlikeCommentAction(_ sender : UIButton) {
        let dictComment = self.arrCommentList[sender.tag]
        var param:[String:AnyObject] = [:]
        param["like_status"] = dictComment.likeStatus == 0 ? 1 as AnyObject : 0 as AnyObject
        param["comment_token"] = dictComment.commentToken as AnyObject?
        param["post_token"] = dictComment.postToken as AnyObject?
        apiCallForUpdateCommentLikeStatus(param: param, tag: sender.tag)
    }
}

//MARK:- TableView Delegate

extension ShowCommentVC:UITableViewDelegate,UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let dict = self.arrCommentList[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            // Perform your action here
            displayAlertWithTitle(APP_NAME, andMessage: "Are you sure want to delete this comment?", buttons: ["Yes","No"], completion: { (tag) in
                if tag == 0 {
                    var param:[String:AnyObject] = [:]
                    param["comment_token"] = dict.commentToken as AnyObject?
                    self.apiCallForDeleteComment(param: param)
                }
            })
            completion(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            self.dictEditComment = dict
            self.isEditCommentMode = true
            self.txtViewComment.text = dict.commentText
            self.textViewDidChange(self.txtViewComment)
            self.txtViewComment.becomeFirstResponder()
            completion(true)
        }
        
        deleteAction.image = UIImage(named: "icon.png")
        deleteAction.backgroundColor = UIColor.red
        if dict.userToken == appDelegate.objUser?.userToken {
            return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        }
        return nil
    }
}

//MARK:- API

extension ShowCommentVC {

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
                    self.handlerAddComment(self.arrCommentList)
                }  else {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                }
            }else{
                makeToast(strMessage: DEFAULT_ERROR)
            }
            self.tblComment.reloadData()
        }, failure: { (error) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: msg)
        })
    }

    func apiCallForGetPostCommentList(param:[String:AnyObject],isShowLoader:Bool)  {
        ServiceManager.callAPI(url: URL_GET_ALL_COMMENT, parameter: param,isShowLoader: isShowLoader, success: { (response) in
            self.upperRefresh.endRefreshing()
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let arrData  = dictData["data"] as? NSArray {
                        if arrData.count == 0 {
                            if self.page == 1 {
                                self.arrCommentList.removeAll()
                            }
                            self.tblComment.finishInfiniteScroll()
                            self.tblComment.reloadData()
                            return
                        }
                        if self.page <= 1 {
                            self.arrCommentList.removeAll()
                        }
                        self.page += 1
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
                self.tblComment.reloadData()
            }else{
                makeToast(strMessage: DEFAULT_ERROR)
            }
        }, failure: { (error) in
            self.upperRefresh.endRefreshing()
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            self.upperRefresh.endRefreshing()
            HIDE_CUSTOM_LOADER()
            makeToast(strMessage: msg)
        })
    }
    
    func apiCallForAddComment(param:[String:AnyObject])  {
        
        ServiceManager.callAPI(url: URL_ADD_COMMENT, parameter: param,success: { (response) in
            print("Response \(response)")
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let dict = dictData["data"] as? NSDictionary {
                        self.view.endEditing(true)
                        let dictCommet = ClsCommentModel(fromDictionary: dict)
                        self.arrCommentList.append(dictCommet)
                        self.txtViewComment.text = ""
                        self.textViewDidChange(self.txtViewComment)
                        if self.arrCommentList.count <= 5 {
                            self.handlerAddComment(self.arrCommentList)
                        }
                    }
                } else {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                }
                self.tblComment.reloadData()
            }else{
                makeToast(strMessage: DEFAULT_ERROR)
            }
        }, failure: { (error) in
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            makeToast(strMessage: msg)
        })
    }
    
    func apiCallForDeleteComment(param:[String:AnyObject])  {
        ServiceManager.callAPI(url: URL_DELETE_COMMENT, parameter: param,success: { (response) in
            print("Response \(response)")
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    let token = param["comment_token"] as! String
                    if let index = self.arrCommentList.firstIndex(where: {$0.commentToken == "\(token)"}) {
                        print("index \(index)")
                        self.arrCommentList.remove(at: index)
                    }
                    self.handlerAddComment(self.arrCommentList)
                } else {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                }
                self.tblComment.reloadData()
            }else{
                makeToast(strMessage: DEFAULT_ERROR)
            }
        }, failure: { (error) in
            makeToast(strMessage: error)
        }, connectionFailed: {(msg) in
            makeToast(strMessage: msg)
        })
    }
    
    func apiCallForEditComment(param:[String:AnyObject])  {
        ServiceManager.callAPI(url: URL_EDIT_COMMENT, parameter: param,success: { (response) in
            print("Response \(response)")
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let dict = dictData["data"] as? NSDictionary {
                        let token = param["comment_token"] as! String
                        if let index = self.arrCommentList.firstIndex(where: {$0.commentToken == "\(token)"}) {
                            self.view.endEditing(true)
                            let dictComment = ClsCommentModel(fromDictionary: dict)
                            self.arrCommentList[index] = dictComment
                            self.txtViewComment.text = ""
                            self.textViewDidChange(self.txtViewComment)
                            self.isEditCommentMode = false
                            self.dictEditComment = ClsCommentModel()
                        }
                    }
                    self.handlerAddComment(self.arrCommentList)
                } else {
                    if let msg = dictData["msg"] as? String {
                        makeToast(strMessage: msg)
                    }
                }
                self.tblComment.reloadData()
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
