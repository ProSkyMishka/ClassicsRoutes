//
//  MessageFunctions.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 02.03.2024.
//

import Foundation

extension NetworkService {
    func getAllMessages() async throws -> [MessageDate] {
        guard let url = URL(string: "\(localhost)\(APIMethod.getAllMessages.rawValue)")
        else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let messageResponce = try await URLSession.shared.data(for: request)
        let messageData = messageResponce.0
        let decoder = JSONDecoder()
        let messages = try decoder.decode([Message].self, from: messageData)
        var messagesDate: [MessageDate] = []
        for message in messages {
            if Vars.chat!.messages.contains(message.id) {
                let messageDate = MessageDate(id: message.id, user: message.user, route: message.route, routeSuggest: message.routeSuggest, time: Constants.format.date(from: message.time)!, text: message.text)
                messagesDate.append(messageDate)
            }
        }
        return messagesDate
    }
    
    func createMessage(user: String,
                       route: String,
                       routeSuggest: String,
                       time: String,
                       text: String) async throws -> MessageDate {
        let dto = MessageDTO(user: user, route: route, routeSuggest: routeSuggest, time: time, text: text)
        guard let url = URL(string: "\(localhost)\(APIMethod.getAllMessages.rawValue)")
        else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let encoder = JSONEncoder()
        let data = try encoder.encode(dto)
        request.httpBody = data
        let messageResponce = try await URLSession.shared.data(for: request)
        let messageData = messageResponce.0
        let decoder = JSONDecoder()
        let message = try decoder.decode(Message.self, from: messageData)
        let messageDate = MessageDate(id: message.id, user: message.user, route: message.route, routeSuggest: message.routeSuggest, time: Constants.format.date(from: message.time)!, text: message.text)
        return messageDate
    }
}

struct MessageDTO: Encodable {
    let user: String
    let route: String
    let routeSuggest: String
    let time: String
    let text: String
}
