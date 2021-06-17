//
//	ClsTagListModel.swift
//
//	Create by Dreamworld on 11/1/2021
//	Copyright © 2021. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ClsTagListModel : NSObject, NSCoding{

	var tagId : Int!
	var tagName : String!


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
		tagId = dictionary["tag_id"] as? Int == nil ? 0 : dictionary["tag_id"] as? Int
		tagName = dictionary["tag_name"] as? String == nil ? "" : dictionary["tag_name"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if tagId != nil{
			dictionary["tag_id"] = tagId
		}
		if tagName != nil{
			dictionary["tag_name"] = tagName
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         tagId = aDecoder.decodeObject(forKey: "tag_id") as? Int
         tagName = aDecoder.decodeObject(forKey: "tag_name") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    public func encode(with aCoder: NSCoder) 
	{
		if tagId != nil{
			aCoder.encode(tagId, forKey: "tag_id")
		}
		if tagName != nil{
			aCoder.encode(tagName, forKey: "tag_name")
		}

	}

}