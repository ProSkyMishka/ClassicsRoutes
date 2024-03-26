//
//  RoutesController.swift
//
//
//  Created by Михаил Прозорский on 15.02.2024.
//

import Fluent
import Vapor

struct RoutesController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let waysGroup = routes.grouped("routes")
        waysGroup.get(use: getAllHandler)
        waysGroup.get(":id", use: getHandler)
        
//        let basicMW = User.authenticator()
//        let guardMW = User.guardMiddleware()
//        let protected = waysGroup.grouped(basicMW, guardMW)
//        protected.post(use: createHadler)
//        protected.delete(":id", use: deleteHandler)
//        protected.put(":id", use: updateHandler)
        waysGroup.post(use: createHadler)
        waysGroup.delete(":id", use: deleteHandler)
        waysGroup.put(":id", use: updateHandler)
    }
    
    func createHadler(_ req: Request) async throws -> Route {
        guard let way = try? req.content.decode(Route.self) else {
            throw Abort(.custom(code: 499, reasonPhrase: "Не получилось декодировать контент в модель продукта"))
        }
        
        try await way.save(on: req.db)
        
        return way
    }
    
    func getAllHandler(_ req: Request) async throws -> [Route] {
        let ways = try await Route.query(on: req.db).all()
        return ways
    }
    
    func getHandler(_ req: Request) async throws -> Route {
        guard let way = try await Route.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return way
    }
    
    func deleteHandler(_ req: Request) async throws -> HTTPStatus {
        guard let way = try await Route.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await way.delete(on: req.db)
        
        return .ok
    }
    
    func updateHandler(_ req: Request) async throws -> Route {
        guard let way = try await Route.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let wayUpdate = try req.content.decode(Route.self)
        
        way.avatar = wayUpdate.avatar
        way.person = wayUpdate.person
        way.name = wayUpdate.name
        way.description = wayUpdate.description
        way.theme = wayUpdate.theme
        way.time = wayUpdate.time
        way.start = wayUpdate.start
        way.pictures = wayUpdate.pictures
        way.raiting = wayUpdate.raiting
        way.locations = wayUpdate.locations
        
        try await way.save(on: req.db)
        
        return way
    }
}
