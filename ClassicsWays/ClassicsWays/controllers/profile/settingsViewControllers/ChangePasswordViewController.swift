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
        case .zero:
            passwordLabel = passwordLabelOld
            passwordView = passwordViewOld
            passwordLabel.text = Constants.oldPasswordString
        case Constants.one:
            passwordLabel = passwordLabelNew
            passwordView = passwordViewNew
            passwordLabel.text = Constants.newPasswordString
        default:
            passwordLabel = passwordLabelNewCopy
            passwordView = passwordViewNewCopy
            passwordLabel.text = Constants.repeatString
        }
        
        passwordView.addSubview(passwordLabel)
        
        passwordLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.height * Constants.coef29)
        passwordLabel.textColor = .black
        
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.pinCenterX(to: passwordView)
        passwordLabel.pinTop(to: passwordView, view.bounds.height * Constants.coef20)
    }
    
    private func configurePasswordField(type: Int) {
        var passwordField = UITextField()
        var passwordView = UIView()
        var passwordLabel = UILabel()
        var text: String = Constants.nilString
        switch type {
        case .zero:
            passwordLabel = passwordLabelOld
            passwordField = passwordFieldOld
            passwordView = passwordViewOld
            text = Constants.inputOldPassword
        case Constants.one:
            passwordLabel = passwordLabelNew
            passwordField = passwordFieldNew
            passwordView = passwordViewNew
            text = Constants.inputNewPassword
        default:
            passwordLabel = passwordLabelNewCopy
            passwordField = passwordFieldNewCopy
            passwordView = passwordViewNewCopy
            text = Constants.repeatNewPassword
        }
        
        passwordView.addSubview(passwordField)

        passwordField.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        passwordField.returnKeyType = UIReturnKeyType.done
        
        passwordField.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef2)
        passwordField.textColor = .black
        passwordField.backgroundColor = .white
        passwordField.layer.cornerRadius = view.bounds.height * Constants.coef20
        
        passwordField.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
        passwordField.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
        passwordField.leftViewMode = .always
        passwordField.rightViewMode = .always
        passwordField.layer.borderWidth = CGFloat(Constants.one)
        passwordField.layer.borderColor = UIColor.black.cgColor
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.pinCenterX(to: passwordView)
        passwordField.pinTop(to: passwordLabel.bottomAnchor, view.bounds.height * Constants.coef20)
        passwordField.setHeight(view.bounds.height * Constants.coef29)
        passwordField.setWidth(view.bounds.width * Constants.avatarCoef1)
    }
    
    private func configurePasswordStack() {
        view.addSubview(passwordStack)
        
        passwordStack.axis = .vertical
        passwordStack.spacing = view.bounds.height * Constants.coef20
        
        var i: Int = .zero
        for password in [passwordViewOld, passwordViewNew, passwordViewNewCopy] {
            password.backgroundColor = Constants.color
            password.layer.borderWidth = Constants.coef5
            password.layer.borderColor = UIColor.black.cgColor
            password.layer.cornerRadius = Constants.value
            
            password.translatesAutoresizingMaskIntoConstraints = false
            password.setWidth(view.bounds.width * Constants.coef17)
            password.setHeight(view.bounds.height * Constants.coef40)
            
            configurePasswordLabel(type: i)
            configurePasswordField(type: i)
            i += Constants.one
            
            passwordStack.addArrangedSubview(password)
        }
        
        passwordStack.translatesAutoresizingMaskIntoConstraints = false
        passwordStack.pinCenterX(to: view)
        passwordStack.pinBottom(to: view.keyboardLayoutGuide.topAnchor, Constants.avatarCoef3 * view.bounds.height)
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
        readyButton.pinHeight(to: view, Constants.coef44)
        readyButton.pinBottom(to: view)
        
        readyButton.addTarget(self, action: #selector(readyButtonWasPressed), for: .touchUpInside)
    }
    
    @objc
    private func readyButtonWasPressed() {
        var countDigits: Int = .zero
        var flag = true
        for i in passwordFieldNew.text! {
            if Constants.digits.contains(i) {
                countDigits += Constants.one
            }
            if !Constants.letters.contains(i) && !Constants.digits.contains(i) {
                flag = false
            }
        }
        if countDigits == .zero || !flag || passwordFieldNew.text!.count < Int(Constants.coef3) {
            passwordViewNew.backgroundColor = Constants.red
            passwordFieldNew.text = nil
            passwordFieldNew.attributedPlaceholder = NSAttributedString(string: Constants.formatError, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            readyButton.isEnabled = false
            error.text = Constants.passwordFormatError
            configureErrorView(errorView: errorView, error: error)
            errorView.isHidden = false
        } else if passwordFieldNewCopy.text != Constants.nilString && passwordFieldNew.text != Constants.nilString && passwordFieldOld.text != Constants.nilString {
            if passwordFieldOld.text == Vars.password {
                if passwordFieldNew.text == passwordFieldNewCopy.text {
                    readyButton.isEnabled = false
                    passwordViewNewCopy.backgroundColor = Constants.green
                    passwordViewNew.backgroundColor = Constants.green
                    passwordViewOld.backgroundColor = Constants.green
                    Task {
                        do {
                            Vars.user = try await NetworkService.shared.updateUser(id: Vars.user!.id, name: Vars.user!.name, date: Vars.user!.date, avatar: Vars.user!.avatar, routes: Vars.user!.routes, role: Vars.user!.role, likes: Vars.user!.likes, themes: Vars.user!.themes, password: passwordFieldNewCopy.text!)
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
                    passwordViewNewCopy.backgroundColor = Constants.red
                    passwordFieldNewCopy.text = Constants.nilString
                    passwordFieldNewCopy.attributedPlaceholder = NSAttributedString(string: Constants.differentPasswords, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                }
            } else {
                passwordViewOld.backgroundColor = Constants.red
                passwordFieldOld.text = Constants.nilString
                passwordFieldOld.attributedPlaceholder = NSAttributedString(string: Constants.notCome, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
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
        if passwordFieldNewCopy.text != Constants.nilString && passwordFieldNew.text != Constants.nilString && passwordFieldOld.text != Constants.nilString {
            readyButton.isEnabled = true
        } else {
            readyButton.isEnabled = false
        }
    }
}
