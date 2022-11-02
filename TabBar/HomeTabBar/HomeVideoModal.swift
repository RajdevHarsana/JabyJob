//
//  HomeVideoModal.swift
//  JabyJob
//
//  Created by DMG swift on 25/02/22.
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let homeVideoModal = try? newJSONDecoder().decode(HomeVideoModal.self, from: jsonData)

import Foundation

// MARK: - HomeVideoModal
struct HomeVideoModal: Codable {
    var status: Bool?
    var message: String?
    var totalPage : Int?
    var lastPage : Int?
    
    var data: [VideoUrl]?
}

// MARK: - Datum
struct VideoUrl:  Codable {
        let videoID: Int
        let video: String
        let videoThumbnail: String
        let userID: Int
        let username: String
        let skills: [String]
        let countryID: Int
        let dateTime: String
        let notfound, report: Bool
        let category, country: String
        var saveVideoStatus: Bool
        enum CodingKeys: String, CodingKey {
            case videoID = "video_id"
            case video
            case videoThumbnail = "video_thumbnail"
            case userID = "user_id"
            case username, skills
            case countryID = "country_id"
            case dateTime = "date_time"
            case notfound, report, category, country
            case saveVideoStatus = "save_video_status"
        }
}


