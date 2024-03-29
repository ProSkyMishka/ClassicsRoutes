//
//  NetworkService.swift
//  Class'Ways
//
//  Created by Михаил Прозорский on 23.02.2024.
//

import Foundation

class NetworkService {
    static let shared = NetworkService(); private init() { }
    
    let localhost = "http://127.0.0.1:8080"
    
    func setUpWebSocket() async throws -> URLSessionWebSocketTask {
        let urlSession = URLSession(configuration: .default)
        let webSocketTask = urlSession.webSocketTask(with: URL(string: "ws://127.0.0.1:8080/echo")!)
        webSocketTask.resume()
        return webSocketTask
    }
    
    func sendMessages(webSocketTask: URLSessionWebSocketTask, message: URLSessionWebSocketTask.Message) async throws {
        webSocketTask.send(message) { error in
            if let error = error {
                print("websocket couldn't send message: \(error.localizedDescription)")
            }
        }
    }
    
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
