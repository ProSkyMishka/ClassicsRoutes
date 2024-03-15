//
//  CreateRoute.swift
//
//
//  Created by Михаил Прозорский on 14.02.2024.
//

import Fluent
import Vapor

struct CreateRoute: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        let schema = database.schema("routes")
            .id()
            .field("avatar", .string, .required)
            .field("person", .string)
            .field("name", .string, .required)
            .field("description", .string, .required)
            .field("theme", .int, .required)
            .field("time", .int, .required)
            .field("start", .string, .required)
            .field("pictures", .array(of: .string), .required)
            .field("raiting", .array(of: .string))
            .field("locations", .array(of: .string), .required)
            .unique(on: "name")
        
        try await schema.create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("routes").delete()
    }
}
