//
//	ClsFollowerListModel.swift
//
//	Create by Dreamworld on 15/9/2020
//	Copyright © 2020. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ClsFollowerListModel : NSObject, NSCoding {

    var email : String!
    var firstName : String!
    var isFollow : Int!
    var lastName : String!
    var oppositeUserToken : String!
    var profileImage : String!
    var userFollowersId : Int!
    var userFollowersToken : String!
    var userId : Int!
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
        email = dictionary["email"] as? String == nil ? "" : dictionary["email"] as? String
        firstName = dictionary["first_name"] as? String == nil ? "" : dictionary["first_name"] as? String
        isFollow = dictionary["is_follow"] as? Int == nil ? 0 : dictionary["is_follow"] as? Int
        lastName = dictionary["last_name"] as? String == nil ? "" : dictionary["last_name"] as? String
        oppositeUserToken = dictionary["opposite_user_token"] as? String == nil ? "" : dictionary["opposite_user_token"] as? String
        profileImage = dictionary["profile_image"] as? String == nil ? "" : dictionary["profile_image"] as? String
        userFollowersId = dictionary["user_followers_id"] as? Int == nil ? 0 : dictionary["user_followers_id"] as? Int
        userFollowersToken = dictionary["user_followers_token"] as? String == nil ? "" : dictionary["user_followers_token"] as? String
        userId = dictionary["user_id"] as? Int == nil ? 0 : dictionary["user_id"] as? Int
        userToken = dictionary["user_token"] as? String == nil ? "" : dictionary["user_token"] as? String
        username = dictionary["username"] as? String == nil ? "" : dictionary["username"] as? String
    }

    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if email != nil{
            dictionary["email"] = email
        }
        if firstName != nil{
            dictionary["first_name"] = firstName
        }
        if isFollow != nil{
            dictionary["is_follow"] = isFollow
        }
        if lastName != nil{
            dictionary["last_name"] = lastName
        }
        if oppositeUserToken != nil{
            dictionary["opposite_user_token"] = oppositeUserToken
        }
        if profileImage != nil{
            dictionary["profile_image"] = profileImage
        }
        if userFollowersId != nil{
            dictionary["user_followers_id"] = userFollowersId
        }
        if userFollowersToken != nil{
            dictionary["user_followers_token"] = userFollowersToken
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
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         email = aDecoder.decodeObject(forKey: "email") as? String
         firstName = aDecoder.decodeObject(forKey: "first_name") as? String
         isFollow = aDecoder.decodeObject(forKey: "is_follow") as? Int
         lastName = aDecoder.decodeObject(forKey: "last_name") as? String
         oppositeUserToken = aDecoder.decodeObject(forKey: "opposite_user_token") as? String
         profileImage = aDecoder.decodeObject(forKey: "profile_image") as? String
         userFollowersId = aDecoder.decodeObject(forKey: "user_followers_id") as? Int
         userFollowersToken = aDecoder.decodeObject(forKey: "user_followers_token") as? String
         userId = aDecoder.decodeObject(forKey: "user_id") as? Int
         userToken = aDecoder.decodeObject(forKey: "user_token") as? String
         username = aDecoder.decodeObject(forKey: "username") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    public func encode(with aCoder: NSCoder)
    {
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if firstName != nil{
            aCoder.encode(firstName, forKey: "first_name")
        }
        if isFollow != nil{
            aCoder.encode(isFollow, forKey: "is_follow")
        }
        if lastName != nil{
            aCoder.encode(lastName, forKey: "last_name")
        }
        if oppositeUserToken != nil{
            aCoder.encode(oppositeUserToken, forKey: "opposite_user_token")
        }
        if profileImage != nil{
            aCoder.encode(profileImage, forKey: "profile_image")
        }
        if userFollowersId != nil{
            aCoder.encode(userFollowersId, forKey: "user_followers_id")
        }
        if userFollowersToken != nil{
            aCoder.encode(userFollowersToken, forKey: "user_followers_token")
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

    }

}
