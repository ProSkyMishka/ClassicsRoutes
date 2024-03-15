//
//  RootViewController.swift
//  Курсач
//
//  Created by Михаил Прозорский on 18.09.2023.
//

import UIKit

class RootViewController: UIViewController {
    private let defaults = UserDefaults.standard
    var txtLabel = UILabel()
    var stackField = UIStackView()
    var stackButton = UIStackView()
    var email = UITextField()
    var password = UITextField()
    var comeButton = UIButton()
    var regButton = UIButton()
    var users: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        configureUI()
    }
    
    private func configureUI() {
        configureBackGroundImage()
        hideKeyboardOnTapAround()
        configureTxtLabel()
        configureStackField()
        configureStackButton()
    }
    
    private func configureTxtLabel() {
        view.addSubview(txtLabel)
        
        txtLabel.text = "Авторизация"
        txtLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef)
        txtLabel.textColor = .white
        txtLabel.shadowColor = .black
        txtLabel.shadowOffset = Constants.shadow
        
        txtLabel.translatesAutoresizingMaskIntoConstraints = false
        txtLabel.pinCenterX(to: view)
        txtLabel.pinTop(to: view, Double(view.bounds.height / Constants.coef1))
    }
    
    private func configureEmail() {
        email.attributedPlaceholder = NSAttributedString(string: "Имя", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    private func configurePassword() {
        password.attributedPlaceholder = NSAttributedString(string: "Пароль", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    private func configureComeButton() {
        comeButton.setTitle("Войти", for: .normal)
        
        comeButton.addTarget(self, action: #selector(comeButtonWasPressed), for: .touchUpInside)
    }
    
    private func configureRegButton() {
        regButton.setTitle("Нет аккаунта", for: .normal)
        
        regButton.addTarget(self, action: #selector(regButtonWasPressed), for: .touchUpInside)
    }
    
    private func configureStackField() {
        view.addSubview(stackField)
        
        stackField.axis = .vertical
        stackField.spacing = Double(view.bounds.height / Constants.coef)
        
        for field in [email, password] {
            field.returnKeyType = UIReturnKeyType.done
            
            field.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef2)
            field.textColor = .black
            field.backgroundColor = Constants.color
            field.layer.cornerRadius = Constants.radius
            
            field.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
            field.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
            field.leftViewMode = .always
            field.rightViewMode = .always
            field.layer.borderWidth = CGFloat(Constants.one)
            field.layer.borderColor = UIColor.black.cgColor
            
            field.translatesAutoresizingMaskIntoConstraints = false
            field.setHeight(Double(view.bounds.height / Constants.coef4))
            field.setWidth(Double(view.bounds.width / Constants.coef6))
            stackField.addArrangedSubview(field)
        }
        
        configureEmail()
        configurePassword()
        
        stackField.translatesAutoresizingMaskIntoConstraints = false
        stackField.pinTop(to: txtLabel, Double(view.bounds.height / Constants.coef3))
        stackField.pinCenterX(to: view)
    }
    
    private func configureStackButton() {
        view.addSubview(stackButton)
        
        stackButton.axis = .vertical
        stackButton.spacing = Double(view.bounds.height / Constants.coef)
        
        for button in [comeButton, regButton] {
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef2)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.darkGray, for: .disabled)
            button.backgroundColor = Constants.color
            button.layer.cornerRadius = Constants.radius
            
            button.layer.borderWidth = CGFloat(Constants.one)
            button.layer.borderColor = UIColor.black.cgColor
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setHeight(Double(view.bounds.height / Constants.coef4))
            button.setWidth(Double(view.bounds.width / Constants.coef5))
            stackButton.addArrangedSubview(button)
        }
        
        configureComeButton()
        configureRegButton()
        
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        stackButton.pinTop(to: stackField.bottomAnchor, Double(view.bounds.height / Constants.coef))
        stackButton.pinCenterX(to: view)
    }
    
    @objc
    private func comeButtonWasPressed() {
        auth(email: email.text!, password: password.text!)
    }
    
    @objc
    private func regButtonWasPressed() {
        email.text = nil
        password.text = nil
        let vc = MainRegistrationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func auth(email: String, password: String) {
        comeButton.isEnabled = false
        regButton.isEnabled = false
        Task {
            do {
                Vars.user = try await NetworkService.shared.auth(name: email, password: password)
                DispatchQueue.main.async {
                    Vars.password = password
                    self.users.append(email)
                    self.users.append(password)
                    self.defaults.set(self.users, forKey: Constants.usersKey)
                    let vc = ProfileViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } catch {
                comeButton.isEnabled = true
                regButton.isEnabled = true
                print("Произошла ошибка: \(error)")
            }
        }
    }
}
