//
//  ChatsViewController.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 25.02.2024.
//

import UIKit

class ChatsViewController: TemplateViewController {
    var txtLabel = UILabel()
    var stick = UIView()
    private var table: UITableView = UITableView(frame: .zero)
    var chats: [ChatDate] = []
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        status = 1
        Task {
            do {
                chats = try await NetworkService.shared.getAllChats()
                users = try await NetworkService.shared.getAllUsers()
                DispatchQueue.main.async { [self] in
                    chats.removeAll(where: {$0.messages.isEmpty})
                    chats.sort(by: {$0.last > $1.last})
                    configureUI()
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
        configureTable()
    }
    
    private func configureLabel() {
        view.addSubview(txtLabel)
        
        txtLabel.text = "Чаты"
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
        stick.setHeight(2)
        stick.pinCenterX(to: view)
        stick.pinTop(to: txtLabel.bottomAnchor, 5)
    }
    
    private func configureTable() {
        table.register(RatingCell.self, forCellReuseIdentifier: RatingCell.reuseId)
        
        view.addSubview(table)
        
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = Constants.color
        table.separatorStyle = .none
        table.rowHeight = 100
        
        table.pinTop(to: stick.bottomAnchor, view.bounds.height * 0.05)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: RatingCell.reuseId, for: indexPath)
        guard let raitingCell = cell as? RatingCell else { return cell }
        var name = ""
        var avatar = ""
        for user in chats[indexPath.row].users {
            if user == Vars.user!.id {
                continue
            }
            name += "\(users[(users.firstIndex(where: {$0.id == user}))!].name) "
            avatar = users[users.firstIndex(where: {$0.id == user})!].avatar
        }
        var messages: [MessageDate] = []
        let chat = chats[indexPath.row]
        Task {
            do {
                messages = try await NetworkService.shared.getAllMessages(chat: chat)
                DispatchQueue.main.async {
                    messages.sort(by: {$0.time < $1.time})
                    var messageText = ""
                    if messages.count > 0 {
                        let message = messages[messages.count - 1]
                        if message.user == Vars.user!.id {
                            messageText = "Вы: \(message.text)"
                        } else {
                            messageText = message.text
                        }
                    }
                    raitingCell.configure(with: name, with: messageText, with: avatar)
                }
            } catch {
                navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                print("Произошла ошибка: \(error)")
            }
        }
        return raitingCell
    }
}

// MARK: - UITableViewDelegate
extension ChatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Vars.chat = chats[indexPath.row]
        if (Vars.chat != nil) {
            let vc = ChatViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
