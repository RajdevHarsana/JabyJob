//
//import Foundation
//
//// MARK: - OtherUserInfoModal
//struct OtherUserInfoModal: Codable {
//    var status: Bool?
//    var message: String?
//    var data: UserClass?
//    var country: [CountryElement]?
//    var skill: [Skill]?
//    var video: [Video]?
//}
//
//// MARK: - CountryElement
//struct CountryElement: Codable {
//    var countryID: Int?
//    var country: SkillClass?
//
//    enum CodingKeys: String, CodingKey {
//        case countryID = "country_id"
//        case country
//    }
//}
//
//// MARK: - SkillClass
//struct SkillClass: Codable {
//    var id: Int?
//    var name: String?
//}
//
//// MARK: - DataClass
//struct UserClass: Codable {
//    var user: User?
//}
//
//// MARK: - User
//struct User: Codable {
//    var id: Int?
//    var fullName: String?
//    var image: String?
//    var email, username: String?
//    var countryID, phone, categoryID, roleID: Int?
//    var cv: String?
//    var cvThumbnail: String?
//    var deviceToken: String?
//    var deviceType, otp, verifiedStatus, status: Int?
//    var subscriptionStatus, isNotification: Int?
//    var fbID, appleID, googleID, createdAt: String?
//    var updatedAt: String?
//    var category: Category?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case fullName = "full_name"
//        case image, email, username
//        case countryID = "country_id"
//        case phone
//        case categoryID = "category_id"
//        case roleID = "role_id"
//        case cv
//        case cvThumbnail = "cv_thumbnail"
//        case deviceToken = "device_token"
//        case deviceType = "device_type"
//        case otp
//        case verifiedStatus = "verified_status"
//        case status
//        case subscriptionStatus = "subscription_status"
//        case isNotification = "is_notification"
//        case fbID = "fb_id"
//        case appleID = "apple_id"
//        case googleID = "google_id"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case category
//    }
//}
//
//// MARK: - Category
//struct Category: Codable {
//    var id: Int?
//    var title: String?
//}
//
//// MARK: - Skill
//struct Skill: Codable {
//    var skillID: Int?
//    var skill: SkillClass?
//
//    enum CodingKeys: String, CodingKey {
//        case skillID = "skill_id"
//        case skill
//    }
//}
//
//// MARK: - Video
//struct Video: Codable {
//    var id: Int?
//    var name, thumbnail: String?
//    var userID, status: Int?
//    var createdAt, updatedAt: String?
//    var savedStatus: Bool?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, thumbnail
//        case userID = "user_id"
//        case status
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let otherUserInfoModal = try? newJSONDecoder().decode(OtherUserInfoModal.self, from: jsonData)

import Foundation

// MARK: - OtherUserInfoModal
struct OtherUserInfoModal: Codable {
    var status: Bool?
    var message: String?
    var data: UserClass?
    var country: [CountryElement]?
    var skill: [Skill]?
    var video: [Video]?
}

// MARK: - CountryElement
struct CountryElement: Codable {
    var countryID: Int?
    var country: SkillClass?

    enum CodingKeys: String, CodingKey {
        case countryID = "country_id"
        case country
    }
}

// MARK: - SkillClass
struct SkillClass: Codable {
    var id: Int?
    var name: String?
}

// MARK: - DataClass
struct UserClass: Codable {
    var user: User?
}

// MARK: - User
struct User: Codable {
    var id: Int?
    var fullName: String?
    var image: String?
    var email, username: String?
    var countryID, phone, categoryID, roleID: Int?
    var cv: String?
    var cvThumbnail: String?
    var deviceToken: String?
    var deviceType, otp, verifiedStatus, status: Int?
    var subscriptionStatus, isNotification: Int?
    var fbID, appleID, googleID, createdAt: String?
    var updatedAt: String?
    var category: Category?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case image, email, username
        case countryID = "country_id"
        case phone
        case categoryID = "category_id"
        case roleID = "role_id"
        case cv
        case cvThumbnail = "cv_thumbnail"
        case deviceToken = "device_token"
        case deviceType = "device_type"
        case otp
        case verifiedStatus = "verified_status"
        case status
        case subscriptionStatus = "subscription_status"
        case isNotification = "is_notification"
        case fbID = "fb_id"
        case appleID = "apple_id"
        case googleID = "google_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case category
    }
}

// MARK: - Category
struct Category: Codable {
    var id: Int?
    var title: String?
}

// MARK: - Skill
struct Skill: Codable {
    var skillID: Int?
    var skill: SkillClass?

    enum CodingKeys: String, CodingKey {
        case skillID = "skill_id"
        case skill
    }
}

// MARK: - Video
struct Video: Codable {
    var id: Int?
    var name, thumbnail: String?
    var userID, status: Int?
    var createdAt, updatedAt: String?
    var savedStatus: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, thumbnail
        case userID = "user_id"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case savedStatus = "saved_status"
    }
}
