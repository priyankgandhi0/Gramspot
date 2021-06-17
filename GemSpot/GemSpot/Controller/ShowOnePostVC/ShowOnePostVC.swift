//
//  ShowOnePostVC.swift
//  GemSpot
//
//  Created by Jaydeep on 14/10/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SDWebImage

class ShowOnePostVC: UIViewController {
    
    //MARK:- Variable Declaration
   
    var dictPost = ClsPostListModel()
    
    //MARK:- OutetZone
    
    @IBOutlet weak var viewMap:MKMapView!
    
    //MARK:- ViewLife cycle
    

    override func viewDidLoad() {
        super.viewDidLoad()

        addPinOnMap()
    }

    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        
        let btnBack = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(btnBackAction(_:)))
        btnBack.tintColor = .white
        
        let btnBackTitle = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        btnBackTitle.tintColor = .white
        
        self.navigationItem.leftBarButtonItems = [btnBack,btnBackTitle]
        
    }

}

//MARK:- MKMap delegate

extension ShowOnePostVC :MKMapViewDelegate {
    
    func addPinOnMap() {
        let myAnnotation = CustomAnnotation()
        myAnnotation.name = dictPost.username
        myAnnotation.coordinate = CLLocationCoordinate2D(latitude: dictPost.latitude, longitude: dictPost.longitude)
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter.dateFormate2.rawValue
        let createDate = formatter.date(from: dictPost.postDate)
        
        formatter.dateFormat = dateFormatter.dateFormate1.rawValue       
        let strDate = formatter.string(from: createDate ?? Date())
        
        myAnnotation.date = strDate
        myAnnotation.profileImage = dictPost.profileImage
        
        if dictPost.postImages.count != 0 {
            myAnnotation.postedImage = dictPost.postImages[0].postImages
            myAnnotation.isVideo = dictPost.postImages[0].isVideo
            viewMap.addAnnotation(myAnnotation)
            let anno = self.viewMap.annotations[0]
            
            self.viewMap.selectAnnotation(anno, animated: true)
            
            let center = CLLocationCoordinate2D(latitude: dictPost.latitude, longitude: dictPost.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

            //set region on the map
            viewMap.setRegion(region, animated: true)
        }

    }
    
    func setupPin() {
        viewMap.showsUserLocation = true
        let currentLocation = viewMap.userLocation.location
        let center = CLLocationCoordinate2D(latitude: currentLocation?.coordinate.latitude ?? kCurrentUserLocation.coordinate.latitude, longitude: currentLocation?.coordinate.longitude ?? kCurrentUserLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        //set region on the map
        viewMap.setRegion(region, animated: true)
        viewMap.tintColor = APP_THEME_GREEN_COLOR
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        /*if annotation is MKUserLocation {
            return nil
        }*/
        return UserAnnotationView(annotation: annotation, reuseIdentifier: UserAnnotationView.preferredClusteringIdentifier)
        
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotationView = view as? MKMarkerAnnotationView {
            if let customAnnotation = view.annotation as? CustomAnnotation {
                openAnnotation(annotationView: annotationView, annotaion: customAnnotation)
            } else if let cluster = view.annotation as? MKClusterAnnotation {
                let mapEdgePadding = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
                var zoomRect = MKMapRect.null
                var isCustomAnnotation = false
                for annotation in cluster.memberAnnotations {
                    /*if let anno = annotation as? CustomAnnotation {
                        isCustomAnnotation = true
                        openAnnotation(annotationView: annotationView, annotaion: anno)
//                        break
                    }*/ //else {
                        let annotationPoint = MKMapPoint(annotation.coordinate)
                        let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
                        if zoomRect.isNull {
                            zoomRect = pointRect
                        } else {
                            zoomRect = zoomRect.union(pointRect)
                        }
//                    }
                }
                if !isCustomAnnotation {
                    mapView.setVisibleMapRect(zoomRect, edgePadding: mapEdgePadding, animated: true)
                }
            }
        }
    }
    
    func openAnnotation(annotationView:MKAnnotationView,annotaion:CustomAnnotation) {
        let views = Bundle.main.loadNibNamed("CustomAnnotationView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomAnnotationView
        print("tag = \(annotaion.tag ?? 0)")
        calloutView.lblUserName.text = annotaion.name
        calloutView.lblDate.text = annotaion.date
        if annotaion.isVideo == 0 {
            calloutView.imgPost.sd_imageIndicator = SDWebImageActivityIndicator.gray
            calloutView.imgPost.sd_setImage(with: URL(string: URL_POST_PIC+(annotaion.postedImage ?? "")), placeholderImage: UIImage(named: "image_placehoder"), options: .lowPriority, context: nil)
        } else {
            calloutView.imgPost.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let image = annotaion.postedImage?.replacingOccurrences(of: "mp4", with: "png") ?? ""
            calloutView.imgPost.sd_setImage(with: URL(string: URL_POST_PIC+image), placeholderImage: UIImage(named: "image_placehoder"), options: .lowPriority, context: nil)
        }
        calloutView.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        calloutView.imgProfile.sd_setImage(with: URL(string: "\(URL_USER_PROFILE_IMAGES)\(annotaion.profileImage ?? "")"), placeholderImage: UIImage(named: "ic_username"), options: .lowPriority, context: nil)
        calloutView.translatesAutoresizingMaskIntoConstraints = false
        calloutView.btnEditOutlet.isHidden = true
        calloutView.btnEditOutlet.tag = annotaion.tag ?? 0
        calloutView.btnPostDetailOutlet.tag = annotaion.tag ?? 0
        annotationView.backgroundColor = .clear
        annotationView.detailCalloutAccessoryView = calloutView
    }
    
      
    
}
