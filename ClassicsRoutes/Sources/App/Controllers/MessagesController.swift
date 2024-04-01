//
//  MessagesController.swift
//
//
//  Created by Михаил Прозорский on 02.03.2024.
//

import Fluent
import Vapor

struct MessagesController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let messagesGroup = routes.grouped("messages")
        messagesGroup.get(use: getAllHandler)
        messagesGroup.get(":id", use: getHandler)
        
//        let basicMW = User.authenticator()
//        let guardMW = User.guardMiddleware()
//        let protected = messagesGroup.grouped(basicMW, guardMW)
//        protected.post(use: createHadler)
//        protected.delete(":id", use: deleteHandler)
//        protected.put(":id", use: updateHandler)
        messagesGroup.post(use: createHadler)
        messagesGroup.delete(":id", use: deleteHandler)
        messagesGroup.put(":id", use: updateHandler)
    }
    
    func createHadler(_ req: Request) async throws -> Message {
        guard let message = try? req.content.decode(Message.self) else {
            throw Abort(.custom(code: 499, reasonPhrase: "Не получилось декодировать контент в модель продукта"))
        }
        
        try await message.save(on: req.db)
        
        return message
    }
    
    func getAllHandler(_ req: Request) async throws -> [Message] {
        let messages = try await Message.query(on: req.db).all()
        return messages
    }
    
    func getHandler(_ req: Request) async throws -> Message {
        guard let message = try await Message.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return message
    }
    
    func deleteHandler(_ req: Request) async throws -> HTTPStatus {
        guard let message = try await Message.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await message.delete(on: req.db)
        
        return .ok
    }
    
    func updateHandler(_ req: Request) async throws -> Message {
        guard let message = try await Message.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let messageUpdate = try req.content.decode(Message.self)
        
        message.user = messageUpdate.user
        message.text = messageUpdate.text
        message.time = messageUpdate.time
        message.route = messageUpdate.route
        
        try await message.save(on: req.db)
        
        return message
    }
}
