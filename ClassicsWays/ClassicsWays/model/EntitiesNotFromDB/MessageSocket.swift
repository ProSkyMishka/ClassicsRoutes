//
//  MessageSocket.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 29.03.2024.
//

import Foundation

struct MessageSocket: Identifiable, Codable {
    var chatId: String
    let id: String
    var user: String
    let route: String
    let time: Date
    let text: String
}