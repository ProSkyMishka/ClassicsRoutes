//
//  ChatFunctions.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 02.03.2024.
//

import Foundation

extension NetworkService {
    func getAllChats() async throws -> [ChatDate] {
        guard let url = URL(string: "\(localhost)\(APIMethod.getAllChats.rawValue)")
        else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue(Constants.applicationJSON, forHTTPHeaderField: Constants.contentType)
        request.httpMethod = HTTPMethod.get.rawValue
        let chatResponce = try await URLSession.shared.data(for: request)
        let chatData = chatResponce.0
        let decoder = JSONDecoder()
        let chats = try decoder.decode([Chat].self, from: chatData)
        var chatsDate: [ChatDate] = []
        for chat in chats {
            if chat.users.contains(Vars.user!.id) {
                let chatDate = ChatDate(id: chat.id, users: chat.users, messages: chat.messages, last: Constants.format.date(from: chat.last)!, routeSuggest: chat.routeSuggest)
                chatsDate.append(chatDate)
            }
        }
        return chatsDate
    }
    
    func getChat(id: String) async throws -> ChatDate {
        let idUrl = "/\(id)"
        guard let url = URL(string: "\(localhost)\(APIMethod.getAllChats.rawValue)\(idUrl)")
        else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue(Constants.applicationJSON, forHTTPHeaderField: Constants.contentType)
        request.httpMethod = HTTPMethod.get.rawValue
        let chatResponce = try await URLSession.shared.data(for: request)
        let chatData = chatResponce.0
        let decoder = JSONDecoder()
        let chat = try decoder.decode(Chat.self, from: chatData)
        let chatDate = ChatDate(id: chat.id, users: chat.users, messages: chat.messages, last: Constants.format.date(from: chat.last)!, routeSuggest: chat.routeSuggest)
        return chatDate
    }
    
    func updateChat(id: String,
                    users: [String],
                    messages: [String],
                    last: String,
                    routeSuggest: String) async throws -> ChatDate {
        let dto = chatDTO(users: users, messages: messages, last: last, routeSuggest: routeSuggest)
        let idUrl = "/\(id)"
        guard let url = URL(string: "\(localhost)\(APIMethod.getAllChats.rawValue)\(idUrl)")
        else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue(Constants.applicationJSON, forHTTPHeaderField: Constants.contentType)
        request.httpMethod = HTTPMethod.put.rawValue
        let encoder = JSONEncoder()
        let data = try encoder.encode(dto)
        request.httpBody = data
        
        let chatResponce = try await URLSession.shared.data(for: request)
        let chatData = chatResponce.0
        let decoder = JSONDecoder()
        let chat = try decoder.decode(Chat.self, from: chatData)
        let chatDate = ChatDate(id: chat.id, users: chat.users, messages: chat.messages, last: Constants.format.date(from: chat.last)!, routeSuggest: chat.routeSuggest)
        return chatDate
    }
    
    func createChat(users: [String],
                    messages: [String],
                    last: String) async throws -> Chat {
        let dto = chatDTO(users: users, messages: messages, last: last, routeSuggest: Constants.nilString)
        guard let url = URL(string: "\(localhost)\(APIMethod.getAllChats.rawValue)")
        else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue(Constants.applicationJSON, forHTTPHeaderField: Constants.contentType)
        request.httpMethod = HTTPMethod.post.rawValue
        let encoder = JSONEncoder()
        let data = try encoder.encode(dto)
        request.httpBody = data
        let chatResponce = try await URLSession.shared.data(for: request)
        let chatData = chatResponce.0
        let decoder = JSONDecoder()
        let chat = try decoder.decode(Chat.self, from: chatData)
        
        return chat
    }
    
    func deleteChat(id: String) async throws {
        let idUrl = "/\(id)"
        guard let url = URL(string: "\(localhost)\(APIMethod.getAllChats.rawValue)\(idUrl)")
        else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue(Constants.applicationJSON, forHTTPHeaderField: Constants.contentType)
        request.httpMethod = HTTPMethod.delete.rawValue
        _ = try await URLSession.shared.data(for: request)
    }
}

struct chatDTO: Encodable {
    let users: [String]
    let messages: [String]
    let last: String
    let routeSuggest: String
}
