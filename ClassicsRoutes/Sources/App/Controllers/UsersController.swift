//
//  UsersController.swift
//  
//
//  Created by Михаил Прозорский on 19.02.2024.
//

import Fluent
import Vapor

struct UsersController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let usersGroup = routes.grouped("users")
        usersGroup.post(use: createHadler)
        usersGroup.get(use: getAllHandler)
        usersGroup.get(":id", use: getHandler)
        usersGroup.post("auth", use: authHandler)
        usersGroup.put(":id", use: updateHandler)
        usersGroup.delete(":id", use: deleteHandler)
    }
    
    func createHadler(_ req: Request) async throws -> User.Public {
        guard let user = try? req.content.decode(User.self) else {
            throw Abort(.custom(code: 499, reasonPhrase: "Не получилось декодировать контент в модель продукта"))
        }
        
        user.password = try Bcrypt.hash(user.password)
        try await user.save(on: req.db)
        
        return user.convertToPublic()
    }
    
    func getAllHandler(_ req: Request) async throws -> [User.Public] {
        let users = try await User.query(on: req.db).all()
        return users.map {user in user.convertToPublic() }
    }
    
    func getHandler(_ req: Request) async throws -> User.Public {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user.convertToPublic()
    }
    
    func authHandler(_ req: Request) async throws -> User.Public {
        let userDTO = try req.content.decode(AuthUserDTO.self)
        guard let user = try await User
            .query (on: req.db)
            .filter("name", .equal, userDTO.name).first() else { throw Abort(.notFound) }
        let isPassEqual = try Bcrypt.verify(userDTO.password, created: user.password)
        guard isPassEqual else { throw Abort(.unauthorized) }
        
        return user.convertToPublic()
    }
    
    struct AuthUserDTO: Content {
        let name: String
        let password: String
    }
    
    func deleteHandler(_ req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await user.delete(on: req.db)
        
        return .ok
    }
    
    func updateHandler(_ req: Request) async throws -> User.Public {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let userUpdate = try req.content.decode(User.self)
        
        userUpdate.password = try Bcrypt.hash(userUpdate.password)
        
        user.name = userUpdate.name
        user.password = userUpdate.password
        user.date = userUpdate.date
        user.avatar = userUpdate.avatar
        user.routes = userUpdate.routes
        user.role = userUpdate.role
        user.likes = userUpdate.likes
        user.themes = userUpdate.themes
        
        try await user.save(on: req.db)
        
        return user.convertToPublic()
    }
}
