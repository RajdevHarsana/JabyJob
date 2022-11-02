//
//  UserModal.swift
//  JabyJob
//
//  Created by DMG swift on 07/02/22.
//

import Foundation

//class UserDataModal{
//    var token : String = ""
//    var message: String = ""
//}



// MARK: - UserModal
struct UserModal: Codable {
    var status: Bool?
    var message: String?
    var data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    var id: Int?
    var fullName, image, email, username: String?
    var countryID, phone, categoryID, roleID: Int?
    var cv, deviceToken: String?
    var deviceType, otp, verifiedStatus, status: Int?
    var subscriptionStatus, isNotification: Int?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case image, email, username
        case countryID = "country_id"
        case phone
        case categoryID = "category_id"
        case roleID = "role_id"
        case cv
        case deviceToken = "device_token"
        case deviceType = "device_type"
        case otp
        case verifiedStatus = "verified_status"
        case status
        case subscriptionStatus = "subscription_status"
        case isNotification = "is_notification"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    public static func getUserData() -> [UserModal]?{
           let placeData = UserDefaults.standard.data(forKey: "user")
           let placeArray = try! JSONDecoder().decode([UserModal].self, from: placeData!)
           return placeArray
       }
}

//class UserModal: Codable {
//
//    var category_id: Int
//    var country_id: Int
//    var created_at : String
//    var cv : String
//    var device_token : String
//    var email : String
//    var full_name : String
//    var id : Int
//    var image
//
//}
//
//
//Optional({
//    data =     {
//        "category_id" = 1;
//        "country_id" = 1;
//        "created_at" = "2022-02-07T07:26:48.000000Z";
//        cv = "";
//        "device_token" = sfdfds;
//        "device_type" = 2;
//        email = "sumit@gmail.com";
//        "full_name" = submit;
//        id = 7;
//        image = "";
//        "is_notification" = 1;
//        otp = 2759;
//        phone = 1231231231;
//        "role_id" = 2;
//        status = 1;
//        "subscription_status" = 2;
//        "updated_at" = "2022-02-07T07:26:48.000000Z";
//        username = lunar;
//        "verified_status" = 2;
//    };
//    message = "Your account has been registered successfully.";
//    status = 1;
//})
