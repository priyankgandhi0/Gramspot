//
//	ClsNotificationModel.swift
//
//	Create by Dreamworld on 12/10/2020
//	Copyright © 2020. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ClsNotificationModel : NSObject, NSCoding{

	var createAt : String!
	var isRead : Int!
	var notificationId : Int!
	var notificationText : String!
	var notificationToken : String!
	var notificationType : String!
	var oppositeUserToken : String!
	var postToken : String!
	var profileImage : String!
	var userToken : String!
	var username : String!


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
		createAt = dictionary["create_at"] as? String == nil ? "" : dictionary["create_at"] as? String
		isRead = dictionary["is_read"] as? Int == nil ? 0 : dictionary["is_read"] as? Int
		notificationId = dictionary["notification_id"] as? Int == nil ? 0 : dictionary["notification_id"] as? Int
		notificationText = dictionary["notification_text"] as? String == nil ? "" : dictionary["notification_text"] as? String
		notificationToken = dictionary["notification_token"] as? String == nil ? "" : dictionary["notification_token"] as? String
		notificationType = dictionary["notification_type"] as? String == nil ? "" : dictionary["notification_type"] as? String
		oppositeUserToken = dictionary["opposite_user_token"] as? String == nil ? "" : dictionary["opposite_user_token"] as? String
		postToken = dictionary["post_token"] as? String == nil ? "" : dictionary["post_token"] as? String
		profileImage = dictionary["profile_image"] as? String == nil ? "" : dictionary["profile_image"] as? String
		userToken = dictionary["user_token"] as? String == nil ? "" : dictionary["user_token"] as? String
		username = dictionary["username"] as? String == nil ? "" : dictionary["username"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if createAt != nil{
			dictionary["create_at"] = createAt
		}
		if isRead != nil{
			dictionary["is_read"] = isRead
		}
		if notificationId != nil{
			dictionary["notification_id"] = notificationId
		}
		if notificationText != nil{
			dictionary["notification_text"] = notificationText
		}
		if notificationToken != nil{
			dictionary["notification_token"] = notificationToken
		}
		if notificationType != nil{
			dictionary["notification_type"] = notificationType
		}
		if oppositeUserToken != nil{
			dictionary["opposite_user_token"] = oppositeUserToken
		}
		if postToken != nil{
			dictionary["post_token"] = postToken
		}
		if profileImage != nil{
			dictionary["profile_image"] = profileImage
		}
		if userToken != nil{
			dictionary["user_token"] = userToken
		}
		if username != nil{
			dictionary["username"] = username
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         createAt = aDecoder.decodeObject(forKey: "create_at") as? String
         isRead = aDecoder.decodeObject(forKey: "is_read") as? Int
         notificationId = aDecoder.decodeObject(forKey: "notification_id") as? Int
         notificationText = aDecoder.decodeObject(forKey: "notification_text") as? String
         notificationToken = aDecoder.decodeObject(forKey: "notification_token") as? String
         notificationType = aDecoder.decodeObject(forKey: "notification_type") as? String
         oppositeUserToken = aDecoder.decodeObject(forKey: "opposite_user_token") as? String
         postToken = aDecoder.decodeObject(forKey: "post_token") as? String
         profileImage = aDecoder.decodeObject(forKey: "profile_image") as? String
         userToken = aDecoder.decodeObject(forKey: "user_token") as? String
         username = aDecoder.decodeObject(forKey: "username") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    public func encode(with aCoder: NSCoder) 
	{
		if createAt != nil{
			aCoder.encode(createAt, forKey: "create_at")
		}
		if isRead != nil{
			aCoder.encode(isRead, forKey: "is_read")
		}
		if notificationId != nil{
			aCoder.encode(notificationId, forKey: "notification_id")
		}
		if notificationText != nil{
			aCoder.encode(notificationText, forKey: "notification_text")
		}
		if notificationToken != nil{
			aCoder.encode(notificationToken, forKey: "notification_token")
		}
		if notificationType != nil{
			aCoder.encode(notificationType, forKey: "notification_type")
		}
		if oppositeUserToken != nil{
			aCoder.encode(oppositeUserToken, forKey: "opposite_user_token")
		}
		if postToken != nil{
			aCoder.encode(postToken, forKey: "post_token")
		}
		if profileImage != nil{
			aCoder.encode(profileImage, forKey: "profile_image")
		}
		if userToken != nil{
			aCoder.encode(userToken, forKey: "user_token")
		}
		if username != nil{
			aCoder.encode(username, forKey: "username")
		}

	}

}