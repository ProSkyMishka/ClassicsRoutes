import Fluent
import Vapor
import WebKit

func routes(_ app: Application) throws {
    try app.register(collection: RoutesController())
    try app.register(collection: UsersController())
    try app.register(collection: ChatsController())
    try app.register(collection: MessagesController())
    
    let room = Room()
    
    app.webSocket("echo") { req, ws in
        ws.onBinary { ws, text in
            guard
                let message = try? JSONDecoder().decode(ChatMessage.self, from: text)
            else {
                print("Couldn't decode user")
                return
            }
            app.console.wait(seconds: 5)
            room.connections["\(message.chatId) \(message.user)"] = ws
            room.send(info: message, message: text)
        }
    }
}

struct ChatMessage: Codable {
    let chatId: String
    let id: String
    let user: String
    let route: String
    let routeSuggest: String
    let time: Date
    let text: String
}

class Room {
    var connections = [String: WebSocket]()
    func send(info: ChatMessage, message: ByteBuffer) {
        for (str, websocket) in connections {
            let compon = str.components(separatedBy: " ")
            if (info.chatId != String(compon[0]) || info.user == String(compon[1])) {
                continue
            }
            websocket.send(message)
        }
    }
}
