//
//  ChatDate.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 05.03.2024.
//

import Foundation

struct ChatDate: Identifiable, Codable {
    let id: String
    var users: [String]
    var messages: [String]
    let last: Date
    let routeSuggest: String
}
