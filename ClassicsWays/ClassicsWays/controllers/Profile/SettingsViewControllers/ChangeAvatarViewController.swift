//
//  ChangeAvatarViewController.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 26.02.2024.
//

import UIKit

final class ChangeAvatarViewController: UIViewController {
    private var boyAvatar = UIButton()
    private var girlAvatar = UIButton()
    private var readyButton = UIButton()
    private var stackAvavtar = UIStackView()
    private var choise = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        configureBackGroundImage()
        configureReadyButton()
        configureStackAvatar()
        configureBackButton()
    }
    
    private func configureBoyAvatar() {
        let image = UIImageView()
        returnImage(imageView: image, key: "boyAvatar.png")
        boyAvatar.addSubview(image)
        image.pinCenter(to: boyAvatar)
        image.setWidth(view.bounds.width * 0.72)
        image.setHeight(view.bounds.height * 0.27)
        
        boyAvatar.addTarget(self, action: #selector(imageBoyWasTapped), for: .touchUpInside)
    }
    
    private func configureGirlAvatar() {
        let image = UIImageView()
        returnImage(imageView: image, key: "girlAvatar.png")
        girlAvatar.addSubview(image)
        image.pinCenter(to: girlAvatar)
        image.setWidth(view.bounds.width * 0.72)
        image.setHeight(view.bounds.height * 0.27)
        
        girlAvatar.addTarget(self, action: #selector(imageGirlWasTapped), for: .touchUpInside)
    }
    
    private func configureStackAvatar() {
        view.addSubview(stackAvavtar)
        
        stackAvavtar.axis = .vertical
        stackAvavtar.spacing = view.bounds.height * 0.1
        
        for button in [boyAvatar, girlAvatar] {
            button.backgroundColor = .lightGray
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.cornerRadius = CGFloat(Constants.one)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setHeight(view.bounds.height * 0.3)
            button.setWidth(view.bounds.width * 0.8)
            stackAvavtar.addArrangedSubview(button)
        }
        
        configureBoyAvatar()
        configureGirlAvatar()
        
        stackAvavtar.translatesAutoresizingMaskIntoConstraints = false
        stackAvavtar.pinCenter(to: view)
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
        if choise != "" {
            readyButton.isEnabled = false
            Task {
                do {
                    Vars.user = try await NetworkService.shared.updateUser(id: Vars.user!.id, name: Vars.user!.name, email: Vars.user!.email, date: Vars.user!.date, avatar: choise, routes: Vars.user!.routes, role: Vars.user!.role, likes: Vars.user!.likes, themes: Vars.user!.themes, chats: Vars.user!.chats, password: Vars.password)
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(ProfileViewController(), animated: true)
                    }
                } catch {
                    print("Произошла ошибка: \(error)")
                    navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                }
            }
        }
    }
    
    @objc
    private func imageBoyWasTapped() {
        readyButton.isEnabled = true
        boyAvatar.backgroundColor = Constants.green
        girlAvatar.backgroundColor = Constants.red
        choise = "boyAvatar.png"
    }
    
    @objc
    private func imageGirlWasTapped() {
        readyButton.isEnabled = true
        boyAvatar.backgroundColor = Constants.red
        girlAvatar.backgroundColor = Constants.green
        choise = "girlAvatar.png"
    }
}
