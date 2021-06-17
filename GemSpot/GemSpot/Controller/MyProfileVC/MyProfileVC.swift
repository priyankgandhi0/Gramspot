//
//  MytProfileVC.swift
//  GemSpot
//
//  Created by Jaydeep on 01/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import SDWebImage

class MyProfileVC: UIViewController {
    
    //MARK:- Variable Declration
    
    var dictProfile = ClsUserLoginModel()
    var isComeFromOwn = userProfileStatus.own
    var arrPost = [ClsPostListModel]()
    let picker = UIImagePickerController()
    var image: UIImage?
    
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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let dict:[String:AnyObject] = ["user_token":appDelegate.objUser?.userToken as AnyObject]
        apiCallForGetUserDetail(param: dict)
        
        btnFollow.isHidden = true
        setNavigationTitle("Profile")
        
        let btnRight = UIBarButtonItem(image: UIImage(named: "ic_setting"), style: .plain, target: self, action: #selector(btnSettingAction(_:)))
        btnRight.tintColor = .white
        self.navigationItem.rightBarButtonItem = btnRight
        
        rigthProfileDD.dataSource = ["Edit Profile","Notification Setting","Privacy Setting","Logout"]
        configureDropdown(dropdown: rigthProfileDD, sender: btnRight)
        
        
    }
    
    func setupData() {
        self.lblName.text = dictProfile.username
        self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgProfile.sd_setImage(with: URL(string: "\(URL_USER_PROFILE_IMAGES)\(dictProfile.profileImage ?? "")"), placeholderImage: UIImage(named: "ic_username"), options: .lowPriority, context: nil)
        self.lblFollowers.text = "Followers : \(dictProfile.followers ?? 0)"
        self.lblFollowing.text = "Following : \(dictProfile.following ?? 0)"
        self.arrPost = dictProfile.post
        self.tblProfile.reloadData()
    }
    
    //MARK:- Action Zone
    
    @IBAction func btnSettingAction(_ sender:UIBarButtonItem) {
        rigthProfileDD.show()
        rigthProfileDD.selectionAction = {[weak self] index,item in
            if index == 0 {
                let obj = profileStoryboard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
                obj.hidesBottomBarWhenPushed = true
                obj.dictUserDetail = self!.dictProfile
                obj.handleUpdateDetail = {[weak self] model in
                     /*let dict:[String:AnyObject] = ["user_token":appDelegate.objUser?.userToken as AnyObject]
                    self?.apiCallForGetUserDetail(param: dict)*/
                }
                self?.navigationController?.pushViewController(obj, animated: true)
            } else if index == 1 {
                let obj = notificationStoryboard.instantiateViewController(withIdentifier: "NotificationSettingVC") as! NotificationSettingVC
                obj.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(obj, animated: true)
            } else if index == 2 {
                let obj = notificationStoryboard.instantiateViewController(withIdentifier: "PrivacySettingVC") as! PrivacySettingVC
                obj.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(obj, animated: true)
            } else if index == 3 {
                displayAlertWithTitle(APP_NAME, andMessage: "Are you sure want to logout from the app?", buttons: ["Yes","No"]) { (tag) in
                    if tag == 0 {
                        apiCallingFromLogout()
                    }
                }
                
            }
        }
    }
    
    @IBAction func btnFollowerAction(_ sender:UIButton) {
        let obj = profileStoryboard.instantiateViewController(withIdentifier: "FollowerParentVC") as! FollowerParentVC
        obj.dictUserDetail = self.dictProfile
        obj.selectedUserStatus = .own
        obj.selectedParentStatus = sender.tag == 0 ? .followers : .following
        obj.updateFollowCount = { [weak self] follower,following in
            /*self?.dictProfile.followers = follower
            self?.dictProfile.following = following
            self?.setupData()*/
        }
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
    
    @IBAction func btnChangeProfilePicture(_ sender:UIButton) {
        alertActionForGallary()
    }

}

//MARK:- TableView Delegate

extension MyProfileVC : UITableViewDelegate,UITableViewDataSource {
    
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
            obj.strPostToken = model.postToken
            obj.dictPostDetail = model
            obj.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(obj, animated: true)
        }
        cell.profileCollection.reloadData()
        cell.btnViewAll.addTarget(self, action: #selector(btnViewAllAction(_:)), for: .touchUpInside)
        cell.btnViewAll.tag = indexPath.row
        return cell
    }
}

//MARK: - UIImagePickerController

extension MyProfileVC:UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    func alertActionForGallary()  {
        
        // Create the alert controller
        let alertController = UIAlertController(title: APP_NAME, message: "Please choose any one", preferredStyle: .actionSheet)
        
        // Create the actions
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default) {
            UIAlertAction in
        
            self.picker.delegate = self
            self.picker.sourceType = .photoLibrary
            self.picker.allowsEditing = true
//            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.picker.allowsEditing = true
            self.picker.mediaTypes = ["public.image"]
            self.picker.modalPresentationStyle = .fullScreen
            self.present(self.picker, animated: true, completion: nil)
            
        }
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.delegate = self
                self.picker.sourceType = UIImagePickerController.SourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.allowsEditing = true
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
            } else {
//                makeToast(message: "Sorry, this device has not camera.")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(gallaryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgProfile.image = chosenImage
            image = chosenImage
        } else if let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imgProfile.image = chosenImage
            image = chosenImage
        }
        chnageProfileAPICalling(param: [:])
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


//MARK:- API

extension MyProfileVC {
    
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
    
    func chnageProfileAPICalling(param:[String:AnyObject]) {
        ServiceManager.makeReqeusrWithMultipartData(with: URL_CHANGE_USER_PROFILE, method: .post, parameter: param, image: image,image_name: "profile_image",success: { (response) in
            print("Response \(response)")
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let dict  = dictData["data"] as? NSDictionary {
                        let model = ClsUserLoginModel(fromDictionary: dict)
                        appDelegate.objUser = model
                        setCustomObject(value: appDelegate.objUser!, key: USER_LOGIN_INFO)
                        self.dictProfile.profileImage = model.profileImage
                        self.imgProfile.sd_setImage(with: URL(string: "\(URL_USER_PROFILE_IMAGES)\(model.profileImage ?? "")"), placeholderImage: UIImage(named: "ic_username"), options: .lowPriority, context: nil)
                        self.navigationController?.popViewController(animated: true)
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
