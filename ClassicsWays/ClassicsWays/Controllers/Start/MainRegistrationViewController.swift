//
//  MainRegistrationViewController.swift
//  Class'Ways
//
//  Created by Михаил Прозорский on 14.02.2024.
//

import UIKit
//import SwiftSMTP

class MainRegistrationViewController: UIViewController {
    var txtLabel = UILabel()
    var stackField = UIStackView()
    var stackButton = UIStackView()
    var name = UITextField()
    var password = UITextField()
    var passwordCopy = UITextField()
    var continueButton = UIButton()
    var autoButton = UIButton()
    var themeView = UIView()
    var themeLabel = UILabel()
    var themes: [Int] = []
    var themeOne = UIButton()
    var themeTwo = UIButton()
    var themeThree = UIButton()
    var themeStack = UIStackView()
    var readyButton = UIButton()
    var backButton = UIButton()
    private lazy var error = UILabel()
    private lazy var errorView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        configureBackGroundImage()
        hideKeyboardOnTapAround(view)
        navigationItem.hidesBackButton = true
        configureStackButton()
        configureStackField()
        configureTxtLabel()
    }
    
    private func configureTxtLabel() {
        view.addSubview(txtLabel)
        
        txtLabel.text = Constants.regString
        txtLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef)
        txtLabel.textColor = .white
        txtLabel.shadowColor = .black
        txtLabel.shadowOffset = Constants.shadow
        
        txtLabel.translatesAutoresizingMaskIntoConstraints = false
        txtLabel.pinCenterX(to: view)
        txtLabel.pinTop(to: view, view.bounds.height / Constants.coef1)
    }
    
    private func configureName() {
        name.attributedPlaceholder = NSAttributedString(string: Constants.userNameString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    private func configurePassword() {
        password.attributedPlaceholder = NSAttributedString(string: Constants.passwordString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    private func configurePasswordCopy() {
        passwordCopy.attributedPlaceholder = NSAttributedString(string: Constants.repeatPasswordString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    private func configureContinueButton() {
        continueButton.isEnabled = false
        continueButton.setTitle(Constants.continueString, for: .normal)
        
        continueButton.addTarget(self, action: #selector(continueButtonWasPressed), for: .touchUpInside)
    }
    
    private func configureAuthButton() {
        autoButton.setTitle(Constants.withAccount, for: .normal)
        
        autoButton.addTarget(self, action: #selector(autoButtonWasPressed), for: .touchUpInside)
    }
    
    private func configureBackThemeButton() {
        backButton.isHidden = true
        backButton.setTitle(Constants.backString, for: .normal)
        
        backButton.addTarget(self, action: #selector(backThemeButtonWasPressed), for: .touchUpInside)
    }
    
    private func configureReadyButton() {
        readyButton.isEnabled = false
        readyButton.isHidden = true
        readyButton.setTitle(Constants.ready, for: .normal)
        
        readyButton.addTarget(self, action: #selector(readyButtonWasPressed), for: .touchUpInside)
    }
    
    private func configureStackField() {
        view.addSubview(stackField)
        
        stackField.axis = .vertical
        stackField.spacing = view.bounds.height / Constants.coef2
        
        for field in [name, password, passwordCopy] {
            field.returnKeyType = UIReturnKeyType.done
            
            field.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef2)
            field.textColor = .black
            field.backgroundColor = Constants.color
            field.layer.cornerRadius = Constants.value
            
            field.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
            field.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
            field.leftViewMode = .always
            field.rightViewMode = .always
            field.layer.borderWidth = CGFloat(Constants.one)
            field.layer.borderColor = UIColor.black.cgColor
            
            field.translatesAutoresizingMaskIntoConstraints = false
            field.setHeight(view.bounds.height / Constants.coef4)
            field.setWidth(view.bounds.width / Constants.coef6)
            stackField.addArrangedSubview(field)
        }
        
        configureName()
        configurePassword()
        configurePasswordCopy()
        
        stackField.translatesAutoresizingMaskIntoConstraints = false
        stackField.pinBottom(to: stackButton.topAnchor, view.bounds.height / Constants.coef2)
        stackField.pinCenterX(to: view)
    }
    
    private func configureStackButton() {
        view.addSubview(stackButton)
        
        stackButton.axis = .vertical
        stackButton.spacing = view.bounds.height / Constants.coef2
        
        for button in [continueButton, autoButton, backButton, readyButton] {
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef2)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.lightGray, for: .disabled)
            button.backgroundColor = Constants.color
            button.layer.cornerRadius = Constants.value
            
            button.layer.borderWidth = CGFloat(Constants.one)
            button.layer.borderColor = UIColor.black.cgColor
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setHeight(view.bounds.height / Constants.coef4)
            button.setWidth(view.bounds.width / Constants.coef5)
            stackButton.addArrangedSubview(button)
        }
        
        configureContinueButton()
        configureAuthButton()
        configureBackThemeButton()
        configureReadyButton()
        
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        stackButton.pinBottom(to: view, view.bounds.height / Constants.coef7)
        stackButton.pinCenterX(to: view)
    }
    
    @objc
    private func continueButtonWasPressed() {
        var countDigits: Int = .zero
        var flag = true
        for i in password.text! {
            if Constants.digits.contains(i) {
                countDigits += Constants.one
            }
            if !Constants.letters.contains(i) && !Constants.digits.contains(i) {
                flag = false
            }
        }
        var countLetters: Int = .zero
        var flagN = true
        for i in name.text! {
            if Constants.letters.contains(i) {
                countLetters += Constants.one
            }
            if !Constants.letters.contains(i) && !Constants.digits.contains(i) {
                flagN = false
            }
        }
        if countLetters == .zero || !flagN {
            let text = Constants.nameFormatError
            name.backgroundColor = Constants.red
            name.text = nil
            name.attributedPlaceholder = NSAttributedString(string: Constants.formatError, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            continueButton.isEnabled = false
            error.text = text
            configureErrorView(errorView: errorView, error: error)
            errorView.isHidden = false
        } else if countDigits == .zero || !flag || password.text!.count < Int(Constants.coef3) {
            password.backgroundColor = Constants.red
            password.text = nil
            password.attributedPlaceholder = NSAttributedString(string: Constants.formatError, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            continueButton.isEnabled = false
            error.text = Constants.passwordFormatError
            configureErrorView(errorView: errorView, error: error)
            errorView.isHidden = false
        } else if password.text != Constants.nilString && passwordCopy.text != Constants.nilString && name.text != Constants.nilString {
            if password.text == passwordCopy.text {
                continueButton.isEnabled = false
                Task {
                    do {
                        let users = try await NetworkService.shared.getAllUsers()
                        DispatchQueue.main.async { [self] in
                            for user in users {
                                if name.text == user.name {
                                    name.attributedPlaceholder = NSAttributedString(string: Constants.nameTaken, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                                    name.backgroundColor = Constants.red
                                    name.text = nil
                                    continueButton.isEnabled = false
                                    error.text = Constants.nameError
                                    configureErrorView(errorView: errorView, error: error)
                                    errorView.isHidden = false
                                    return
                                }
                            }
                            configureThemes()
                            name.backgroundColor = Constants.green
                            password.backgroundColor = Constants.green
                            passwordCopy.backgroundColor = Constants.green
                        }
                    } catch {
                        print("Произошла ошибка: \(error)")
                        self.navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                    }
                }
            } else {
                passwordCopy.backgroundColor = Constants.red
                passwordCopy.text = Constants.nilString
                passwordCopy.attributedPlaceholder = NSAttributedString(string: Constants.differentPasswords, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            }
        }
    }
    
    @objc
    private func autoButtonWasPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    override func dismissKeyboard() {
        readyButton.isEnabled = true
        errorView.isHidden = true
        view.endEditing(true)
        if name.text != Constants.nilString && password.text != Constants.nilString && passwordCopy.text != Constants.nilString {
            continueButton.isEnabled = true
        } else {
            continueButton.isEnabled = false
        }
    }
    
    @objc
    private func backThemeButtonWasPressed() {
        stackField.isHidden = false
        continueButton.isHidden = false
        autoButton.isHidden = false
        themeView.isHidden = true
        readyButton.isHidden = true
        backButton.isHidden = true
    }
    
    @objc
    private func readyButtonWasPressed() {
        readyButton.isEnabled = false
        if themes.count != .zero {
            Task {
                do {
                    Vars.user = try await NetworkService.shared.createUser(name: name.text!, themes: themes, password: passwordCopy.text!)
                    DispatchQueue.main.async {
                        UserDefaults.standard.set([], forKey: Constants.usersKey)
                        self.navigationController?.pushViewController(RootViewController(), animated: true)
                    }
                } catch {
                    print("Произошла ошибка: \(error)")
                    self.navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                }
            }
        } else {
            error.text = Constants.themeError
            configureErrorView(errorView: errorView, error: error)
            errorView.isHidden = false
        }
    }
    
    private func configureThemes() {
        stackField.isHidden = true
        continueButton.isHidden = true
        autoButton.isHidden = true
        themeView.isHidden = false
        readyButton.isHidden = false
        backButton.isHidden = false
        
        configureThemeView()
    }
    
    private func configureThemeView() {
        view.addSubview(themeView)
        
        themeView.backgroundColor = Constants.color
        themeView.layer.borderWidth = Constants.coef5
        themeView.layer.borderColor = UIColor.black.cgColor
        themeView.layer.cornerRadius = Constants.value
        
        themeView.pinHorizontal(to: view, Constants.coef14)
        themeView.pinTop(to: txtLabel.bottomAnchor, Constants.coef14)
        themeView.pinBottom(to: stackButton.topAnchor, Constants.coef14)
        
        configureThemeLabel(themeView: themeView, themeLabel: themeLabel)
        configureThemeStack(themeView: themeView, themeLabel: themeLabel, themeStack: themeStack, themeOne: themeOne, themeTwo: themeTwo, themeThree: themeThree)
    }
    
    @objc
    override func themeButtonWasPressed(_ sender: UIButton) {
        var theme: Int = .zero
        switch sender {
        case themeOne:
            theme = Constants.one
        case themeTwo:
            theme = Int(Constants.coef5)
        default:
            theme = Int(Constants.coef18)
        }
        if themes.contains(theme) {
            sender.layer.borderColor = UIColor.black.cgColor
            themes.remove(at: themes.firstIndex(of: theme)!)
            if themes.count == .zero {
                readyButton.isEnabled = false
            }
        } else {
            sender.layer.borderColor = UIColor.green.cgColor
            themes.append(theme)
            readyButton.isEnabled = true
        }
    }
}
