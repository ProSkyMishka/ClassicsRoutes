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
        nameView.layer.borderWidth = Constants.coef5
        nameView.layer.borderColor = UIColor.black.cgColor
        nameView.layer.cornerRadius = Constants.value
        
        nameView.translatesAutoresizingMaskIntoConstraints = false
        nameView.pinWidth(to: view, Constants.coef17)
        nameView.pinHeight(to: view, Constants.coef40)
        nameView.pinCenter(to: view)
        
        configureNameLabel()
        configureNameField()
    }
    
    private func configureNameLabel() {
        nameLabel.text = Constants.newName
        nameLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.height * Constants.coef29)
        nameLabel.textColor = .black
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.pinCenterX(to: nameView)
        nameLabel.pinTop(to: nameView, view.bounds.height * Constants.coef20)
    }
    
    private func configureNameField() {
        nameField.attributedPlaceholder = NSAttributedString(string: Constants.inputNewName, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        nameField.returnKeyType = UIReturnKeyType.done
        
        nameField.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef2)
        nameField.textColor = .black
        nameField.backgroundColor = .white
        nameField.layer.cornerRadius = view.bounds.height * Constants.coef20
        
        nameField.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
        nameField.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
        nameField.leftViewMode = .always
        nameField.rightViewMode = .always
        nameField.layer.borderWidth = CGFloat(Constants.one)
        nameField.layer.borderColor = UIColor.black.cgColor
        
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.pinCenterX(to: nameView)
        nameField.pinTop(to: nameLabel.bottomAnchor, view.bounds.height * Constants.coef20)
        nameField.setHeight(view.bounds.height * Constants.coef29)
        nameField.setWidth(view.bounds.width * Constants.avatarCoef1)
    }
    
    private func configureReadyButton() {
        view.addSubview(readyButton)
        
        readyButton.isEnabled = false
        readyButton.setTitle(Constants.ready.uppercased(), for: .normal)
        readyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.height * Constants.coef29)
        readyButton.setTitleColor(.black, for: .normal)
        readyButton.setTitleColor(.lightGray, for: .disabled)
        readyButton.layer.borderColor = UIColor.black.cgColor
        readyButton.layer.borderWidth = Constants.coef5
        readyButton.backgroundColor = Constants.color
        
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        readyButton.pinWidth(to: view)
        readyButton.pinHeight(to: view, Constants.avatarCoef3)
        readyButton.pinBottom(to: view)
        
        readyButton.addTarget(self, action: #selector(readyButtonWasPressed), for: .touchUpInside)
    }
    
    @objc
    private func readyButtonWasPressed() {
        var countLetters: Int = .zero
        var flag = true
        for i in nameField.text! {
            if Constants.letters.contains(i) {
                countLetters += Constants.one
            }
            if !Constants.letters.contains(i) && !Constants.digits.contains(i) {
                flag = false
            }
        }
        if countLetters == .zero || !flag {
            let text = Constants.nameFormatError
            error(text: text)
        } else if nameField.text != Constants.nilString {
            readyButton.isEnabled = false
            var users: [User] = []
            Task {
                do {
                    users = try await NetworkService.shared.getAllUsers()
                    DispatchQueue.main.async {
                        for user in users {
                            if self.nameField.text == user.name {
                                self.error(text: Constants.nameError)
                                self.nameField.attributedPlaceholder = NSAttributedString(string: Constants.nameTaken, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                                return
                            }
                        }
                        Task {
                            do {
                                Vars.user = try await NetworkService.shared.updateUser(id: Vars.user!.id, name: self.nameField.text!, date: Vars.user!.date, avatar: Vars.user!.avatar, routes: Vars.user!.routes, role: Vars.user!.role, likes: Vars.user!.likes, themes: Vars.user!.themes, password: Vars.password)
                                DispatchQueue.main.async {
                                    self.navigationController?.pushViewController(ProfileViewController(), animated: true)
                                }
                            } catch {
                                print("Произошла ошибка: \(error)")
                                self.navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                            }
                        }
                    }
                } catch {
                    navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                    print("Произошла ошибка: \(error)")
                }
            }
        }
    }
    
    func error(text: String) {
        nameView.backgroundColor = Constants.red
        nameField.text = nil
        nameField.attributedPlaceholder = NSAttributedString(string: Constants.formatError, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
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
        if nameField.text != Constants.nilString {
            readyButton.isEnabled = true
        } else {
            readyButton.isEnabled = false
        }
    }
}
