//
//  FollowerParentVC.swift
//  GemSpot
//
//  Created by Jaydeep on 02/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import CarbonKit
import SwiftyJSON

class FollowerParentVC: UIViewController {
    
    //MARK:- Variable Declaration
    
    var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var selectedParentStatus = followStatus.followers
    var dictUserDetail = ClsUserLoginModel()
    var updateFollowCount:(Int,Int) -> Void = {_,_ in}
    var selectedUserStatus = userProfileStatus.own
    var arrayHeader : [JSON] = []
    var selectedIndexVC = 0
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var viewFollower:UIView!
    @IBOutlet weak var collectionHeader: UICollectionView!
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionHeader.register(UINib(nibName: "HeaderTabCollectionCell", bundle: nil), forCellWithReuseIdentifier: "HeaderTabCollectionCell")
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        
        let btnBack = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(btnBackAction(_:)))
        btnBack.tintColor = .white
        
        let btnBackTitle = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        btnBackTitle.tintColor = .white
        
        self.navigationItem.leftBarButtonItems = [btnBack,btnBackTitle]
        
        if selectedUserStatus == .own {
            let btnSeacrh = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(btnSearchAction))
            btnSeacrh.tintColor = .white
            self.navigationItem.rightBarButtonItem = btnSeacrh
        }        
    }
    
    @objc func btnSearchAction() {
        let obj = profileStoryboard.instantiateViewController(withIdentifier: "SearchUserVC") as! SearchUserVC
        obj.selectedUserStatus = selectedUserStatus
        obj.updateFollowCount = {[weak self] follower,following,dict in
            if self?.selectedUserStatus == .own {
                self?.setupArray(followers: follower, following: following)
            }
            if dict.isFollow == 0 {
                if let obj = self?.carbonTabSwipeNavigation.viewControllers[1] as? FollowerChildVC {
                    if let index = obj.arrFollowerList.firstIndex(where: {$0.userToken == "\(dict.userToken ?? "")"}) {
                        print("index \(index)")
                        obj.arrFollowerList.remove(at: index)
                        obj.tblFollowerList.reloadData()
                    }
                }
            } else {
                if let obj = self?.carbonTabSwipeNavigation.viewControllers[1] as? FollowerChildVC{
                    obj.arrFollowerList.insert(dict, at: 0)
                    obj.tblFollowerList.reloadData()
                }
            }
            self?.updateFollowCount(follower,following)
        }
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    
    //MARK:- Setup
    
    func setupUI()  {
        
        var dict = JSON()
        dict["title"].stringValue = "Followers : \(dictUserDetail.followers ?? 0)"
        dict["is_selected"] = "1"
        arrayHeader.append(dict)
        
        dict = JSON()
        dict["title"].stringValue = "Following : \(dictUserDetail.following ?? 0)"
        dict["is_selected"] = "0"
        arrayHeader.append(dict)
        
        self.collectionHeader.reloadData()
        
        let arrayItem = arrayHeader.map({$0["title"].stringValue})
        
        self.carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: arrayItem , delegate: self)
        self.carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: self.viewFollower)
        
        self.style()
        
    }
    
    override func viewDidLayoutSubviews() {
        self.collectionHeader.reloadData()
    }
}

