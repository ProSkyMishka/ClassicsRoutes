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
        status = .zero
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
        name.font = UIFont.boldSystemFont(ofSize: view.bounds.height * Constants.coef11)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.pinTop(to: infoView, view.bounds.height * Constants.coef20)
        name.pinHorizontal(to: infoView, Constants.coef4)
    }
    
    private func configureDate() {
        date.text = Constants.regedString + (Vars.user!.date)
    }
    
    private func configureCount() {
        count.text = Constants.gone + String((Vars.user!.routes.count))
    }
    
    private func configureStackLabel() {
        stackLabel.axis = .vertical
        stackLabel.spacing = view.bounds.height * Constants.coef34
        
        for label in [date, count] {
            label.textColor = .black
            label.font = UIFont.systemFont(ofSize: view.bounds.height * Constants.coef20)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            
            stackLabel.addArrangedSubview(label)
        }
        
        configureDate()
        configureCount()
        
        stackLabel.translatesAutoresizingMaskIntoConstraints = false
        stackLabel.pinTop(to: name.bottomAnchor, view.bounds.height * Constants.coef20)
        stackLabel.pinHorizontal(to: infoView, Constants.coef4)
    }
    
    private func configureInfoView() {
        view.addSubview(infoView)
        infoView.addSubview(name)
        infoView.addSubview(stackLabel)
        
        infoView.backgroundColor = Constants.color
        infoView.layer.cornerRadius = Constants.value
        infoView.layer.borderWidth = Constants.coef5
        infoView.layer.borderColor = UIColor.black.cgColor
        
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.pinTop(to: avatar.bottomAnchor)
        infoView.pinWidth(to: view)
        infoView.pinHeight(to: view, Constants.coef40)
        
        configureName()
        configureStackLabel()
    }
    
    private func configureSignOutButton() {
        let title = Constants.signOut
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(signOutButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .red
    }
    
    @objc
    private func signOutButtonTapped() {
        UserDefaults.standard.set([], forKey: Constants.usersKey)
        navigationController?.pushViewController(RootViewController(), animated: true)
    }
    
    private func configureSettingsLabel() {
        settingsLabel.text = Constants.settings
        settingsLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef)
        settingsLabel.textColor = .black
        
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsLabel.pinCenterX(to: settings)
        settingsLabel.pinTop(to: settings, view.bounds.height * Constants.coef20)
    }
    
    private func configureChangeAvatar() {
        changeAvatar.setTitle(Constants.avatarString, for: .normal)
        
        changeAvatar.addTarget(self, action: #selector(changeAvatarWasPressed), for: .touchUpInside)
    }
    
    private func configureChangeName() {
        changeName.setTitle(Constants.userNameString.lowercased(), for: .normal)
        
        changeName.addTarget(self, action: #selector(changeNameWasPressed), for: .touchUpInside)
    }
    
    private func configureChangePassword() {
        changePassword.setTitle(Constants.passwordString.lowercased(), for: .normal)
        
        changePassword.addTarget(self, action: #selector(changePasswordWasPressed), for: .touchUpInside)
    }
    
    private func configureSuggest() {
        suggest.setTitle(Constants.suggestString, for: .normal)
        if Vars.user?.role == Constants.adminRole {
            suggest.setTitle(Constants.addRouteString, for: .normal)
        }
        
        suggest.addTarget(self, action: #selector(suggestWasPressed), for: .touchUpInside)
    }
    
    private func configureSettingsStack() {
        settingsStack.axis = .vertical
        settingsStack.spacing = view.bounds.height * Constants.coef41
        
        for button in [changeAvatar, changeName, changePassword, suggest] {
            button.setTitleColor(Constants.color, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.height * Constants.coef11)
            button.backgroundColor = .gray
            button.layer.borderWidth = Constants.coef5
            button.layer.borderColor = UIColor.black.cgColor
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setHeight(view.bounds.height * Constants.avatarCoef3)
            settingsStack.addArrangedSubview(button)
        }
        
        configureChangeAvatar()
        configureChangeName()
        configureChangePassword()
        configureSuggest()
        
        settingsStack.translatesAutoresizingMaskIntoConstraints = false
        settingsStack.pinTop(to: settingsLabel.bottomAnchor, view.bounds.height * Constants.coef20)
        settingsStack.pinHorizontal(to: settings)
    }
    
    private func configureSettings() {
        view.addSubview(settings)
        settings.addSubview(settingsLabel)
        settings.addSubview(settingsStack)
        
        settings.backgroundColor = Constants.color
        settings.layer.cornerRadius = Constants.value
        settings.layer.borderWidth = Constants.coef5
        settings.layer.borderColor = UIColor.black.cgColor
        settings.layer.cornerRadius = Constants.value
        
        settings.translatesAutoresizingMaskIntoConstraints = false
        settings.pinTop(to: infoView.bottomAnchor, view.bounds.height * Constants.coef11)
        settings.pinBottom(to: bar.topAnchor, view.bounds.height * Constants.coef34)
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
        if Vars.user?.role == Constants.adminRole {
            navigationController?.pushViewController(SuggestViewController(), animated: true)
        } else {
            Task {
                do {
                    let users = try await NetworkService.shared.getAllUsers()
                    let chats = try await NetworkService.shared.getAllChats()
                    DispatchQueue.main.async {
                        var usersId: [String] = []
                        for user in users {
                            if user.role == Constants.adminRole {
                                usersId.append(user.id)
                            }
                        }
                        usersId.append(Vars.user!.id)
                        if chats.contains(where: {
                            var flag = true
                            for user in usersId {
                                if !$0.users.contains(user) {
                                    flag = false
                                }
                            }
                            return flag
                        }) {
                            Vars.chat = chats[chats.firstIndex(where: {
                                var flag = true
                                for user in usersId {
                                    if !$0.users.contains(user) {
                                        flag = false
                                    }
                                }
                                return flag
                            })!]
                            self.navigationController?.pushViewController(ChatViewController(), animated: true)
                        } else {
                            Task {
                                let chat = try await NetworkService.shared.createChat(users: usersId, messages: [], last: Constants.nilDate)
                                DispatchQueue.main.async {
                                    Vars.chat = ChatDate(id: chat.id, users: chat.users, messages: [], last: Constants.format.date(from: chat.last)!, routeSuggest: chat.routeSuggest)
                                    self.navigationController?.pushViewController(ChatViewController(), animated: true)
                                }
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
