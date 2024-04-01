//
//  SocketFunctions.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 30.03.2024.
//

import Foundation
import UIKit

extension NetworkService {
    func setUpWebSocket() async throws {
        let urlSession = URLSession(configuration: .default)
        let webSocketTask = urlSession.webSocketTask(with: URL(string: localSocketHost)!)
        webSocketTask.resume()
        self.webSocketTask = webSocketTask
    }
    
    func sendMessages(message: URLSessionWebSocketTask.Message) async throws {
        webSocketTask!.send(message) { error in
            if let error = error {
                print("websocket couldn't send message: \(error.localizedDescription)")
            }
        }
    }
    
    func receiveMessagesChat(collection: UICollectionView) async throws {
        webSocketTask!.receive { result in
            switch result {
            case .failure(let error):
                print("Something went wrong: \(error.localizedDescription)")
            case .success(let message):
                switch message {
                case .data(let data):
                    print ("Data: \(data)")
                    guard let newMessageSocket = try? JSONDecoder().decode(MessageDate.self, from: data)
                    else {
                        return
                    }
                    let newMessageDB = MessageDate(id: newMessageSocket.id, user: newMessageSocket.user, route: newMessageSocket.route, routeSuggest: newMessageSocket.routeSuggest, time: newMessageSocket.time, text: newMessageSocket.text)
                    DispatchQueue.main.async {
                        if newMessageDB.id != "" && !Vars.messages.contains(where: {$0.id == newMessageDB.id}) {
                            Vars.messages.append(newMessageDB)
                        }
                        collection.reloadData()
                        collection.scrollToItem(at: IndexPath(row: Vars.messages.count - 1, section: 0), at: .bottom, animated: false)
                        Task {
                            try await Task.sleep(nanoseconds: 5_000_000)
                            collection.scrollToItem(at: IndexPath(row: Vars.messages.count - 1, section: 0), at: .bottom, animated: true)
                            collection.reloadData()
                        }
                    }
                case .string(let message):
                    print(message)
                default:
                    print("unknown case")
                }
                Task {
                    try await self.receiveMessagesChat(collection: collection)
                }
            }
        }
    }
}
