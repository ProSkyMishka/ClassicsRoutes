//
//  ChatsViewController.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 25.02.2024.
//

import UIKit

class ChatsViewController: TemplateViewController {
    private var txtLabel = UILabel()
    private var stick = UIView()
    private var table: UITableView = UITableView(frame: .zero)
    private var users: [User] = []
    private var chats: [ChatDate] = []
    private var textLabel = Constants.chatsString
    private var routeId = Constants.nilString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        status = Constants.one
        configureUI()
        Task {
            do {
                chats = try await NetworkService.shared.getAllChats()
                users = try await NetworkService.shared.getAllUsers()
                DispatchQueue.main.async { [self] in
                    chats.removeAll(where: {$0.messages.isEmpty})
                    chats.sort(by: {$0.last > $1.last})
                    configureTable()
                }
            } catch {
                navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                print("Произошла ошибка: \(error)")
            }
        }
    }
    
    private func configureUI() {
        view.backgroundColor = Constants.color
        configureBar()
        configureLabel()
        configureStick()
    }
    
    func configure(with routeId: String) {
        bar.isHidden = true
        textLabel = Constants.choose
        self.routeId = routeId
        configureBackButton(.black)
    }
    
    private func configureLabel() {
        view.addSubview(txtLabel)
        
        txtLabel.text = textLabel
        txtLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef)
        txtLabel.textColor = .black
        
        txtLabel.translatesAutoresizingMaskIntoConstraints = false
        txtLabel.pinCenterX(to: view)
        txtLabel.pinBottom(to: view.safeAreaLayoutGuide.topAnchor)
    }
    
    private func configureStick() {
        view.addSubview(stick)
        
        stick.backgroundColor = .black
        
        stick.translatesAutoresizingMaskIntoConstraints = false
        stick.pinWidth(to: view)
        stick.setHeight(Constants.coef5)
        stick.pinCenterX(to: view)
        stick.pinTop(to: txtLabel.bottomAnchor, Constants.coef7)
    }
    
    private func configureTable() {
        table.register(ChatCell.self, forCellReuseIdentifier: ChatCell.reuseId)
        
        view.addSubview(table)
        
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = Constants.color
        table.separatorStyle = .none
        table.rowHeight = Constants.rowHeight
        
        table.pinTop(to: stick.bottomAnchor, view.bounds.height * Constants.coef16)
        table.pinWidth(to: view)
        table.pinBottom(to: bar.topAnchor)
    }
}

// MARK: - UITableViewDataSource
extension ChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.one
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.reuseId, for: indexPath)
        guard let chatCell = cell as? ChatCell else { return cell }
        var name = Constants.nilString
        var avatar = Constants.nilString
        for user in chats[indexPath.row].users {
            if user == Vars.user!.id {
                continue
            }
            name += (users[(users.firstIndex(where: {$0.id == user}))!].name) + Constants.space
            avatar = users[users.firstIndex(where: {$0.id == user})!].avatar
        }
        chatCell.configure(with: name, with: avatar)
        return chatCell
    }
}

// MARK: - UITableViewDelegate
extension ChatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Vars.chat = chats[indexPath.row]
        if (Vars.chat != nil) {
            if !routeId.isEmpty {
                Task {
                    do {
                        let message = try await NetworkService.shared.createMessage(user: Vars.user!.id, route: routeId, time: Constants.format.string(from: Date.now), text: Constants.routeMessage)
                        Vars.chat = try await NetworkService.shared.getChat(id: Vars.chat!.id)
                        try await NetworkService.shared.setUpWebSocket()
                        let messageSocket = MessageSocket(chatId: Vars.chat!.id, id: message.id, user: Vars.user!.id, route: message.route, time: message.time, text: message.text)
                        try await NetworkService.shared.sendMessages(message: URLSessionWebSocketTask.Message.data(JSONEncoder().encode(messageSocket))
                        )
                        var messages = Vars.chat?.messages
                        messages?.append(message.id)
                        Vars.chat = try await NetworkService.shared.updateChat(id: Vars.chat!.id, users: Vars.chat!.users, messages: messages!, last: Constants.format.string(from: message.time), routeSuggest: Vars.chat!.routeSuggest)
                        let vc = ChatViewController()
                        navigationController?.pushViewController(vc, animated: true)
                    } catch {
                        navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                        print("Произошла ошибка: \(error)")
                    }
                }
            } else {
                let vc = ChatViewController()
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
