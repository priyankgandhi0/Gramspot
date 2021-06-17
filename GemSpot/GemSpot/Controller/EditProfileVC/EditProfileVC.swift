//
//  EditProfileVC.swift
//  GemSpot
//
//  Created by Jaydeep on 02/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import CountryPickerView
import SDWebImage

class EditProfileVC: UIViewController {
    
    //MARK:- Variable Declaration
      
    let cpvInternal = CountryPickerView()
    let picker = UIImagePickerController()
    var image: UIImage?
    var dictUserDetail = ClsUserLoginModel()
    var handleUpdateDetail:(ClsUserLoginModel) -> Void = {_ in}
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var txtUsername:UITextField!
    @IBOutlet weak var txtCoutryCode:UITextField!
    @IBOutlet weak var txtPhonenumber:UITextField!
    @IBOutlet weak var txtFirstName:UITextField!
    @IBOutlet weak var txtLastName:UITextField!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var imgProfile:CustomImageView!

    //MARK:- ViewLife Cycle
    

    override func viewDidLoad() {
        super.viewDidLoad()

        [txtUsername,txtPhonenumber,txtFirstName,txtLastName,txtCoutryCode,txtEmail].forEach { (txtField) in
            txtField?.delegate = self
        }
        cpvInternal.delegate = self
        setupUserData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        
        let btnBack = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(btnBackAction(_:)))
        btnBack.tintColor = .white
        
        let btnBackTitle = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        btnBackTitle.tintColor = .white
        
        self.navigationItem.leftBarButtonItems = [btnBack,btnBackTitle]
    }
    
    //MARK:- Setup User
    
    func setupUserData() {
        self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgProfile.sd_setImage(with: URL(string: "\(URL_USER_PROFILE_IMAGES)\(dictUserDetail.profileImage ?? "")"), placeholderImage: UIImage(named: "ic_username"), options: .lowPriority, context: nil)
        self.txtUsername.text = dictUserDetail.username
        self.txtFirstName.text = dictUserDetail.firstName
        self.txtLastName.text = dictUserDetail.lastName
        self.txtEmail.text = "\(dictUserDetail.email ?? "")"
        self.txtPhonenumber.text = "\(dictUserDetail.phone ?? 0)"
        self.txtCoutryCode.text = "\(dictUserDetail.countryCode ?? 0)"
        
    }
    
    //MARK:- Action Zone
    
    @IBAction func btnChangePAswordAction(_ sender:UIButton){
        let obj = profileStoryboard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(obj, animated: true)
    }

}

//MARK:- Action Zone

extension EditProfileVC {
    
    @IBAction func btnSelectImageAction(_ sender:UIButton) {
        alertActionForGallary()
    }
    
    @IBAction func btnUpdateProfileAction(_ sender:UIButton) {
        if (txtUsername.text?.trimString().isEmpty)! {
            makeToast(strMessage: "Please enter username")
        } else if (txtFirstName.text?.trimString().isEmpty)! {
            makeToast(strMessage: "Please enter first name")
        } else if (txtLastName.text?.trimString().isEmpty)! {
            makeToast(strMessage: "Please enter last name")
        } else if (txtEmail.text?.trimString().isEmpty)! {
            makeToast(strMessage: "Please enter email")
        } else if !(txtEmail.text?.trimString().isValidEmail())! {
            makeToast(strMessage: "Please enter valid email")
        } else if (txtCoutryCode.text?.trimString().isEmpty)! {
            makeToast(strMessage: "Please select country code")
        } else if (txtPhonenumber.text?.trimString().isEmpty)! {
            makeToast(strMessage: "Please enter mobile number")
        } else {
            var dict = [String:AnyObject]()
            let phone = txtCoutryCode.text?.replacingOccurrences(of: "+", with: "")
            dict["first_name"] = txtFirstName.text?.trimString() as AnyObject
            dict["last_name"] = txtLastName.text?.trimString() as AnyObject
            dict["username"] = txtUsername.text?.trimString() as AnyObject
            dict["email"] = txtEmail.text?.trimString() as AnyObject
            dict["country_code"] = phone!.trimString() as AnyObject
            dict["phone"] = txtPhonenumber.text?.trimString() as AnyObject
            editProfileAPICalling(param: dict)
        }
    }
    
}

//MARK: - UIImagePickerController

extension EditProfileVC:UIImagePickerControllerDelegate,
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
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- Country Picker Delegate

extension EditProfileVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        print("Message \(message)")
        self.txtCoutryCode.text = country.phoneCode
        self.txtPhonenumber.becomeFirstResponder()
    }

}

//MARK:- Textfield Delegate

extension EditProfileVC:UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtCoutryCode {
            cpvInternal.showCountriesList(from: self)
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtUsername || textField == txtFirstName || textField == txtLastName  {
            let aSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        return true
    }
   
}



//MARK:- API

extension EditProfileVC {
    func editProfileAPICalling(param:[String:AnyObject]) {
        ServiceManager.makeReqeusrWithMultipartData(with: URL_UPDATE_USER_DETAIL, method: .post, parameter: param, image: image,image_name: "profile_image",success: { (response) in
            print("Response \(response)")
            if let dictData = response as? NSDictionary {
                if let status = dictData["status"] as? Int, status == 1 {
                    if let dict  = dictData["data"] as? NSDictionary {
                        let model = ClsUserLoginModel(fromDictionary: dict)
                        appDelegate.objUser = model
                        setCustomObject(value: appDelegate.objUser!, key: USER_LOGIN_INFO)
                        self.handleUpdateDetail(model)
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
