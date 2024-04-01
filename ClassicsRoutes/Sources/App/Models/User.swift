//
//  User.swift
//
//
//  Created by Михаил Прозорский on 19.02.2024.
//

import Fluent
import Vapor

final class User: Model, Content {
    static var schema: String = "users"
    
    @ID var id: UUID?
    @Field(key: "name") var name: String
    @Field(key: "password") var password: String
    @Field(key: "date") var date: String
    @Field(key: "avatar") var avatar: String
    @Field(key: "routes") var routes: [String]
    @Field(key: "role") var role: String
    @Field(key: "likes") var likes: [String]
    @Field(key: "themes") var themes: [Int]
    
    final class Public: Content {
        var id: UUID?
        var name: String
        var date: String
        var avatar: String
        var routes: [String]
        var role: String
        var likes: [String]
        var themes: [Int]
        
        init(id: UUID? = nil, name: String, date: String,
             avatar: String, routes: [String], role: String, likes: [String],
             themes: [Int]) {
            self.id = id
            self.name = name
            self.date = date
            self.avatar = avatar
            self.routes = routes
            self.role = role
            self.likes = likes
            self.themes = themes
        }
    }
}

extension User: ModelAuthenticatable {
    static var usernameKey = \User.$name
    static var passwordHashKey = \User.$password
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

extension User {
    func convertToPublic() -> User.Public {
        let pub = Public(id: self.id, name: self.name, date: self.date, avatar: self.avatar, routes: self.routes, role: self.role, likes: self.likes, themes: self.themes)
        return pub
    }
}

enum roles: String {
    case admin = "admin"
    case user = "user"
}
