//
//  ChangePasswordViewController.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 28.02.2024.
//

import UIKit

final class ChangePasswordViewController: UIViewController {
    private var passwordViewOld = UIView()
    private var passwordLabelOld = UILabel()
    private var passwordFieldOld = UITextField()				
    private var passwordViewNew = UIView()
    private var passwordLabelNew = UILabel()
    private var passwordFieldNew = UITextField()
    private var passwordViewNewCopy = UIView()
    private var passwordLabelNewCopy = UILabel()
    private var passwordFieldNewCopy = UITextField()
    private var passwordStack = UIStackView()
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
        configurePasswordStack()
        configureBackButton()
    }
    
    private func configurePasswordLabel(type: Int) {
        var passwordLabel = UILabel()
        var passwordView = UIView()
        
        switch type {
        case 0:
            passwordLabel = passwordLabelOld
            passwordView = passwordViewOld
            passwordLabel.text = "Старый пароль:"
        case 1:
            passwordLabel = passwordLabelNew
            passwordView = passwordViewNew
            passwordLabel.text = "Новый пароль:"
        default:
            passwordLabel = passwordLabelNewCopy
            passwordView = passwordViewNewCopy
            passwordLabel.text = "Повторите:"
        }
        
        passwordView.addSubview(passwordLabel)
        
        passwordLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.height * 0.04)
        passwordLabel.textColor = .black
        
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.pinCenterX(to: passwordView)
        passwordLabel.pinTop(to: passwordView, view.bounds.height * 0.02)
    }
    
    private func configurePasswordField(type: Int) {
        var passwordField = UITextField()
        var passwordView = UIView()
        var passwordLabel = UILabel()
        var text: String = ""
        switch type {
        case 0:
            passwordLabel = passwordLabelOld
            passwordField = passwordFieldOld
            passwordView = passwordViewOld
            text = "введите старый пароль"
        case 1:
            passwordLabel = passwordLabelNew
            passwordField = passwordFieldNew
            passwordView = passwordViewNew
            text = "введите новый пароль"
        default:
            passwordLabel = passwordLabelNewCopy
            passwordField = passwordFieldNewCopy
            passwordView = passwordViewNewCopy
            text = "повторите новый пароль"
        }
        
        passwordView.addSubview(passwordField)

        passwordField.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        passwordField.returnKeyType = UIReturnKeyType.done
        
        passwordField.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef2)
        passwordField.textColor = .black
        passwordField.backgroundColor = .white
        passwordField.layer.cornerRadius = view.bounds.height * 0.02
        
        passwordField.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
        passwordField.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
        passwordField.leftViewMode = .always
        passwordField.rightViewMode = .always
        passwordField.layer.borderWidth = CGFloat(Constants.one)
        passwordField.layer.borderColor = UIColor.black.cgColor
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.pinCenterX(to: passwordView)
        passwordField.pinTop(to: passwordLabel.bottomAnchor, view.bounds.height * 0.02)
        passwordField.setHeight(view.bounds.height * 0.04)
        passwordField.setWidth(view.bounds.width * 0.8)
    }
    
    private func configurePasswordStack() {
        view.addSubview(passwordStack)
        
        passwordStack.axis = .vertical
        passwordStack.spacing = view.bounds.height * 0.02
        
        var i = 0
        for password in [passwordViewOld, passwordViewNew, passwordViewNewCopy] {
            password.backgroundColor = Constants.color
            password.layer.borderWidth = 2
            password.layer.borderColor = UIColor.black.cgColor
            password.layer.cornerRadius = Constants.radius
            
            password.translatesAutoresizingMaskIntoConstraints = false
            password.setWidth(view.bounds.width * 0.9)
            password.setHeight(view.bounds.height * 0.15)
            
            configurePasswordLabel(type: i)
            configurePasswordField(type: i)
            i += 1
            
            passwordStack.addArrangedSubview(password)
        }
        
        passwordStack.translatesAutoresizingMaskIntoConstraints = false
        passwordStack.pinCenterX(to: view)
        passwordStack.pinBottom(to: view.keyboardLayoutGuide.topAnchor, 0.065 * view.bounds.height)
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
        readyButton.pinHeight(to: view, 0.06)
        readyButton.pinBottom(to: view)
        
        readyButton.addTarget(self, action: #selector(readyButtonWasPressed), for: .touchUpInside)
    }
    
    @objc
    private func readyButtonWasPressed() {
        var countDigits = 0
        var flag = true
        for i in passwordFieldNew.text! {
            if Constants.digits.contains(i) {
                countDigits += 1
            }
            if !Constants.letters.contains(i) && !Constants.digits.contains(i) {
                flag = false
            }
        }
        if countDigits == 0 || !flag || passwordFieldNew.text!.count < 8 {
            passwordViewNew.backgroundColor = Constants.red
            passwordFieldNew.text = nil
            passwordFieldNew.attributedPlaceholder = NSAttributedString(string: "неверный формат", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            readyButton.isEnabled = false
            error.text = "error - Пароль должен иметь длину не менее 8 символов, быть написанным на латинице и содержать как минимум одну цифру, специальные символы не допускаются"
            configureErrorView(errorView: errorView, error: error)
            errorView.isHidden = false
        } else if passwordFieldNewCopy.text != "" && passwordFieldNew.text != "" && passwordFieldOld.text != "" {
            if passwordFieldOld.text == Vars.password {
                if passwordFieldNew.text == passwordFieldNewCopy.text {
                    readyButton.isEnabled = false
                    passwordViewNewCopy.backgroundColor = Constants.green
                    passwordViewNew.backgroundColor = Constants.green
                    passwordViewOld.backgroundColor = Constants.green
                    Task {
                        do {
                            Vars.user = try await NetworkService.shared.updateUser(id: Vars.user!.id, name: Vars.user!.name, email: Vars.user!.email, date: Vars.user!.date, avatar: Vars.user!.avatar, routes: Vars.user!.routes, role: Vars.user!.role, likes: Vars.user!.likes, themes: Vars.user!.themes, chats: Vars.user!.chats, password: passwordFieldNewCopy.text!)
                            DispatchQueue.main.async {
                                UserDefaults.standard.set([], forKey: Constants.usersKey)
                                self.navigationController?.pushViewController(RootViewController(), animated: true)
                            }
                        } catch {
                            print("Произошла ошибка: \(error)")
                            self.navigationController?.pushViewController(ServerErrorViewController(), animated: true)
                        }
                    }
                } else {
                    passwordViewNewCopy.backgroundColor = Constants.red
                    passwordFieldNewCopy.text = ""
                    passwordFieldNewCopy.attributedPlaceholder = NSAttributedString(string: "не совпадает", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                }
            } else {
                passwordViewOld.backgroundColor = Constants.red
                passwordFieldOld.text = ""
                passwordFieldOld.attributedPlaceholder = NSAttributedString(string: "не подходит", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            }
        }
    }
    
    func hideKeyboardOnTapAroundandEnabledButton() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAndEnabledButton))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    @objc func dismissKeyboardAndEnabledButton() {
        errorView.isHidden = true
        view.endEditing(true)
        if passwordFieldNewCopy.text != "" && passwordFieldNew.text != "" && passwordFieldOld.text != "" {
            readyButton.isEnabled = true
        } else {
            readyButton.isEnabled = false
        }
    }
}
