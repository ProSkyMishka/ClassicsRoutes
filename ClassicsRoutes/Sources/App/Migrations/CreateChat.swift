//
//  CreateChat.swift
//
//
//  Created by Михаил Прозорский on 02.03.2024.
//

import Fluent
import Vapor

struct CreateChat: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        let schema = database.schema("chats")
            .id()
            .field("users", .array(of: .string), .required)
            .field("messages", .array(of: .string), .required)
            .field("last", .string, .required)
            .field("routeSuggest", .string, .required)
        
        try await schema.create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("chats").delete()
    }
}
