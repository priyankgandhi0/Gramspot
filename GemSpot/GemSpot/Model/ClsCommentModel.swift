//
//	ClsCommentModel.swift
//
//	Create by Dreamworld on 9/8/2020
//	Copyright © 2020. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ClsCommentModel : NSObject, NSCoding{

	var commentId : Int!
	var commentText : String!
	var commentToken : String!
	var createAt : String!
	var likeStatus : Int!
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
		commentId = dictionary["comment_id"] as? Int == nil ? 0 : dictionary["comment_id"] as? Int
		commentText = dictionary["comment_text"] as? String == nil ? "" : dictionary["comment_text"] as? String
		commentToken = dictionary["comment_token"] as? String == nil ? "" : dictionary["comment_token"] as? String
		createAt = dictionary["create_at"] as? String == nil ? "" : dictionary["create_at"] as? String
		likeStatus = dictionary["like_status"] as? Int == nil ? 0 : dictionary["like_status"] as? Int
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
		if commentId != nil{
			dictionary["comment_id"] = commentId
		}
		if commentText != nil{
			dictionary["comment_text"] = commentText
		}
		if commentToken != nil{
			dictionary["comment_token"] = commentToken
		}
		if createAt != nil{
			dictionary["create_at"] = createAt
		}
		if likeStatus != nil{
			dictionary["like_status"] = likeStatus
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
         commentId = aDecoder.decodeObject(forKey: "comment_id") as? Int
         commentText = aDecoder.decodeObject(forKey: "comment_text") as? String
         commentToken = aDecoder.decodeObject(forKey: "comment_token") as? String
         createAt = aDecoder.decodeObject(forKey: "create_at") as? String
         likeStatus = aDecoder.decodeObject(forKey: "like_status") as? Int
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
		if commentId != nil{
			aCoder.encode(commentId, forKey: "comment_id")
		}
		if commentText != nil{
			aCoder.encode(commentText, forKey: "comment_text")
		}
		if commentToken != nil{
			aCoder.encode(commentToken, forKey: "comment_token")
		}
		if createAt != nil{
			aCoder.encode(createAt, forKey: "create_at")
		}
		if likeStatus != nil{
			aCoder.encode(likeStatus, forKey: "like_status")
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
