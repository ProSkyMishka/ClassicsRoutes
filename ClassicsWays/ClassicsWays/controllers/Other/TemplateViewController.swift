//
//  TemplateViewController.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 25.02.2024.
//

import UIKit

class TemplateViewController: UIViewController {
    var buttonProfile = UIButton()
    var buttonChat = UIButton()
    var buttonRaiting = UIButton()
    var buttonRoutes = UIButton()
    var barStack = UIStackView()
    var stick1 = UIView()
    var stick2 = UIView()
    var stick3 = UIView()
    var stickStack = UIStackView()
    var bar = UIView()
    var status = -1
    
    func configureBar() {
        view.addSubview(bar)
        
        navigationItem.hidesBackButton = true
        
        bar.backgroundColor = Constants.color
        bar.layer.borderWidth = 2
        bar.layer.borderColor = UIColor.black.cgColor
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.pinBottom(to: view)
        bar.pinHeight(to: view, 0.07)
        bar.pinWidth(to: view)
        
        configureStickStack()
        configureBarStack()
    }
    
    func configureButtonProfile() {
        if (status == 0) {
            buttonProfile.isEnabled = false
        } else {
            buttonProfile.isEnabled = true
        }
        
        buttonProfile.setBackgroundImage(UIImage(named: "profile.png"), for: .disabled)
        buttonProfile.setBackgroundImage(UIImage(named: "profileGray.png"), for: .normal)
        
        buttonProfile.addTarget(self, action: #selector(buttonProfileWasTapped), for: .touchUpInside)
    }
    
    func configureButtonChat() {
        if (status == 1) {
            buttonChat.isEnabled = false
        } else {
            buttonChat.isEnabled = true
        }
        
        buttonChat.setBackgroundImage(UIImage(named: "chat.png"), for: .disabled)
        buttonChat.setBackgroundImage(UIImage(named: "chatGray.png"), for: .normal)
        
        buttonChat.addTarget(self, action: #selector(buttonChatWasTapped), for: .touchUpInside)
    }
    
    func configureButtonRaiting() {
        if (status == 2) {
            buttonRaiting.isEnabled = false
        } else {
            buttonRaiting.isEnabled = true
        }
        
        buttonRaiting.setBackgroundImage(UIImage(named: "raiting.png"), for: .disabled)
        buttonRaiting.setBackgroundImage(UIImage(named: "raitingGray.png"), for: .normal)
        
        buttonRaiting.addTarget(self, action: #selector(buttonRaitingWasTapped), for: .touchUpInside)
    }
    
    func configureButtonRoutes() {
        if (status == 3) {
            buttonRoutes.isEnabled = false
        } else {
            buttonRoutes.isEnabled = true
        }
        
        buttonRoutes.setBackgroundImage(UIImage(named: "routes.png"), for: .disabled)
        buttonRoutes.setBackgroundImage(UIImage(named: "routesGray.png"), for: .normal)
        
        buttonRoutes.addTarget(self, action: #selector(buttonRoutesWasTapped), for: .touchUpInside)
    }
    
    func configureBarStack() {
        bar.addSubview(barStack)
        barStack.axis = .horizontal
        barStack.spacing = view.bounds.width * 0.2
        
        for button in [buttonRoutes, buttonRaiting, /*buttonChat, */buttonProfile] {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setWidth(view.bounds.height * 0.05)
            button.setHeight(view.bounds.height * 0.05)
            
            barStack.addArrangedSubview(button)
        }
        
        configureButtonRoutes()
        configureButtonRaiting()
//        configureButtonChat()
        configureButtonProfile()
        
        barStack.translatesAutoresizingMaskIntoConstraints = false
        barStack.pinBottom(to: bar.bottomAnchor, view.bounds.height * 0.01)
        barStack.pinCenterX(to: view)
    }
    
    func configureStickStack() {
        bar.addSubview(stickStack)
        stickStack.axis = .horizontal
        stickStack.spacing = view.bounds.width * 0.2 + view.bounds.height * 0.05
        
        for stick in [stick1, stick2/*, stick3*/] {
            stick.translatesAutoresizingMaskIntoConstraints = false
            stick.setWidth(2)
            stick.setHeight(view.bounds.height * 0.07)
            stick.backgroundColor = .black
            
            stickStack.addArrangedSubview(stick)
        }
        
        stickStack.translatesAutoresizingMaskIntoConstraints = false
        stickStack.pinBottom(to: view)
        stickStack.pinCenterX(to: view)
    }
    
    @objc
    func buttonProfileWasTapped() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc
    func buttonChatWasTapped() {
        let vc = ChatsViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc
    func buttonRaitingWasTapped() {
        let vc = RaitingViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc
    func buttonRoutesWasTapped() {
        let vc = RoutesViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
}
