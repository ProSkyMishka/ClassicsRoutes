//
//  NetworkService.swift
//  Class'Ways
//
//  Created by Михаил Прозорский on 23.02.2024.
//

import Foundation
import UIKit

class NetworkService {
    static let shared = NetworkService(); private init() { }
    
    let localhost = "http://127.0.0.1:8080"
    let localSocketHost = "ws://127.0.0.1:8080/echo"
    var webSocketTask: URLSessionWebSocketTask?
    
    func auth(name: String, password: String) async throws -> User {
        let dto = UserDTO(name: name, password: password)
        guard let url = URL(string: "\(localhost)\(APIMethod.auth.rawValue)")
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

struct UserDTO: Encodable {
    let name: String
    let password: String
}

enum APIMethod: String {
    case auth = "/users/auth"
    case getAllUsers = "/users"
    case getAllRoutes = "/routes"
    case getAllMessages = "/messages"
    case getAllChats = "/chats"
}

enum NetworkError: Error {
    case badURL
    case badToken
}
