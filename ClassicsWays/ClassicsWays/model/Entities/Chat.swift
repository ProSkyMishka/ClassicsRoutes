//
//  Chat.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 02.03.2024.
//

import Foundation

struct Chat: Identifiable, Codable {
    let id: String
    var users: [String]
    let messages: [String]
    let routeSuggest: String
    let last: String
}
