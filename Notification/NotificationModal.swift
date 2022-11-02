struct NotificationModal: Codable {
    var status: Bool?
    var message: String?
    var data: NotificationData?
}

// MARK: - DataClass
struct NotificationData: Codable {
    var notification: [NotificationList]?
}

// MARK: - Notification
struct NotificationList: Codable {
    var id, userID: Int?
    var message, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case message
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
