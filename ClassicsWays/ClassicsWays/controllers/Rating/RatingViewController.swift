//
//  RatingViewController.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 25.02.2024.
//

import UIKit

class RatingViewController: TemplateViewController {
    var txtLabel = UILabel()
    var stick = UIView()
    private var table: UITableView = UITableView(frame: .zero)
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            do {
                users = try await NetworkService.shared.getAllUsers()
                DispatchQueue.main.async {
                    self.users.sort(by: {$0.routes.count > $1.routes.count})
                    self.configureTable()
                }
            } catch {
                navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                print("Произошла ошибка: \(error)")
            }
        }
        status = Int(Constants.coef5)
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = Constants.color
        configureBar()
        configureLabel()
        configureStick()
    }
    
    private func configureLabel() {
        view.addSubview(txtLabel)
        
        txtLabel.text = Constants.ratingString
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
        table.register(RatingCell.self, forCellReuseIdentifier: RatingCell.reuseId)
        
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
extension RatingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.one
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RatingCell.reuseId, for: indexPath)
        guard let raitingCell = cell as? RatingCell else { return cell }
        raitingCell.configure(with: users[indexPath.row].name, with: Constants.gone + String(users[indexPath.row].routes.count), with: users[indexPath.row].avatar)
        return raitingCell
    }
}

// MARK: - UITableViewDelegate
extension RatingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userId = users[indexPath.row].id
        if (userId == Vars.user!.id) {
            navigationController?.pushViewController(ProfileViewController(), animated: true)
        } else {
            Task {
                do {
                    let chats = try await NetworkService.shared.getAllChats()
                    DispatchQueue.main.async {
                        Vars.chat = nil
                        for chat in chats {
                            if chat.users.count == Int(Constants.coef5) && chat.users.contains(userId) && chat.users.contains(Vars.user!.id) {
                                Vars.chat = chat
                                break
                            }
                        }
                        if Vars.chat == nil {
                            Task {
                                let chat = try await NetworkService.shared.createChat(users: [Vars.user!.id, userId], messages: [], last: Constants.nilDate)
                                Vars.chat = ChatDate(id: chat.id, users: chat.users, messages: chat.messages, last: Constants.format.date(from: chat.last)!, routeSuggest: chat.routeSuggest)
                                DispatchQueue.main.async {
                                    self.navigationController?.pushViewController(ChatViewController(), animated: true)
                                }
                            }
                        } else {
                            self.navigationController?.pushViewController(ChatViewController(), animated: true)
                        }
                    }
                } catch {
                    navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                    print("Произошла ошибка: \(error)")
                }
            }
        }
    }
}
