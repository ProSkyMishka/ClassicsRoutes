//
//  CreateUser.swift
//
//
//  Created by Михаил Прозорский on 19.02.2024.
//

import Fluent
import Vapor

struct CreateUser: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        let schema = database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("password", .string, .required)
            .field("date", .string, .required)
            .field("avatar", .string)
            .field("routes", .array(of: .string))
            .field("role", .string, .required)
            .field("likes", .array(of: .string))
            .field("themes", .array(of: .int), .required)
            .unique(on: "name")
        
        try await schema.create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("users").delete()
    }
}
