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
    var buttonRating = UIButton()
    var buttonRoutes = UIButton()
    var barStack = UIStackView()
    var stick1 = UIView()
    var stick2 = UIView()
    var stick3 = UIView()
    var stickStack = UIStackView()
    var bar = UIView()
    var status = Int(Constants.coef24)
    
    func configureBar() {
        view.addSubview(bar)
        
        navigationItem.hidesBackButton = true
        
        bar.backgroundColor = Constants.color
        bar.layer.borderWidth = Constants.coef5
        bar.layer.borderColor = UIColor.black.cgColor
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.pinBottom(to: view)
        bar.pinHeight(to: view, Constants.avatarCoef3)
        bar.pinWidth(to: view)
        
        configureStickStack()
        configureBarStack()
    }
    
    func configureButtonProfile() {
        if (status == .zero) {
            buttonProfile.isEnabled = false
        } else {
            buttonProfile.isEnabled = true
        }
        
        buttonProfile.setBackgroundImage(UIImage(named: Constants.profilePng), for: .disabled)
        buttonProfile.setBackgroundImage(UIImage(named: Constants.profileGrayPng), for: .normal)
        
        buttonProfile.addTarget(self, action: #selector(buttonProfileWasTapped), for: .touchUpInside)
    }
    
    func configureButtonChat() {
        if (status == Constants.one) {
            buttonChat.isEnabled = false
        } else {
            buttonChat.isEnabled = true
        }
        
        buttonChat.setBackgroundImage(UIImage(named: Constants.chatPng), for: .disabled)
        buttonChat.setBackgroundImage(UIImage(named: Constants.chatGrayPng), for: .normal)
        
        buttonChat.addTarget(self, action: #selector(buttonChatWasTapped), for: .touchUpInside)
    }
    
    func configureButtonRating() {
        if (status == Int(Constants.coef5)) {
            buttonRating.isEnabled = false
        } else {
            buttonRating.isEnabled = true
        }
        
        buttonRating.setBackgroundImage(UIImage(named: Constants.ratingPng), for: .disabled)
        buttonRating.setBackgroundImage(UIImage(named: Constants.ratingGrayPng), for: .normal)
        
        buttonRating.addTarget(self, action: #selector(buttonRatingWasTapped), for: .touchUpInside)
    }
    
    func configureButtonRoutes() {
        if (status == Int(Constants.coef18)) {
            buttonRoutes.isEnabled = false
        } else {
            buttonRoutes.isEnabled = true
        }
        
        buttonRoutes.setBackgroundImage(UIImage(named: Constants.routesPng), for: .disabled)
        buttonRoutes.setBackgroundImage(UIImage(named: Constants.routesGrayPng), for: .normal)
        
        buttonRoutes.addTarget(self, action: #selector(buttonRoutesWasTapped), for: .touchUpInside)
    }
    
    func configureBarStack() {
        bar.addSubview(barStack)
        barStack.axis = .horizontal
        barStack.spacing = view.bounds.width * Constants.coef36
        
        for button in [buttonRoutes, buttonRating, buttonChat, buttonProfile] {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setWidth(view.bounds.width * Constants.coef16)
            button.setHeight(view.bounds.width * Constants.coef16)
            
            barStack.addArrangedSubview(button)
        }
        
        configureButtonRoutes()
        configureButtonRating()
        configureButtonChat()
        configureButtonProfile()
        
        barStack.translatesAutoresizingMaskIntoConstraints = false
        barStack.pinCenter(to: bar)
    }
    
    func configureStickStack() {
        bar.addSubview(stickStack)
        stickStack.axis = .horizontal
        stickStack.spacing = view.bounds.width * Constants.avatarCoef2
        
        for stick in [stick1, stick2, stick3] {
            stick.translatesAutoresizingMaskIntoConstraints = false
            stick.setWidth(Constants.coef5)
            stick.setHeight(view.bounds.height * Constants.avatarCoef3)
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
    func buttonRatingWasTapped() {
        let vc = RatingViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc
    func buttonRoutesWasTapped() {
        let vc = RoutesViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
}
