//
//  Vars.swift
//  Class'Ways
//
//  Created by Михаил Прозорский on 23.02.2024.
//

import UIKit

class Vars {
    static var password: String = Constants.nilString
    static var user: User?
    static var chat: ChatDate?
    static var previous = Constants.coef24
    static var route: RouteWithGrade?
    static var messages: [MessageDate] = []
    static var nilMessage = MessageSocket(chatId: Constants.nilString, id: Constants.nilString, user: Constants.nilString, route: Constants.nilString, time: Constants.format.date(from: Constants.nilDate)!, text: Constants.nilString)
}
