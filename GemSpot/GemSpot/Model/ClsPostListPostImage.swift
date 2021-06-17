//
//	ClsPostListPostImage.swift
//
//	Create by Jaydeep on 5/7/2020
//	Copyright © 2020. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import UIKit
import CoreLocation
import Photos

class ClsPostListPostImage : NSObject, NSCoding{

	var isVideo : Int!
	var postImages : String!
	var postToken : String!
	var userPostImageId : Int!
	var userToken : String!
    var image : UIImage!
    var isUploaded : Int!
    var allData : Data!
    var videoURL : URL!
    var brightnessValue : Float!
    var contrastValue : Float!
    var originalImage : UIImage!
    var location : CLLocationCoordinate2D?
    var assets : PHAsset?
    var postCompressImage : String!

	/**
	 * Overiding init method
	 */
	init(fromDictionary dictionary: NSDictionary)
	{
		super.init()
		parseJSONData(fromDictionary: dictionary)
	}

	/**
	 * Overiding init method
	 */
	override init(){
	}

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	@objc func parseJSONData(fromDictionary dictionary: NSDictionary)
	{
		isVideo = dictionary["is_video"] as? Int == nil ? 0 : dictionary["is_video"] as? Int
		postImages = dictionary["post_image"] as? String == nil ? "" : dictionary["post_image"] as? String
		postToken = dictionary["post_token"] as? String == nil ? "" : dictionary["post_token"] as? String
		userPostImageId = dictionary["user_post_image_id"] as? Int == nil ? 0 : dictionary["user_post_image_id"] as? Int
		userToken = dictionary["user_token"] as? String == nil ? "" : dictionary["user_token"] as? String
        postCompressImage = dictionary["post_compress_image"] as? String == nil ? "" : dictionary["post_compress_image"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if isVideo != nil{
			dictionary["is_video"] = isVideo
		}
		if postImages != nil{
			dictionary["post_image"] = postImages
		}
		if postToken != nil{
			dictionary["post_token"] = postToken
		}
		if userPostImageId != nil{
			dictionary["user_post_image_id"] = userPostImageId
		}
		if userToken != nil{
			dictionary["user_token"] = userToken
		}
        if postCompressImage != nil{
            dictionary["post_compress_image"] = postCompressImage
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         isVideo = aDecoder.decodeObject(forKey: "is_video") as? Int
         postImages = aDecoder.decodeObject(forKey: "post_image") as? String
         postToken = aDecoder.decodeObject(forKey: "post_token") as? String
         userPostImageId = aDecoder.decodeObject(forKey: "user_post_image_id") as? Int
         userToken = aDecoder.decodeObject(forKey: "user_token") as? String
         postCompressImage = aDecoder.decodeObject(forKey: "post_compress_image") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    public func encode(with aCoder: NSCoder) 
	{
		if isVideo != nil{
			aCoder.encode(isVideo, forKey: "is_video")
		}
		if postImages != nil{
			aCoder.encode(postImages, forKey: "post_image")
		}
		if postToken != nil{
			aCoder.encode(postToken, forKey: "post_token")
		}
		if userPostImageId != nil{
			aCoder.encode(userPostImageId, forKey: "user_post_image_id")
		}
		if userToken != nil{
			aCoder.encode(userToken, forKey: "user_token")
		}
        if postCompressImage != nil{
            aCoder.encode(postCompressImage, forKey: "post_compress_image")
        }

	}

}
