//
//  AIServiceConstants.swift
//  Swift3CodeStructure
//
//  Created by Ravi Alagiya on 25/11/2016.
//  Copyright © 2016 Ravi Alagiya. All rights reserved.
//

import Foundation

//MARK:- BASE URL

let URL_BASE                    = "http://159.65.225.170/api/gramspot/dev"
let URL_POST_PIC                = "http://159.65.225.170/api/gramspot/app_images/post_images/"
let URL_USER_PROFILE_IMAGES     = "http://159.65.225.170/api/gramspot/app_images/user_profile/"

let URL_REGISTRATION = getFullUrl("/Service.php?Service=registration")
let URL_LOGIN = getFullUrl("/Service.php?Service=login")
let URL_CHECK_FB_ID = getFullUrl("/Service.php?Service=checkFbID")
let URL_FORGOT_PASSWORD = getFullUrl("/Service.php?Service=forgotPassword")
let URL_CHANGE_PASSWORD_VERIFY = getFullUrl("/Service.php?Service=changePasswordWithVerifyCode")
let URL_ADD_NEW_POST = getFullUrl("/Service.php?Service=addNewPost")
let URL_EDIT_POST = getFullUrl("/Service.php?Service=editUserPost")
let URL_DELETE_POST = getFullUrl("/Service.php?Service=deleteUserPost")
let URL_GET_POST_LIST = getFullUrl("/Service.php?Service=getPostList")
let URL_GET_RECOMMADED_POST_LIST = getFullUrl("/Service.php?Service=getRecommandedPostList")
let URL_GET_NEAR_BY_POST_LIST = getFullUrl("/Service.php?Service=getNearByPostList")
let URL_UPDATE_LIKE_STATUS = getFullUrl("/Service.php?Service=updateLikeUnlikeStatus")
let URL_UPDATE_SAVE_STATUS = getFullUrl("/Service.php?Service=updateSaveStatus")
let URL_ADD_NEW_POST_WITH_MULTIPLE_IMAGE = getFullUrl("/Service.php?Service=addNewPostWithMultipleImages")
let URL_GET_ALL_COMMENT = getFullUrl("/Service.php?Service=getAllComment")
let URL_UPDATE_COMMENT_LIKE_STATUS = getFullUrl("/Service.php?Service=updateCommentLikeUnlikeStatus")
let URL_ADD_COMMENT = getFullUrl("/Service.php?Service=addCommentOnPost")
let URL_DELETE_COMMENT = getFullUrl("/Service.php?Service=deleteCommentOnPost")
let URL_EDIT_COMMENT = getFullUrl("/Service.php?Service=editCommentOnPost")
let URL_EDIT_POST_WITH_MULTIPLE_IMAGE = getFullUrl("/Service.php?Service=editPostWithMultipleImages")
let URL_DELETE_SINGLE_POST = getFullUrl("/Service.php?Service=deleteSinglePostImage")
let URL_USER_PROFILE = getFullUrl("/Service.php?Service=getUserDetailsFromId")
let URL_UPDATE_USER_DETAIL = getFullUrl("/Service.php?Service=updateUserDetails")
let URL_CHANGE_PASSWORD = getFullUrl("/Service.php?Service=changePassword")
let URL_GET_FOLLOWER_LIST = getFullUrl("/Service.php?Service=getFollowingList")
let URL_USER_FOLLOWER = getFullUrl("/Service.php?Service=followUnfollowUser")
let URL_ALL_USER = getFullUrl("/Service.php?Service=getAllUserlist")
let URL_USER_POST = getFullUrl("/Service.php?Service=getUserPost")
let URL_USER_POST_FOR_MAP = getFullUrl("/Service.php?Service=getUserAllPostForMap")
let URL_USER_POST_ALL_IMAGES = getFullUrl("/Service.php?Service=getUserAllPostImages")
let URL_CHANGE_USER_PROFILE = getFullUrl("/Service.php?Service=changeProfilePicture")
let URL_UPDATE_DEVICE_TOKEN = getFullUrl("/Service.php?Service=updateDeviceToken")
let URL_RESET_BADGE = getFullUrl("/Service.php?Service=resetBadges")
let URL_LOGOUT = getFullUrl("/Service.php?Service=logout")
let URL_UPDATE_NOTIFICATION_SETTING = getFullUrl("/Service.php?Service=updateUserNotificationSetting")
let URL_UPDATE_PRIVACY_SETTING = getFullUrl("/Service.php?Service=updateUserPrivacySetting")
let URL_GET_NOTIFICATION = getFullUrl("/Service.php?Service=getNotification")
let URL_POST_DETAIL = getFullUrl("/Service.php?Service=getPostDetail")
let URL_GET_USER_SAVE_POST_LIST = getFullUrl("/Service.php?Service=getUserSavePostList")
let URL_GET_TAG_LIST = getFullUrl("/Service.php?Service=getTagList")
let URL_GET_DISCOVER_POST_LIST = getFullUrl("/Service.php?Service=getDiscoverPostImages")
let URL_GET_RECENT_POST_LIST = getFullUrl("/Service.php?Service=getRecentSightList")
let URL_GET_SEARCH_POST_LIST = getFullUrl("/Service.php?Service=getSearchPostList")

//MARK:- FULL URL
func getFullUrl(_ urlEndPoint : String) -> String {
    return URL_BASE + urlEndPoint
}

