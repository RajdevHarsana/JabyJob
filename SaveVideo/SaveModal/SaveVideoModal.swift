
//

import Foundation

struct SaveVideoModal: Codable {
    var status: Bool?
    var message: String?
    var data: [SaveData]?
}

// MARK: - Datum
struct SaveData: Codable {
    var videoID: Int?
    var video: String?
    var videoThumbnail: String?
    var userID: Int?
    var username: String?
    var skills: [String]?
    var saveVideoStatus: Bool?
    var dateTime: String?

    enum CodingKeys: String, CodingKey {
        case videoID = "video_id"
        case video
        case videoThumbnail = "video_thumbnail"
        case userID = "user_id"
        case username, skills
        case saveVideoStatus = "save_video_status"
        case dateTime = "date_time"
    }
}
