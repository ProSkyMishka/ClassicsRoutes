//
//  CreateMessage.swift
//
//
//  Created by Михаил Прозорский on 02.03.2024.
//

import Fluent
import Vapor

struct CreateMessage: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        let schema = database.schema("messages")
            .id()
            .field("user", .string, .required)
            .field("text", .string, .required)
            .field("time", .string, .required)
            .field("route", .string, .required)
        
        try await schema.create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("messages").delete()
    }
}
