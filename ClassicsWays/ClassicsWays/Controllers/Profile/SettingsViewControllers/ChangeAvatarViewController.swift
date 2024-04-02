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
    private var choise = Constants.nilString
    
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
        returnImage(imageView: image, key: Constants.boyAvatar)
        boyAvatar.addSubview(image)
        image.pinCenter(to: boyAvatar)
        image.setWidth(view.bounds.width * Constants.coef42)
        image.setHeight(view.bounds.height * Constants.coef43)
        
        boyAvatar.addTarget(self, action: #selector(imageBoyWasTapped), for: .touchUpInside)
    }
    
    private func configureGirlAvatar() {
        let image = UIImageView()
        returnImage(imageView: image, key: Constants.girlAvatar)
        girlAvatar.addSubview(image)
        image.pinCenter(to: girlAvatar)
        image.setWidth(view.bounds.width * Constants.coef42)
        image.setHeight(view.bounds.height * Constants.coef43)
        
        girlAvatar.addTarget(self, action: #selector(imageGirlWasTapped), for: .touchUpInside)
    }
    
    private func configureStackAvatar() {
        view.addSubview(stackAvavtar)
        
        stackAvavtar.axis = .vertical
        stackAvavtar.spacing = view.bounds.height / Constants.coef14
        
        for button in [boyAvatar, girlAvatar] {
            button.backgroundColor = .lightGray
            button.layer.borderWidth = Constants.coef5
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.cornerRadius = CGFloat(Constants.one)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setHeight(view.bounds.height * Constants.coef10)
            button.setWidth(view.bounds.width * Constants.avatarCoef1)
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
        if choise != Constants.nilString {
            readyButton.isEnabled = false
            Task {
                do {
                    Vars.user = try await NetworkService.shared.updateUser(id: Vars.user!.id, name: Vars.user!.name, date: Vars.user!.date, avatar: choise, routes: Vars.user!.routes, role: Vars.user!.role, likes: Vars.user!.likes, themes: Vars.user!.themes, password: Vars.password)
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
        choise = Constants.boyAvatar
    }
    
    @objc
    private func imageGirlWasTapped() {
        readyButton.isEnabled = true
        boyAvatar.backgroundColor = Constants.red
        girlAvatar.backgroundColor = Constants.green
        choise = Constants.girlAvatar
    }
}
