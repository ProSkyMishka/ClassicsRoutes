//
//  MessageDate.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 05.03.2024.
//

import Foundation

struct MessageDate: Identifiable, Codable {
    let id: String
    let user: String
    let route: String
    let time: Date
    let text: String
}
