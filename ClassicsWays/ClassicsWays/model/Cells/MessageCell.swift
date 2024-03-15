//
//  MessageCell.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 05.03.2024.
//

import UIKit

final class MessageCell: UICollectionViewCell {
    static let reuseId: String = "MessageCell"
    
    private let name = UILabel()
    private let message = UILabel()
    private let messageView = UIView()
    private let avatar = UIImageView()
    private let wrap: UIView = UIView()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with name: String, with message: String, with avatar: String) {
        self.name.text = name
        if name == Vars.user?.name {
            print("asd")
            self.avatar.pinRight(to: self, 10)
            self.name.isHidden = true
            self.message.pinRight(to: self.avatar.leadingAnchor, 10)
            self.avatar.pinBottom(to: self)
        } else {
            self.avatar.pinLeft(to: self, 10)
            self.message.pinLeft(to: self.avatar.trailingAnchor, 10)
            self.avatar.pinBottom(to: self, 23)
        }
        self.message.text = message
        UIViewController().returnImage(imageView: self.avatar, key: avatar)
    }
    
    private func configureUI() {
        self.addSubview(avatar)
        avatar.setHeight(40)
        avatar.setWidth(50)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(name)
        name.textColor = Constants.color
        name.font = UIFont.boldSystemFont(ofSize: 18)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.pinCenterX(to: avatar)
        name.setWidth(50)
        name.pinBottom(to: self)
        
        self.addSubview(message)
        message.textColor = .black
        message.font = UIFont.boldSystemFont(ofSize: 18)
        message.lineBreakMode = .byWordWrapping
        message.numberOfLines = .zero
        message.translatesAutoresizingMaskIntoConstraints = false
        message.backgroundColor = Constants.color
        message.layer.cornerCurve = CALayerCornerCurve.circular
        
        message.setWidth(190)
        message.pinBottom(to: self, 5)
        
//        wrap.addSubview(messageView)
//        messageView.backgroundColor = Constants.color
//        messageView.layer.borderWidth = CGFloat(Constants.one)
//        messageView.layer.borderColor = UIColor.black.cgColor
//        messageView.layer.cornerRadius = Constants.radius
//        messageView.translatesAutoresizingMaskIntoConstraints = false
//        messageView.pinVertical(to: message, -5)
//        messageView.pinCenterX(to: message)
//        messageView.setWidth(200)
    }
}

