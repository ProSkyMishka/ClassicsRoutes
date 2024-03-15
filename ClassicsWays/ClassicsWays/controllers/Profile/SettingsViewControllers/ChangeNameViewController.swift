//
//  ChangeNameViewController.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 27.02.2024.
//

import UIKit

final class ChangeNameViewController: UIViewController {
    private var nameView = UIView()
    private var nameLabel = UILabel()
    private var nameField = UITextField()
    private var readyButton = UIButton()
    private lazy var error = UILabel()
    private lazy var errorView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        hideKeyboardOnTapAroundandEnabledButton()
        configureBackGroundImage()
        configureReadyButton()
        configureNameView()
        configureBackButton()
    }
    
    private func configureNameView() {
        view.addSubview(nameView)
        
        nameView.addSubview(nameLabel)
        nameView.addSubview(nameField)
        
        nameView.backgroundColor = Constants.color
        nameView.layer.borderWidth = 2
        nameView.layer.borderColor = UIColor.black.cgColor
        nameView.layer.cornerRadius = Constants.radius
        
        nameView.translatesAutoresizingMaskIntoConstraints = false
        nameView.pinWidth(to: view, 0.9)
        nameView.pinHeight(to: view, 0.15)
        nameView.pinCenter(to: view)
        
        configureNameLabel()
        configureNameField()
    }
    
    private func configureNameLabel() {
        nameLabel.text = "Новое имя:"
        nameLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.height * 0.04)
        nameLabel.textColor = .black
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.pinCenterX(to: nameView)
        nameLabel.pinTop(to: nameView, view.bounds.height * 0.02)
    }
    
    private func configureNameField() {
        nameField.attributedPlaceholder = NSAttributedString(string: "введите новое имя", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        nameField.returnKeyType = UIReturnKeyType.done
        
        nameField.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef2)
        nameField.textColor = .black
        nameField.backgroundColor = .white
        nameField.layer.cornerRadius = view.bounds.height * 0.02
        
        nameField.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
        nameField.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
        nameField.leftViewMode = .always
        nameField.rightViewMode = .always
        nameField.layer.borderWidth = CGFloat(Constants.one)
        nameField.layer.borderColor = UIColor.black.cgColor
        
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.pinCenterX(to: nameView)
        nameField.pinTop(to: nameLabel.bottomAnchor, view.bounds.height * 0.02)
        nameField.setHeight(view.bounds.height * 0.04)
        nameField.setWidth(view.bounds.width * 0.8)
    }
    
    private func configureReadyButton() {
        view.addSubview(readyButton)
        
        readyButton.isEnabled = false
        readyButton.setTitle("ГОТОВО", for: .normal)
        readyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.height * 0.05)
        readyButton.setTitleColor(.black, for: .normal)
        readyButton.setTitleColor(.lightGray, for: .disabled)
        readyButton.layer.borderColor = UIColor.black.cgColor
        readyButton.layer.borderWidth = 2
        readyButton.backgroundColor = Constants.color
        
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        readyButton.pinWidth(to: view)
        readyButton.pinHeight(to: view, 0.07)
        readyButton.pinBottom(to: view)
        
        readyButton.addTarget(self, action: #selector(readyButtonWasPressed), for: .touchUpInside)
    }
    
    @objc
    private func readyButtonWasPressed() {
        var countLetters = 0
        var flag = true
        for i in nameField.text! {
            if Constants.letters.contains(i) {
                countLetters += 1
            }
            if !Constants.letters.contains(i) && !Constants.digits.contains(i) {
                flag = false
            }
        }
        if countLetters == 0 || !flag {
            let text = "error - Имя пользователя должно содержать хотя бы одну латинскую букву, специальные символы не допускаются"
            error(text: text)
        } else if nameField.text != "" {
            readyButton.isEnabled = false
            var users: [User] = []
            Task {
                do {
                    users = try await NetworkService.shared.getAllUsers()
                    DispatchQueue.main.async {
                        for user in users {
                            if self.nameField.text == user.name {
                                self.error(text: "error - Пользователь с таким именем уже существует")
                                self.nameField.attributedPlaceholder = NSAttributedString(string: "имя занято", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                                return
                            }
                        }
                        Task {
                            do {
                                Vars.user = try await NetworkService.shared.updateUser(id: Vars.user!.id, name: self.nameField.text!, email: Vars.user!.email, date: Vars.user!.date, avatar: Vars.user!.avatar, routes: Vars.user!.routes, role: Vars.user!.role, likes: Vars.user!.likes, themes: Vars.user!.themes, chats: Vars.user!.chats, password: Vars.password)
                                DispatchQueue.main.async {
                                    
                                    self.navigationController?.pushViewController(ProfileViewController(), animated: true)
                                }
                            } catch {
                                print("Произошла ошибка: \(error)")
                                self.navigationController?.pushViewController(ServerErrorViewController(), animated: true)
                            }
                        }
                    }
                } catch {
                    navigationController?.pushViewController(ServerErrorViewController(), animated: true)
                    print("Произошла ошибка: \(error)")
                }
            }
        }
    }
    
    func error(text: String) {
        nameView.backgroundColor = Constants.red
        nameField.text = nil
        nameField.attributedPlaceholder = NSAttributedString(string: "неверный формат", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        readyButton.isEnabled = false
        configureErrorView(errorView: errorView, error: error)
        error.text = text
        errorView.isHidden = false
    }
    
    func hideKeyboardOnTapAroundandEnabledButton() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAndEnabledButton))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    @objc func dismissKeyboardAndEnabledButton() {
        errorView.isHidden = true
        view.endEditing(true)
        if nameField.text != "" {
            readyButton.isEnabled = true
        } else {
            readyButton.isEnabled = false
        }
    }
}
