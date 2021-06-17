//
//  TabBarController.swift
//  GemSpot
//
//  Created by Jaydeep on 01/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
        setupSeperator()
    }
    

    //MARK:- setup Tabbar
    
    func setupTabBar(){
        
        self.delegate = self
        
        let first = homeStoryboard.instantiateViewController(withIdentifier: "MyHomeVC") as! MyHomeVC
        let firstTab = UITabBarItem(title: "", image: UIImage(named: "ic_unselected_home"), selectedImage: UIImage(named: "ic_selected_home")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        first.tabBarItem = firstTab
        
        let second = postStoryboard.instantiateViewController(withIdentifier: "MyPlaceVC") as! MyPlaceVC
        let secondTab = UITabBarItem(title: "", image: UIImage(named: "ic_unselected_place"), selectedImage: UIImage(named: "ic_selected_place")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        second.tabBarItem = secondTab
        
        let third = customeCameraStoryboard.instantiateViewController(withIdentifier: "CustomCameraVC") as! CustomCameraVC
        third.statusAddMoreImage = .initial
        let thirdTab = UITabBarItem(title: "", image: UIImage(named: "ic_unselected_camera"), selectedImage:nil)
        third.tabBarItem = thirdTab
        
        let fourth = profileStoryboard.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
        let fourthTab = UITabBarItem(title: "".capitalized, image: UIImage(named: "ic_unselected_profile"), selectedImage: UIImage(named: "ic_selected_profile")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        fourth.tabBarItem = fourthTab
        
        let fifth = notificationStoryboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        let fifthTab = UITabBarItem(title: "", image: UIImage(named: "ic_unselected_alarm"), selectedImage: UIImage(named: "ic_selected_notification")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        fifth.tabBarItem = fifthTab
        
        let n1 = UINavigationController(rootViewController:first)
        let n2 = UINavigationController(rootViewController:second)
        let n3 = UINavigationController(rootViewController:third)
        let n4 = UINavigationController(rootViewController:fourth)
        let n5 = UINavigationController(rootViewController:fifth)
        
        n1.isNavigationBarHidden = false
        n2.isNavigationBarHidden = false
        n3.isNavigationBarHidden = false
        n4.isNavigationBarHidden = false
        n5.isNavigationBarHidden = false
        
        self.viewControllers = [n1,n2,n3,n4,n5]
         
        self.tabBar.barTintColor = .white
        self.tabBar.isTranslucent = true
        self.tabBar.layer.shadowOpacity = 0.3
        self.tabBar.layer.shadowOffset = CGSize(width: 1, height: 1)
        
    }
    
    override func viewDidLayoutSubviews() {
        self.tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: APP_THEME_GREEN_COLOR, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height:  tabBar.frame.height), lineWidth: 2.0)
    }
    
    func setupSeperator() {
        if let items = self.tabBar.items {
            
            //Get the height of the tab bar
            
            let height = self.tabBar.bounds.height
            
            //Calculate the size of the items
            
            let numItems = CGFloat(items.count)
            let itemSize = CGSize(
                width: tabBar.frame.width / numItems,
                height: tabBar.frame.height)
            
            for (index, _) in items.enumerated() {
                
                //We don't want a separator on the left of the first item.
                
                if index > 0 {
                    
                    //Xposition of the item
                    
                    let xPosition = itemSize.width * CGFloat(index)
                    
                    /* Create UI view at the Xposition,
                     with a width of 0.5 and height equal
                     to the tab bar height, and give the
                     view a background color
                     */
                    let separator = UIView(frame: CGRect(
                        x: xPosition, y: 10, width: 0.5, height: height-20))
                    separator.backgroundColor = UIColor.hexStringToUIColor(hex: "#9E9E9E")
                    tabBar.insertSubview(separator, at: 1)
                }
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 2 {
            if let nav = tabBarController.viewControllers?[2] as? UINavigationController {
                if let firstVC = nav.viewControllers[0] as? CustomCameraVC {
                    firstVC.arrSelectedImage = [ClsPostListPostImage]()
                }
                nav.popToRootViewController(animated: true)
            }
            if let nav = tabBarController.viewControllers?[0] as? UINavigationController {
                if let firstVC = nav.viewControllers[0] as? MyHomeVC {
                    firstVC.isComeFromOwn = .own
                }
                nav.popToRootViewController(animated: true)
            }
        }
    }

}
