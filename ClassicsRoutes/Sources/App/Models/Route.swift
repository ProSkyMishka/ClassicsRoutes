//
//  Route.swift
//  
//
//  Created by Михаил Прозорский on 14.02.2024.
//

import Fluent
import Vapor

final class Route: Model, Content {
    static var schema: String = "routes"
    
    @ID var id: UUID?
    @Field(key: "avatar") var avatar: String
    @Field(key: "person") var person: String
    @Field(key: "name") var name: String
    @Field(key: "description") var description: String
    @Field(key: "theme") var theme: Int
    @Field(key: "time") var time: Int
    @Field(key: "start") var start: String
    @Field(key: "pictures") var pictures: [String]
    @Field(key: "raiting") var raiting: [String]
    @Field(key: "locations") var locations: [String]
    
    init() {}
    
    init(id: UUID? = nil, person: String, name: String, description: String, theme: Int, time: Int, start: String, pictures: [String], avatar: String, raiting: [String], locations: [String]) {
        self.id = id
        self.avatar = avatar
        self.person = person
        self.name = name
        self.description = description
        self.theme = theme
        self.time = time
        self.start = start
        self.pictures = pictures
        self.raiting = raiting
        self.locations = locations
    }
}
