//
//  ReportModal.swift
//  JabyJob
//
//  Created by DMG swift on 08/03/22.
//

import Foundation
struct ReportModal: Codable {
    var status: Bool?
    var message: String?
    var data: [ResonData]?
}

// MARK: - Datum
struct ResonData: Codable {
    var id: Int?
    var reason: String?
    var status: Int?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, reason, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
