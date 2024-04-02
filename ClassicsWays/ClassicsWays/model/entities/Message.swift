//
//  Message.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 02.03.2024.
//

import Foundation

struct Message: Identifiable, Codable {
    let id: String
    let user: String
    let route: String
    let time: String
    let text: String
}

