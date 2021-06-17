//
//	ClsPostListModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ClsPostListModel : NSObject, NSCoding{

    var cntLike : Int!
    var latitude : Double!
    var likeStatus : Int!
    var longitude : Double!
    var postDate : String!
    var postDescription : String!
    var postId : Int!
    var postImages : [ClsPostListPostImage]!
    var postTag : String!
    var postToken : String!
    var saveStatus : Int!
    var userToken : String!
    var username : String!
    var post : [ClsPostListModel]!
    var title : String!
    var profileImage : String!
    var postImage : String!
    var isVideo : Int!

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
        cntLike = dictionary["cnt_like"] as? Int == nil ? 0 : dictionary["cnt_like"] as? Int
        latitude = dictionary["latitude"] as? Double == nil ? 0 : dictionary["latitude"] as? Double
        likeStatus = dictionary["like_status"] as? Int == nil ? 0 : dictionary["like_status"] as? Int
        longitude = dictionary["longitude"] as? Double == nil ? 0 : dictionary["longitude"] as? Double
        postDate = dictionary["post_date"] as? String == nil ? "" : dictionary["post_date"] as? String
        postDescription = dictionary["post_description"] as? String == nil ? "" : dictionary["post_description"] as? String
        postId = dictionary["post_id"] as? Int == nil ? 0 : dictionary["post_id"] as? Int
        postImages = [ClsPostListPostImage]()
        if let postImagesArray = dictionary["post_images"] as? [NSDictionary]{
            for dic in postImagesArray{
                let value = ClsPostListPostImage(fromDictionary: dic)
                postImages.append(value)
            }
        }
        postTag = dictionary["post_tag"] as? String == nil ? "" : dictionary["post_tag"] as? String
        postToken = dictionary["post_token"] as? String == nil ? "" : dictionary["post_token"] as? String
        saveStatus = dictionary["save_status"] as? Int == nil ? 0 : dictionary["save_status"] as? Int
        userToken = dictionary["user_token"] as? String == nil ? "" : dictionary["user_token"] as? String
        username = dictionary["username"] as? String == nil ? "" : dictionary["username"] as? String
        post = [ClsPostListModel]()
        if let postArray = dictionary["post"] as? [NSDictionary]{
            for dic in postArray{
                let value = ClsPostListModel(fromDictionary: dic)
                post.append(value)
            }
        }
        title = dictionary["title"] as? String == nil ? "" : dictionary["title"] as? String
        profileImage = dictionary["profile_image"] as? String == nil ? "" : dictionary["profile_image"] as? String
        postImage = dictionary["post_image"] as? String == nil ? "" : dictionary["post_image"] as? String
        isVideo = dictionary["is_video"] as? Int == nil ? 0 : dictionary["is_video"] as? Int
    }

    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if cntLike != nil{
            dictionary["cnt_like"] = cntLike
        }
        if latitude != nil{
            dictionary["latitude"] = latitude
        }
        if likeStatus != nil{
            dictionary["like_status"] = likeStatus
        }
        if longitude != nil{
            dictionary["longitude"] = longitude
        }
        if postDate != nil{
            dictionary["post_date"] = postDate
        }
        if postDescription != nil{
            dictionary["post_description"] = postDescription
        }
        if postId != nil{
            dictionary["post_id"] = postId
        }
        if postImages != nil{
            var dictionaryElements = [NSDictionary]()
            for postImagesElement in postImages {
                dictionaryElements.append(postImagesElement.toDictionary())
            }
            dictionary["post_images"] = dictionaryElements
        }
        if postTag != nil{
            dictionary["post_tag"] = postTag
        }
        if postToken != nil{
            dictionary["post_token"] = postToken
        }
        if saveStatus != nil{
            dictionary["save_status"] = saveStatus
        }
        if userToken != nil{
            dictionary["user_token"] = userToken
        }
        if username != nil{
            dictionary["username"] = username
        }
        if post != nil{
            var dictionaryElements = [NSDictionary]()
            for postElement in post {
                dictionaryElements.append(postElement.toDictionary())
            }
            dictionary["post"] = dictionaryElements
        }
        if title != nil{
            dictionary["title"] = title
        }
        if profileImage != nil{
            dictionary["profile_image"] = profileImage
        }
        if postImage != nil{
            dictionary["post_image"] = postImage
        }
        if isVideo != nil{
            dictionary["is_video"] = isVideo
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         cntLike = aDecoder.decodeObject(forKey: "cnt_like") as? Int
         latitude = aDecoder.decodeObject(forKey: "latitude") as? Double
         likeStatus = aDecoder.decodeObject(forKey: "like_status") as? Int
         longitude = aDecoder.decodeObject(forKey: "longitude") as? Double
         postDate = aDecoder.decodeObject(forKey: "post_date") as? String
         postDescription = aDecoder.decodeObject(forKey: "post_description") as? String
         postId = aDecoder.decodeObject(forKey: "post_id") as? Int
         postImages = aDecoder.decodeObject(forKey: "post_images") as? [ClsPostListPostImage]
         postTag = aDecoder.decodeObject(forKey: "post_tag") as? String
         postToken = aDecoder.decodeObject(forKey: "post_token") as? String
         saveStatus = aDecoder.decodeObject(forKey: "save_status") as? Int
         userToken = aDecoder.decodeObject(forKey: "user_token") as? String
         username = aDecoder.decodeObject(forKey: "username") as? String
         post = aDecoder.decodeObject(forKey: "post") as? [ClsPostListModel]
         title = aDecoder.decodeObject(forKey: "title") as? String
         profileImage = aDecoder.decodeObject(forKey: "profile_image") as? String
         postImage = aDecoder.decodeObject(forKey: "post_image") as? String
         isVideo = aDecoder.decodeObject(forKey: "is_video") as? Int
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    public func encode(with aCoder: NSCoder)
    {
        if cntLike != nil{
            aCoder.encode(cntLike, forKey: "cnt_like")
        }
        if latitude != nil{
            aCoder.encode(latitude, forKey: "latitude")
        }
        if likeStatus != nil{
            aCoder.encode(likeStatus, forKey: "like_status")
        }
        if longitude != nil{
            aCoder.encode(longitude, forKey: "longitude")
        }
        if postDate != nil{
            aCoder.encode(postDate, forKey: "post_date")
        }
        if postDescription != nil{
            aCoder.encode(postDescription, forKey: "post_description")
        }
        if postId != nil{
            aCoder.encode(postId, forKey: "post_id")
        }
        if postImages != nil{
            aCoder.encode(postImages, forKey: "post_images")
        }
        if postTag != nil{
            aCoder.encode(postTag, forKey: "post_tag")
        }
        if postToken != nil{
            aCoder.encode(postToken, forKey: "post_token")
        }
        if saveStatus != nil{
            aCoder.encode(saveStatus, forKey: "save_status")
        }
        if userToken != nil{
            aCoder.encode(userToken, forKey: "user_token")
        }
        if username != nil{
            aCoder.encode(username, forKey: "username")
        }
        if post != nil{
            aCoder.encode(post, forKey: "post")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if profileImage != nil{
            aCoder.encode(profileImage, forKey: "profile_image")
        }
        if postImage != nil{
            aCoder.encode(profileImage, forKey: "post_image")
        }
        if isVideo != nil{
            aCoder.encode(isVideo, forKey: "is_video")
        }

    }

}
