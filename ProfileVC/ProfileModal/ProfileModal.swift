

import Foundation

// MARK: - ProfileModal
struct ProfileModal: Codable {
    var status: Bool?
    var message: String?
    var data: ProfileData?
}

// MARK: - DataClass
struct ProfileData: Codable {
    var id: Int?
    var fullName: String?
    var image: String?
    var email, username: String?
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
}
