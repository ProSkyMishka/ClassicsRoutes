//
//  Route.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 28.02.2024.
//

import Foundation

struct Route: Identifiable, Codable {
    let id: String
    let avatar: String
    let person: String
    let name: String
    let description: String
    let theme: Int
    let time: Int
    let start: String
    let pictures: [String]
    let raiting: [String]
    let locations: [String]
}
