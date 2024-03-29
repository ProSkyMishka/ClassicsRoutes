//
//  ProfileViewController.swift
//  Class'Ways
//
//  Created by Михаил Прозорский on 23.02.2024.
//

import UIKit

class ProfileViewController: TemplateViewController {
    var name = UILabel()
    var date = UILabel()
    var count = UILabel()
    var stackLabel = UIStackView()
    var avatar = UIImageView()
    var infoView = UIView()
    var settingsLabel = UILabel()
    var changeAvatar = UIButton()
    var changeName = UIButton()
    var changePassword = UIButton()
    var suggest = UIButton()
    var settings = UIView()
    var settingsStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        status = 0
        configureUI()
    }
    
    private func configureUI() {
        configureBackGroundImage()
        configureAvatar()
        configureInfoView()
        configureBar()
        configureSettings()
        configureSignOutButton()
    }
    
    private func configureAvatar() {
        view.addSubview(avatar)

        returnImage(imageView: avatar, key: Vars.user!.avatar)
        
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.pinWidth(to: view, Constants.avatarCoef1)
        avatar.pinHeight(to: view, Constants.avatarCoef2)
        avatar.pinTop(to: view, Constants.avatarCoef3 * view.bounds.height)
        avatar.pinCenterX(to: view)
    }
    
    private func configureName() {
        name.textColor = .black
        name.text = Vars.user!.name
        name.font = UIFont.boldSystemFont(ofSize: view.bounds.height * 0.03)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.pinTop(to: infoView, view.bounds.height * 0.02)
        name.pinHorizontal(to: infoView, Constants.coef4)
    }
    
    private func configureDate() {
        date.text = "Регистрация: \(Vars.user!.date)"
    }
    
    private func configureCount() {
        count.text = "Пройдено маршрутов: \(Vars.user!.routes.count)"
    }
    
    private func configureStackLabel() {
        stackLabel.axis = .vertical
        stackLabel.spacing = view.bounds.height * 0.01
        
        for label in [date, count] {
            label.textColor = .black
            label.font = UIFont.systemFont(ofSize: view.bounds.height * 0.02)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            
            stackLabel.addArrangedSubview(label)
        }
        
        configureDate()
        configureCount()
        
        stackLabel.translatesAutoresizingMaskIntoConstraints = false
        stackLabel.pinTop(to: name.bottomAnchor, view.bounds.height * 0.02)
        stackLabel.pinHorizontal(to: infoView, Constants.coef4)
    }
    
    private func configureInfoView() {
        view.addSubview(infoView)
        infoView.addSubview(name)
        infoView.addSubview(stackLabel)
        
        infoView.backgroundColor = Constants.color
        infoView.layer.cornerRadius = Constants.radius
        infoView.layer.borderWidth = 2
        infoView.layer.borderColor = UIColor.black.cgColor
        
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.pinTop(to: avatar.bottomAnchor)
        infoView.pinWidth(to: view)
        infoView.pinHeight(to: view, 0.15)
        
        configureName()
        configureStackLabel()
    }
    
    private func configureSignOutButton() {
        let title = "Выйти"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(signOutButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .red
    }
    
    @objc
    private func signOutButtonTapped() {
        UserDefaults.standard.set([], forKey: Constants.usersKey)
        navigationController?.pushViewController(RootViewController(), animated: true)
    }
    
    private func configureSettingsLabel() {
        settingsLabel.text = "Настройки"
        settingsLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef)
        settingsLabel.textColor = .black
        
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsLabel.pinCenterX(to: settings)
        settingsLabel.pinTop(to: settings, view.bounds.height * 0.02)
    }
    
    private func configureChangeAvatar() {
        changeAvatar.setTitle("аватар", for: .normal)
        
        changeAvatar.addTarget(self, action: #selector(changeAvatarWasPressed), for: .touchUpInside)
    }
    
    private func configureChangeName() {
        changeName.setTitle("имя пользователя", for: .normal)
        
        changeName.addTarget(self, action: #selector(changeNameWasPressed), for: .touchUpInside)
    }
    
    private func configureChangePassword() {
        changePassword.setTitle("пароль", for: .normal)
        
        changePassword.addTarget(self, action: #selector(changePasswordWasPressed), for: .touchUpInside)
    }
    
    private func configureSuggest() {
        suggest.setTitle("предложить маршрут", for: .normal)
        if Vars.user?.role == "admin" {
            suggest.setTitle("добавить маршрут", for: .normal)
        }
        
        suggest.addTarget(self, action: #selector(suggestWasPressed), for: .touchUpInside)
    }
    
    private func configureSettingsStack() {
        settingsStack.axis = .vertical
        settingsStack.spacing = view.bounds.height * 0.005
        
        for button in [changeAvatar, changeName, changePassword, suggest] {
            button.setTitleColor(Constants.color, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.height * 0.03)
            button.backgroundColor = .gray
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setHeight(view.bounds.height * 0.07)
            settingsStack.addArrangedSubview(button)
        }
        
        configureChangeAvatar()
        configureChangeName()
        configureChangePassword()
        configureSuggest()
        
        settingsStack.translatesAutoresizingMaskIntoConstraints = false
        settingsStack.pinTop(to: settingsLabel.bottomAnchor, view.bounds.height * 0.02)
        settingsStack.pinHorizontal(to: settings)
    }
    
    private func configureSettings() {
        view.addSubview(settings)
        settings.addSubview(settingsLabel)
        settings.addSubview(settingsStack)
        
        settings.backgroundColor = Constants.color
        settings.layer.cornerRadius = Constants.radius
        settings.layer.borderWidth = 2
        settings.layer.borderColor = UIColor.black.cgColor
        settings.layer.cornerRadius = Constants.radius
        
        settings.translatesAutoresizingMaskIntoConstraints = false
        settings.pinTop(to: infoView.bottomAnchor, view.bounds.height * 0.03)
        settings.pinBottom(to: bar.topAnchor, view.bounds.height * 0.01)
        settings.pinWidth(to: view)
        
        configureSettingsLabel()
        configureSettingsStack()
    }
    
    @objc
    private func changeAvatarWasPressed() {
        navigationController?.pushViewController(ChangeAvatarViewController(), animated: true)
    }
    
    @objc
    private func changeNameWasPressed() {
        navigationController?.pushViewController(ChangeNameViewController(), animated: true)
    }
    
    @objc
    private func changePasswordWasPressed() {
        navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
    }
    
    @objc
    private func suggestWasPressed() {
        if Vars.user?.role == "admin" {
            navigationController?.pushViewController(SuggestViewController(), animated: true)
        } else {
            Task {
                do {
                    let users = try await NetworkService.shared.getAllUsers()
                    DispatchQueue.main.async {
                        var usersId: [String] = []
                        for user in users {
                            if user.role == "admin" {
                                usersId.append(user.id)
                            }
                        }
                        usersId.append(Vars.user!.id)
                        Task {
                            var chat = try await NetworkService.shared.createChat(users: usersId, messages: [], last: "01.01.0001 01:00:00")
                            DispatchQueue.main.async {
                                Vars.chat = ChatDate(id: chat.id, users: chat.users, messages: [], last: Constants.format.date(from: chat.last)!)
                                self.navigationController?.pushViewController(ChatViewController(), animated: true)
                            }
                        }
                    }
                } catch {
                    print("Произошла ошибка: \(error)")
                    navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                }
            }
        }
    }
}
