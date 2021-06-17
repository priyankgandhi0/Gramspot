//
//	ClsUserLoginModel.swift
//
//	Create by Jaydeep on 11/4/2020
//	Copyright © 2020. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ClsUserLoginModel : NSObject, NSCoding{

	var authToken : String!
	var countryCode : Int!
	var deviceToken : String!
	var deviceType : String!
	var email : String!
	var facebookId : Int!
	var firstName : String!
	var isLoggedOut : Int!
	var ivv : String!
	var lastName : String!
	var phone : Int!
	var userId : Int!
	var userToken : String!
	var username : String!
	var verifyForgotCode : String!
    var followers : Int!
    var following : Int!
    var isFollow : Int!
    var post : [ClsPostListModel]!
    var profileImage : String!
    var isPrivacyPost : Int!
    var isPrivacySavePost : Int!
    var isPushFollowerPost : Int!
    var isPushOwnPost : Int!

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
		authToken = dictionary["auth_token"] as? String == nil ? "" : dictionary["auth_token"] as? String
		countryCode = dictionary["country_code"] as? Int == nil ? 0 : dictionary["country_code"] as? Int
		deviceToken = dictionary["device_token"] as? String == nil ? "" : dictionary["device_token"] as? String
		deviceType = dictionary["device_type"] as? String == nil ? "" : dictionary["device_type"] as? String
		email = dictionary["email"] as? String == nil ? "" : dictionary["email"] as? String
		facebookId = dictionary["facebook_id"] as? Int == nil ? 0 : dictionary["facebook_id"] as? Int
		firstName = dictionary["first_name"] as? String == nil ? "" : dictionary["first_name"] as? String
		isLoggedOut = dictionary["is_logged_out"] as? Int == nil ? 0 : dictionary["is_logged_out"] as? Int
		ivv = dictionary["ivv"] as? String == nil ? "" : dictionary["ivv"] as? String
		lastName = dictionary["last_name"] as? String == nil ? "" : dictionary["last_name"] as? String
		phone = dictionary["phone"] as? Int == nil ? 0 : dictionary["phone"] as? Int
		userId = dictionary["user_id"] as? Int == nil ? 0 : dictionary["user_id"] as? Int
		userToken = dictionary["user_token"] as? String == nil ? "" : dictionary["user_token"] as? String
		username = dictionary["username"] as? String == nil ? "" : dictionary["username"] as? String
		verifyForgotCode = dictionary["verify_forgot_code"] as? String == nil ? "" : dictionary["verify_forgot_code"] as? String
        followers = dictionary["followers"] as? Int == nil ? 0 : dictionary["followers"] as? Int
        following = dictionary["following"] as? Int == nil ? 0 : dictionary["following"] as? Int
        isFollow = dictionary["is_follow"] as? Int == nil ? 0 : dictionary["is_follow"] as? Int
        profileImage = dictionary["profile_image"] as? String == nil ? "" : dictionary["profile_image"] as? String
        post = [ClsPostListModel]()
        if let postArray = dictionary["post"] as? [NSDictionary]{
            for dic in postArray{
                let value = ClsPostListModel(fromDictionary: dic)
                post.append(value)
            }
        }
        isPrivacyPost = dictionary["is_privacy_post"] as? Int == nil ? 0 : dictionary["is_privacy_post"] as? Int
        isPrivacySavePost = dictionary["is_privacy_save_post"] as? Int == nil ? 0 : dictionary["is_privacy_save_post"] as? Int
        isPushFollowerPost = dictionary["is_push_follower_post"] as? Int == nil ? 0 : dictionary["is_push_follower_post"] as? Int
        isPushOwnPost = dictionary["is_push_own_post"] as? Int == nil ? 0 : dictionary["is_push_own_post"] as? Int
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if authToken != nil{
			dictionary["auth_token"] = authToken
		}
		if countryCode != nil{
			dictionary["country_code"] = countryCode
		}
		if deviceToken != nil{
			dictionary["device_token"] = deviceToken
		}
		if deviceType != nil{
			dictionary["device_type"] = deviceType
		}
		if email != nil{
			dictionary["email"] = email
		}
		if facebookId != nil{
			dictionary["facebook_id"] = facebookId
		}
		if firstName != nil{
			dictionary["first_name"] = firstName
		}
		if isLoggedOut != nil{
			dictionary["is_logged_out"] = isLoggedOut
		}
		if ivv != nil{
			dictionary["ivv"] = ivv
		}
		if lastName != nil{
			dictionary["last_name"] = lastName
		}
		if phone != nil{
			dictionary["phone"] = phone
		}
		if userId != nil{
			dictionary["user_id"] = userId
		}
		if userToken != nil{
			dictionary["user_token"] = userToken
		}
		if username != nil{
			dictionary["username"] = username
		}
		if verifyForgotCode != nil{
			dictionary["verify_forgot_code"] = verifyForgotCode
		}
        if followers != nil{
            dictionary["followers"] = followers
        }
        if following != nil{
            dictionary["following"] = following
        }
        if isFollow != nil{
            dictionary["is_follow"] = isFollow
        }
        if post != nil{
            var dictionaryElements = [NSDictionary]()
            for postElement in post {
                dictionaryElements.append(postElement.toDictionary())
            }
            dictionary["post"] = dictionaryElements
        }
        if profileImage != nil{
            dictionary["profile_image"] = profileImage
        }
        if isPrivacyPost != nil{
            dictionary["is_privacy_post"] = isPrivacyPost
        }
        if isPrivacySavePost != nil{
            dictionary["is_privacy_save_post"] = isPrivacySavePost
        }
        if isPushFollowerPost != nil{
            dictionary["is_push_follower_post"] = isPushFollowerPost
        }
        if isPushOwnPost != nil{
            dictionary["is_push_own_post"] = isPushOwnPost
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         authToken = aDecoder.decodeObject(forKey: "auth_token") as? String
         countryCode = aDecoder.decodeObject(forKey: "country_code") as? Int
         deviceToken = aDecoder.decodeObject(forKey: "device_token") as? String
         deviceType = aDecoder.decodeObject(forKey: "device_type") as? String
         email = aDecoder.decodeObject(forKey: "email") as? String
         facebookId = aDecoder.decodeObject(forKey: "facebook_id") as? Int
         firstName = aDecoder.decodeObject(forKey: "first_name") as? String
         isLoggedOut = aDecoder.decodeObject(forKey: "is_logged_out") as? Int
         ivv = aDecoder.decodeObject(forKey: "ivv") as? String
         lastName = aDecoder.decodeObject(forKey: "last_name") as? String
         phone = aDecoder.decodeObject(forKey: "phone") as? Int
         userId = aDecoder.decodeObject(forKey: "user_id") as? Int
         userToken = aDecoder.decodeObject(forKey: "user_token") as? String
         username = aDecoder.decodeObject(forKey: "username") as? String
         verifyForgotCode = aDecoder.decodeObject(forKey: "verify_forgot_code") as? String
         followers = aDecoder.decodeObject(forKey: "followers") as? Int
         following = aDecoder.decodeObject(forKey: "following") as? Int
         isFollow = aDecoder.decodeObject(forKey: "is_follow") as? Int
         post = aDecoder.decodeObject(forKey: "post") as? [ClsPostListModel]
         profileImage = aDecoder.decodeObject(forKey: "profile_image") as? String
         isPrivacyPost = aDecoder.decodeObject(forKey: "is_privacy_post") as? Int
         isPrivacySavePost = aDecoder.decodeObject(forKey: "is_privacy_save_post") as? Int
         isPushFollowerPost = aDecoder.decodeObject(forKey: "is_push_follower_post") as? Int
         isPushOwnPost = aDecoder.decodeObject(forKey: "is_push_own_post") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    public func encode(with aCoder: NSCoder) 
	{
		if authToken != nil{
			aCoder.encode(authToken, forKey: "auth_token")
		}
		if countryCode != nil{
			aCoder.encode(countryCode, forKey: "country_code")
		}
		if deviceToken != nil{
			aCoder.encode(deviceToken, forKey: "device_token")
		}
		if deviceType != nil{
			aCoder.encode(deviceType, forKey: "device_type")
		}
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if facebookId != nil{
			aCoder.encode(facebookId, forKey: "facebook_id")
		}
		if firstName != nil{
			aCoder.encode(firstName, forKey: "first_name")
		}
		if isLoggedOut != nil{
			aCoder.encode(isLoggedOut, forKey: "is_logged_out")
		}
		if ivv != nil{
			aCoder.encode(ivv, forKey: "ivv")
		}
		if lastName != nil{
			aCoder.encode(lastName, forKey: "last_name")
		}
		if phone != nil{
			aCoder.encode(phone, forKey: "phone")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}
		if userToken != nil{
			aCoder.encode(userToken, forKey: "user_token")
		}
		if username != nil{
			aCoder.encode(username, forKey: "username")
		}
		if verifyForgotCode != nil{
			aCoder.encode(verifyForgotCode, forKey: "verify_forgot_code")
		}
        if followers != nil{
            aCoder.encode(followers, forKey: "followers")
        }
        if following != nil{
            aCoder.encode(following, forKey: "following")
        }
        if isFollow != nil{
            aCoder.encode(isFollow, forKey: "is_follow")
        }
        if post != nil{
            aCoder.encode(post, forKey: "post")
        }        
        if profileImage != nil{
            aCoder.encode(profileImage, forKey: "profile_image")
        }
        if isPrivacyPost != nil{
            aCoder.encode(isPrivacyPost, forKey: "is_privacy_post")
        }
        if isPrivacySavePost != nil{
            aCoder.encode(isPrivacySavePost, forKey: "is_privacy_save_post")
        }
        if isPushFollowerPost != nil{
            aCoder.encode(isPushFollowerPost, forKey: "is_push_follower_post")
        }
        if isPushOwnPost != nil{
            aCoder.encode(isPushOwnPost, forKey: "is_push_own_post")
        }

	}

}
