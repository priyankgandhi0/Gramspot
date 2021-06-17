//
//  UserClusterAnnotationView.swift
//  GemSpot
//
//  Created by Jaydeep on 16/05/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import MapKit

class UserClusterAnnotationView: MKAnnotationView {

   static let preferredClusteringIdentifier = Bundle.main.bundleIdentifier! + ".UserClusterAnnotationView"
    

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = UserClusterAnnotationView.preferredClusteringIdentifier
        collisionMode = .circle
//        self.image =  UIImage(named: "ic_edit_pencil")
//        centerOffset = CGPoint(x: 0, y: -10)
        //       updateImage()
    }

   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

   override var annotation: MKAnnotation? {
       didSet {
           clusteringIdentifier = UserClusterAnnotationView.preferredClusteringIdentifier
           updateImage()
       }
   }
    
    override func prepareForDisplay() {
        updateImage()
    }

   private func updateImage() {
       if let clusterAnnotation = annotation as? MKClusterAnnotation {
//           self.image = image(count: clusterAnnotation.memberAnnotations.count)
        self.image = UIImage(named: "ic_edit_pencil")
       } else {
//           self.image = image(count: 1)
        self.image = UIImage(named: "ic_edit_pencil")
       }
   }

   func image(count: Int) -> UIImage {
       let bounds = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))

       let renderer = UIGraphicsImageRenderer(bounds: bounds)
       return renderer.image { _ in
           // Fill full circle with tricycle color
//            UIColor.clear.setFill()
//           UIBezierPath(ovalIn: bounds).fill()

           // Fill inner circle with white color
           UIColor.clear.setFill()
           UIBezierPath(ovalIn: bounds.insetBy(dx: 8, dy: 8)).fill()

           // Finally draw count text vertically and horizontally centered
           let attributes: [NSAttributedString.Key: Any] = [
               .foregroundColor: UIColor.black,
               .font: UIFont.boldSystemFont(ofSize: 20)
           ]

           let text = "\(count)"
           let size = text.size(withAttributes: attributes)
           let origin = CGPoint(x: bounds.midX - size.width / 2, y: bounds.midY - size.height / 2)
           let rect = CGRect(origin: origin, size: size)
           text.draw(in: rect, withAttributes: attributes)
       }
   }

}
