//
//  MessageSocket.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 29.03.2024.
//

import Foundation

struct MessageSocket: Identifiable, Codable {
    let chatId: String
    let id: String
    let user: String
    let route: String
    let routeSuggest: String
    let time: Date
    let text: String
}
