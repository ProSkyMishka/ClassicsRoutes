//
//  UserFunctions.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 02.03.2024.
//

import Foundation

extension NetworkService {
    func getAllUsers() async throws -> [User] {
        guard let url = URL(string: "\(localhost)\(APIMethod.getAllUsers.rawValue)")
        else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let userResponce = try await URLSession.shared.data(for: request)
        let userData = userResponce.0
        let decoder = JSONDecoder()
        let users = try decoder.decode([User].self, from: userData)
        return users
    }
    
    func updateUser(id: String,
                     name: String,
                     email: String,
                     date: String,
                     avatar: String,
                     routes: [String],
                     role: String,
                     likes: [String],
                     themes: [Int],
                     chats: [String],
                     password: String) async throws -> User {
        let dto = UserDTOAll(name: name, email: email, date: date, avatar: avatar, routes: routes, role: role, likes: likes, themes: themes, chats: chats, password: password)
        let idUrl = "/\(id)"
        guard let url = URL(string: "\(localhost)\(APIMethod.getAllUsers.rawValue)\(idUrl)")
        else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let encoder = JSONEncoder()
        let data = try encoder.encode(dto)
        request.httpBody = data
        let userResponce = try await URLSession.shared.data(for: request)
        let userData = userResponce.0
        let decoder = JSONDecoder()
        let user = try decoder.decode(User.self, from: userData)
        return user
    }
    
    func createUser(name: String,
                     themes: [Int],
                     password: String) async throws -> User {
        let dto = UserDTOAll(name: name, email: "", date: Constants.format.string(from: Date.now), avatar: "withOutAvatar.png", routes: [], role: "user", likes: [], themes: themes, chats: [], password: password)
        guard let url = URL(string: "\(localhost)\(APIMethod.getAllUsers.rawValue)")
        else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let encoder = JSONEncoder()
        let data = try encoder.encode(dto)
        request.httpBody = data
        let userResponce = try await URLSession.shared.data(for: request)
        let userData = userResponce.0
        let decoder = JSONDecoder()
        let user = try decoder.decode(User.self, from: userData)
        return user
    }
}

struct UserDTOAll: Encodable {
    let name: String
    let email: String
    let date: String
    let avatar: String
    let routes: [String]
    let role: String
    let likes: [String]
    let themes: [Int]
    let chats: [String]
    let password: String
}
