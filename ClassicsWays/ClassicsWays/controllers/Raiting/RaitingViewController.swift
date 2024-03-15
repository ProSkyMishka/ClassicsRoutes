//
//  RaitingViewController.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 25.02.2024.
//

import UIKit

class RaitingViewController: TemplateViewController {
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
                navigationController?.pushViewController(ServerErrorViewController(), animated: true)
                print("Произошла ошибка: \(error)")
            }
        }
        status = 2
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
        
        txtLabel.text = "Рейтинг"
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
        table.register(RaitingCell.self, forCellReuseIdentifier: RaitingCell.reuseId)
        
        view.addSubview(table)
        
        table.dataSource = self
        table.backgroundColor = Constants.color
        table.separatorStyle = .none
        table.rowHeight = 100
        
        table.pinTop(to: stick.bottomAnchor, view.bounds.height * 0.05)
        table.pinWidth(to: view)
        table.pinBottom(to: bar.topAnchor)
    }
}

// MARK: - UITableViewDataSource
extension RaitingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.one
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RaitingCell.reuseId, for: indexPath)
        guard let raitingCell = cell as? RaitingCell else { return cell }
        raitingCell.configure(with: users[indexPath.row].name, with: "Пройдено маршрутов: \(users[indexPath.row].routes.count)", with: users[indexPath.row].avatar)
        return raitingCell
    }
}
