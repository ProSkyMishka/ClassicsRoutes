//
//  Message.swift
//
//
//  Created by Михаил Прозорский on 02.03.2024.
//

import Fluent
import Vapor

final class Message: Model, Content {
    static var schema: String = "messages"
    
    @ID var id: UUID?
    @Field(key: "user") var user: String
    @Field(key: "text") var text: String
    @Field(key: "time") var time: String
    @Field(key: "route") var route: String

    init() {}
    
    init(id: UUID? = nil, user: String, text: String, time: String, route: String) {
        self.id = id
        self.user = user
        self.text = text
        self.time = time
        self.route = route
    }
}
