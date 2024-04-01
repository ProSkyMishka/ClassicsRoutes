//
//  User.swift
//  Class'Ways
//
//  Created by Михаил Прозорский on 23.02.2024.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let name: String
    let date: String
    let avatar: String
    let routes: [String]
    let role: String
    let likes: [String]
    let themes: [Int]
}