//MARK: - Carbon kit
extension FollowerParentVC:CarbonTabSwipeNavigationDelegate
{
    func style() {
        let width = UIScreen.main.bounds.size.width
        
        carbonTabSwipeNavigation.toolbarHeight.constant = 50
        
        let tabWidth = (width / CGFloat(arrayHeader.count))
        let indicatorcolor: UIColor = APP_THEME_GREEN_COLOR
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(tabWidth, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(tabWidth, forSegmentAt: 1)
        carbonTabSwipeNavigation.toolbar.isTranslucent = false
        
        carbonTabSwipeNavigation.setIndicatorColor(indicatorcolor)
                
        /*carbonTabSwipeNavigation.setNormalColor(APP_THEME_GRAY_COLOR, font: themeFont(size: 15, fontname: .regular))
        carbonTabSwipeNavigation.setSelectedColor(APP_THEME_GREEN_COLOR, font: themeFont(size: 15, fontname: .extraBold))*/
        carbonTabSwipeNavigation.toolbar.isTranslucent = false
        carbonTabSwipeNavigation.toolbar.barTintColor = .white
        carbonTabSwipeNavigation.setSelectedColor(.clear)
        carbonTabSwipeNavigation.setNormalColor(.clear)
        
        carbonTabSwipeNavigation.setIndicatorHeight(0)
        if selectedParentStatus == .following {
            selectedIndexVC = 1
            reloadCollection(selectedIndex: selectedIndexVC)
            self.carbonTabSwipeNavigation.setCurrentTabIndex(1, withAnimation: true)
        }
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController
    {
        switch index {
        case 0:
            let vc = profileStoryboard.instantiateViewController(withIdentifier: "FollowerChildVC") as! FollowerChildVC
            vc.selectedParentStatus = .followers
            vc.dictUserDetail = dictUserDetail
            vc.selectedUserStatus = selectedUserStatus
            vc.updateFollowCount = {[weak self] follower,following,dict in
                if self?.selectedUserStatus == .own {
                    self?.setupArray(followers: follower, following: following)
                }
                if dict.isFollow == 0 {
                    if let obj = self?.carbonTabSwipeNavigation.viewControllers[1] as? FollowerChildVC {
                        if let index = obj.arrFollowerList.firstIndex(where: {$0.userToken == "\(dict.userToken ?? "")"}) {
                            print("index \(index)")
                            obj.arrFollowerList.remove(at: index)
                            obj.tblFollowerList.reloadData()
                        }
                    }
                    
                } else {
                    if let obj = self?.carbonTabSwipeNavigation.viewControllers[1] as? FollowerChildVC {
                        obj.arrFollowerList.insert(dict, at: 0)
                        obj.tblFollowerList.reloadData()
                    }
                }
                self?.updateFollowCount(follower,following)
            }
            return vc
        case 1:
            let vc = profileStoryboard.instantiateViewController(withIdentifier: "FollowerChildVC") as! FollowerChildVC
            vc.selectedParentStatus = .following
            vc.selectedUserStatus = selectedUserStatus
            vc.dictUserDetail = dictUserDetail
            vc.updateFollowCount = {[weak self] follower,following,dict in
                if self?.selectedUserStatus == .own {
                    self?.setupArray(followers: follower, following: following)
                }
                
                if dict.isFollow == 0 {
                    let obj = self?.carbonTabSwipeNavigation.viewControllers[1] as! FollowerChildVC
                    if let index = obj.arrFollowerList.firstIndex(where: {$0.userToken == "\(dict.userToken ?? "")"}) {
                        print("index \(index)")
                        obj.arrFollowerList.remove(at: index)
                        obj.tblFollowerList.reloadData()
                    }
                } else {
                    let obj = self?.carbonTabSwipeNavigation.viewControllers[1] as! FollowerChildVC
                    obj.arrFollowerList.insert(dict, at: 0)
                    obj.tblFollowerList.reloadData()
                    
                }
                self?.updateFollowCount(follower,following)
            }
            return vc
        default:
            let vc = profileStoryboard.instantiateViewController(withIdentifier: "FollowerChildVC") as! FollowerChildVC
            vc.selectedParentStatus = .followers
            vc.dictUserDetail = dictUserDetail
            vc.selectedUserStatus = selectedUserStatus
            vc.updateFollowCount = {[weak self] follower,following,dict in
                if self?.selectedUserStatus == .own {
                    self?.setupArray(followers: follower, following: following)
                }
                if dict.isFollow == 0 {
                    let obj = self?.carbonTabSwipeNavigation.viewControllers[1] as! FollowerChildVC
                    if let index = obj.arrFollowerList.firstIndex(where: {$0.userToken == "\(dict.userToken ?? "")"}) {
                        print("index \(index)")
                        obj.arrFollowerList.remove(at: index)
                        obj.tblFollowerList.reloadData()
                    }
                } else {
                    let obj = self?.carbonTabSwipeNavigation.viewControllers[1] as! FollowerChildVC
                    obj.arrFollowerList.insert(dict, at: 0)
                    obj.tblFollowerList.reloadData()
                    
                }
                self?.updateFollowCount(follower,following)
            }
            return vc
        }
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        
        selectedIndexVC = Int(index)
        reloadCollection(selectedIndex: selectedIndexVC)
        
        collectionHeader.scrollToItem(at: IndexPath(item: selectedIndexVC, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    func setupArray(followers:Int,following:Int) {
        for i in 0..<arrayHeader.count {
            var dict = arrayHeader[i]
            if i == 0 {
                dict["title"].stringValue = "Followers : \(followers)"
            } else {
                dict["title"].stringValue = "Following : \(following)"
            }
            arrayHeader[i] = dict
        }
        self.collectionHeader.reloadData()
    }
    
}

//MARK: - CollectionView DataSource

extension FollowerParentVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayHeader.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderTabCollectionCell", for: indexPath) as! HeaderTabCollectionCell
        
        let dict = self.arrayHeader[indexPath.row]
        
        cell.btnTitle.setTitle(dict["title"].stringValue, for: .normal)
        
        cell.btnTitle.isSelected = dict["is_selected"].stringValue == "1" ? true : false
        cell.vwUnderline.isHidden = !cell.btnTitle.isSelected
        cell.btnTitle.titleLabel?.font = dict["is_selected"].stringValue == "1" ? themeFont(size: 15, fontname: .extraBold) : themeFont(size: 15, fontname: .regular)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        carbonTabSwipeNavigation.currentTabIndex = UInt(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: collectionView.bounds.width/2, height: collectionView.frame.height)
    }

    func reloadCollection(selectedIndex:Int){
        
        for i in 0..<arrayHeader.count{
            var dict = self.arrayHeader[i]
            dict["is_selected"] = "0"
            self.arrayHeader[i] = dict
        }
        
        self.arrayHeader[selectedIndex]["is_selected"] = "1"
        collectionHeader.reloadData()
    }
}

