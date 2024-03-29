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
            print(text)
            app.console.wait(seconds: 5)
            room.connections[message.user] = ws
            room.send(user: message.user, message: text)
            print(message.text)
        }
    }
}

struct ChatMessage: Codable {
    let id: String
    let user: String
    let route: String
    let routeSuggest: String
    let time: Date
    let text: String
}

class Room {
    var connections = [String: WebSocket ]()
    func send(user: String, message: ByteBuffer) {
        for (username, websocket) in connections {
            if (username == user) {
                continue
            }
            websocket.send(message)
        }
    }
}
