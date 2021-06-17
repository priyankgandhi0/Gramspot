//
//  UserAnnotationView.swift
//  GemSpot
//
//  Created by Jaydeep on 16/05/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

class UserAnnotationView: MKMarkerAnnotationView {
    
    static let preferredClusteringIdentifier = Bundle.main.bundleIdentifier! + ".UserAnnotationView"
     
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = UserAnnotationView.preferredClusteringIdentifier
        canShowCallout = true
        let views = Bundle.main.loadNibNamed("AnnotationView", owner: nil, options: nil)
        let calloutView = views?[0] as! AnnotationView
        
        if let anno = annotation as? CustomAnnotation {
            if anno.isVideo == 0 {
                calloutView.imgPost.sd_imageIndicator = SDWebImageActivityIndicator.gray
                calloutView.imgPost.sd_setImage(with: URL(string: URL_POST_PIC+(anno.compressImage ?? "")), placeholderImage: UIImage(named: "image_placehoder"), options: .lowPriority, context: nil)
            } else {
                calloutView.imgPost.sd_imageIndicator = SDWebImageActivityIndicator.gray
                let image = anno.compressImage?.replacingOccurrences(of: "mp4", with: "png") ?? ""
                calloutView.imgPost.sd_setImage(with: URL(string: URL_POST_PIC+image), placeholderImage: UIImage(named: "image_placehoder"), options: .lowPriority, context: nil)
            }            
            calloutView.btnPost.isHidden = false
            calloutView.lblCount.isHidden = true
            calloutView.btnPost.tag = anno.tag ?? 0
            calloutView.btnPost.addTarget(self, action: #selector(btnPostAction(_:)), for: .touchUpInside)
            
        } else if let clusterAnnotation = annotation as? MKClusterAnnotation {
            let memberAnnotation = clusterAnnotation.memberAnnotations
            if let anno = memberAnnotation[0] as? CustomAnnotation {
                calloutView.btnPost.isHidden = false
                calloutView.btnPost.addTarget(self, action: #selector(btnPostAction(_:)), for: .touchUpInside)
                calloutView.lblCount.isHidden = false
                calloutView.lblCount.text = "\(memberAnnotation.count)"
                calloutView.lblCount.layer.cornerRadius = calloutView.lblCount.frame.height/2
                calloutView.lblCount.clipsToBounds = true
                calloutView.imgPost.sd_imageIndicator = SDWebImageActivityIndicator.gray
                calloutView.imgPost.sd_setImage(with: URL(string: URL_POST_PIC+(anno.compressImage ?? "")), placeholderImage: UIImage(named: "image_placehoder"), options: .lowPriority, context: nil)
            }
        }
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        calloutView.center = self.layer.contentsCenter.origin
        self.addSubview(calloutView)
        
        self.glyphText = ""
        self.glyphTintColor = UIColor.clear
        self.markerTintColor = UIColor.clear
    }
    
    @objc func btnPostAction(_ sender:UIButton) {
        print("tag \(sender.tag)")
        if let anno = annotation as? CustomAnnotation {
            print("single annotation")
            NotificationCenter.default.post(name: .didClickAnnotaion, object: anno)
        } else if let clusterAnnotation = annotation as? MKClusterAnnotation {
            print("Cluster annotaion")
            NotificationCenter.default.post(name: .didClickAnnotaion, object: clusterAnnotation)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = UserAnnotationView.preferredClusteringIdentifier
            if let clusterAnnotation = annotation as? MKClusterAnnotation {
//                setupView(count: clusterAnnotation.memberAnnotations.count)
            } else {
//                setupView(count: 0)
            }
        }
        
        didSet {
            displayPriority = .required
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil)
        {
            self.superview?.bringSubviewToFront(self)
        }
        return hitView
    }


    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds
        var isInside: Bool = rect.contains(point)
        if(!isInside) {
            for view in self.subviews {
                isInside = view.frame.contains(point)
                if isInside {
                    break
                }
            }
        }
        return isInside
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        //        displayPriority = .required
        //        markerTintColor = APP_THEME_GREEN_COLOR
        //        glyphImage = #imageLiteral(resourceName: "ic_selected_pin")
    }
    
       
}
