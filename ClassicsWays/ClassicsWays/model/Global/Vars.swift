//
//  Vars.swift
//  Class'Ways
//
//  Created by Михаил Прозорский on 23.02.2024.
//

import UIKit

class Vars {
    static var password: String = ""
    static var user: User?
    static var chat: ChatDate?
    static var previous = -1
    static var route: RouteWithGrade?
    static var messages: [MessageDate] = []
    static var nilMessage = MessageSocket(chatId: "", id: "", user: "", route: "", routeSuggest: "", time: Constants.format.date(from: "01.01.0001 01:00:00")!, text: "")
}
