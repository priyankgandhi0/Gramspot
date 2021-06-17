//
//  PictureLocationVC.swift
//  GemSpot
//
//  Created by Jaydeep on 04/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import DropDown
import SwiftyJSON

class PictureLocationVC: UIViewController {
    
    //MARK:- Variable Declaration
    
    let newPin = MKPointAnnotation()
    var imgSelected = UIImage()
    var selectedLatLong = CLLocationCoordinate2D()
    var selectType = checkVideoPhoto.photo
    var videoURL:URL?
    var pictureDate = Date()
    var pictureLocation = CLLocationCoordinate2D()
    var selectedPostStatus = checkPostStatus.add
    var dictPostDetail = ClsPostListModel()
    var handlerUpdateLatLong:(CLLocationCoordinate2D) -> Void = {_ in}
    var arrSelectedImage = [UIImage]()
    var ddLocation = DropDown()
    var arrLocation : [JSON] = [] {
        didSet {
            if arrLocation.count != 0 {
                let dict = self.arrLocation[0]
                self.selectedLatLong  = CLLocationCoordinate2D(latitude: dict["latitude"].doubleValue, longitude: dict["longitude"].doubleValue)
                self.setupPin(location: self.selectedLatLong)
            }
        }
    }
    
    //MARK:- Outlet zone
    
    @IBOutlet weak var viewMaps: MKMapView!
    
    //MARK:- ViewLife Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        
        let btnBack = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(btnBackAction(_:)))
        btnBack.tintColor = .white
        
        let btnBackTitle = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        btnBackTitle.tintColor = .white
        
        self.navigationItem.leftBarButtonItems = [btnBack,btnBackTitle]
        
        let btnLocation = UIBarButtonItem(image: UIImage(named: "ic_left_place_pin"), style: .plain, target: self, action: #selector(openDropDown))
        btnLocation.tintColor = .white
        
        self.navigationItem.rightBarButtonItem = btnLocation
        
        configureDropdown(dropdown: ddLocation, sender: btnLocation,isWidth: false)
        
        //        setRightBarButton("Reset Location")
        
    }
    
    @objc func openDropDown() {
        var seen = Set<String>()
        var unique = [JSON]()
        for message in arrLocation {
            if !seen.contains(message["address"].stringValue) {
                unique.append(message)
                seen.insert(message["address"].stringValue)
            }
        }
        self.arrLocation = unique
        let arr = self.arrLocation.map({$0["address"].stringValue})
        self.ddLocation.dataSource = arr
        ddLocation.show()
    }
    
    
    func selectionDropDown() {
        self.arrLocation = []       
        for i in 0..<arrMainSelectedImage.count {
            let dict = arrMainSelectedImage[i]
            if let dictLoc = dict.location {
                getAddressFromLatLon(pdblLatitude: dictLoc.latitude, pdblLongitude: dictLoc.longitude, success: { (adderess) in
                    var dictLocation = JSON()
                    dictLocation["address"].stringValue = adderess
                    dictLocation["latitude"].doubleValue = dictLoc.latitude
                    dictLocation["longitude"].doubleValue = dictLoc.longitude
                    self.arrLocation.append(dictLocation)
                })
            }
        }
   
        ddLocation.selectionAction =  {[weak self] index,titel in
            self?.ddLocation.selectRow(index)
            if let dict = self?.arrLocation[index] {
                self?.selectedLatLong  = CLLocationCoordinate2D(latitude: dict["latitude"].doubleValue, longitude: dict["longitude"].doubleValue)
                self?.setupPin(location: self?.selectedLatLong ?? kCurrentUserLocation.coordinate)
            }
            
        }
    }
    
    func setRightBarButton(_ title:String) {
        let btnHomeRight = CustomButton(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
        btnHomeRight.titleLabel?.font = themeFont(size: 16, fontname: .bold)
        btnHomeRight.cornerRadius = btnHomeRight.frame.height/2
        btnHomeRight.setTitle(title, for: .normal)
        btnHomeRight.backgroundColor = .white
        btnHomeRight.setTitleColor(APP_THEME_GREEN_COLOR, for: .normal)
        btnHomeRight.addTarget(self, action: #selector(btnResetLocation(_:)), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: btnHomeRight)
        
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func setupPin(location:CLLocationCoordinate2D) {
        viewMaps.showsUserLocation = true
        
        let center = CLLocationCoordinate2D(latitude: location.latitude , longitude: location.longitude )
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        //set region on the map
        viewMaps.setRegion(region, animated: true)
        viewMaps.tintColor = APP_THEME_GREEN_COLOR
    }
    
    func getAddressFromLatLon(pdblLatitude: Double, pdblLongitude: Double,success: @escaping (_ response: String) -> Void)  {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = pdblLatitude
        center.longitude = pdblLongitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail: \(error!.localizedDescription)")
                                            success("")
                                        }
                                        let pm = placemarks! as [CLPlacemark]
                                        
                                        if pm.count > 0 {
                                            let pm = placemarks![0]
                                            print(pm.country)
                                            print(pm.locality)
                                            print(pm.subLocality)
                                            print(pm.thoroughfare)
                                            print(pm.postalCode)
                                            print(pm.subThoroughfare)
                                            var addressString : String = ""
                                            if pm.subLocality != nil {
                                                addressString = addressString + pm.subLocality! + ", "
                                            }
                                            if pm.thoroughfare != nil {
                                                addressString = addressString + pm.thoroughfare! + ", "
                                            }
                                            if pm.locality != nil {
                                                addressString = addressString + pm.locality! + ", "
                                            }
                                            if pm.country != nil {
                                                addressString = addressString + pm.country! + ", "
                                            }
                                            if pm.postalCode != nil {
                                                addressString = addressString + pm.postalCode! + " "
                                            }
                                            print("addressString \(addressString)")
                                            success(addressString)
                                        }
                                    })
        
    }
    
}

//MARK:- Action

extension PictureLocationVC {
    
    @IBAction func btnConfirmAction(_ sender:UIButton) {
        if selectedPostStatus == .add {
            let obj = customeCameraStoryboard.instantiateViewController(withIdentifier: "PhotoDetailVC") as! PhotoDetailVC
//            obj.imgSelected = imgSelected
//            obj.arrSelectedImage = arrSelectedImage
//            obj.selectType = selectType
//            obj.videoURL = videoURL
            obj.selectDate = pictureDate
            obj.selectedLatLong = selectedLatLong
            self.navigationController?.pushViewController(obj, animated: true)
        } else {
           handlerUpdateLatLong(selectedLatLong)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func btnResetLocation(_ sender:UIButton) {
        let currentLocation = viewMaps.userLocation.location!
        let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        //set region on the map
        viewMaps.setRegion(region, animated: true)
        
        selectedLatLong = viewMaps.userLocation.location!.coordinate
    }
}

//MARK:- MapView Delegate

extension PictureLocationVC:MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        selectedLatLong = mapView.centerCoordinate
        print("selectedLatLong \(selectedLatLong)")
    }
}
