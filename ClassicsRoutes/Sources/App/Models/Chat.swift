//
//  Chat.swift
//
//
//  Created by Михаил Прозорский on 02.03.2024.
//

import Fluent
import Vapor

final class Chat: Model, Content {
    static var schema: String = "chats"
    
    @ID var id: UUID?
    @Field(key: "users") var users: [String]
    @Field(key: "messages") var messages: [String]
    @Field(key: "last") var last: String
    @Field(key: "routeSuggest") var routeSuggest: String
    
    init() {}
    
    init(id: UUID? = nil, users: [String], messages: [String], last: String, routeSuggest: String) {
        self.id = id
        self.users = users
        self.messages = messages
        self.last = last
        self.routeSuggest = routeSuggest
    }
}
