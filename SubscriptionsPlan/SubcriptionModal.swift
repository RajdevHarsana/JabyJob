//
//  SubcriptionModal.swift
//  JabyJob
//
//  Created by DMG swift on 08/02/22.
//

import Foundation


struct SubscriptionModal: Codable {
    let status: Bool?
    let message, currency: String?
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int?
    let title: String?
    let price, duration: Int?
}


