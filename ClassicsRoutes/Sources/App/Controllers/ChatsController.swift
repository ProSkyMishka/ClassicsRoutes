//
//  ChatsController.swift
//
//
//  Created by Михаил Прозорский on 02.03.2024.
//

import Fluent
import Vapor

struct ChatsController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let chatsGroup = routes.grouped("chats")
        chatsGroup.get(use: getAllHandler)
        chatsGroup.get(":id", use: getHandler)
        
//        let basicMW = User.authenticator()
//        let guardMW = User.guardMiddleware()
//        let protected = chatsGroup.grouped(basicMW, guardMW)
//        protected.post(use: createHadler)
//        protected.delete(":id", use: deleteHandler)
//        protected.put(":id", use: updateHandler)
        chatsGroup.post(use: createHadler)
        chatsGroup.delete(":id", use: deleteHandler)
        chatsGroup.put(":id", use: updateHandler)
    }
    
    func createHadler(_ req: Request) async throws -> Chat {
        guard let chat = try? req.content.decode(Chat.self) else {
            throw Abort(.custom(code: 499, reasonPhrase: "Не получилось декодировать контент в модель продукта"))
        }
        
        try await chat.save(on: req.db)
        
        return chat
    }
    
    func getAllHandler(_ req: Request) async throws -> [Chat] {
        let chats = try await Chat.query(on: req.db).all()
        return chats
    }
    
    func getHandler(_ req: Request) async throws -> Chat {
        guard let chat = try await Chat.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return chat
    }
    
    func deleteHandler(_ req: Request) async throws -> HTTPStatus {
        guard let chat = try await Chat.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await chat.delete(on: req.db)
        
        return .ok
    }
    
    func updateHandler(_ req: Request) async throws -> Chat {
        guard let chat = try await Chat.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let chatUpdate = try req.content.decode(Chat.self)
        
        chat.messages = chatUpdate.messages
        chat.users = chatUpdate.users
        chat.last = chatUpdate.last
        chat.routeSuggest = chatUpdate.routeSuggest
        
        try await chat.save(on: req.db)
        
        return chat
    }
}
