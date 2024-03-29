//
//  MessageCell.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 05.03.2024.
//

import UIKit

final class MessageCell: UICollectionViewCell {
    static let reuseId: String = "MessageCell"
    
    private var name = UILabel()
    private var message = UILabel()
    private var avatar = UIImageView()
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
        self.avatar.isHidden = true
        self.name.isHidden = true
        self.message.isHidden = true
        configureUI()
        self.name.text = name
        
        if name == Vars.user?.name {
            self.avatar.pinRight(to: self, 10)
            self.name.isHidden = true
            self.message.pinRight(to: self.avatar.leadingAnchor, 10)
            self.avatar.pinBottom(to: self)
        } else {
            self.avatar.pinLeft(to: self, 10)
            self.name.isHidden = false
            self.message.pinLeft(to: self.avatar.trailingAnchor, 10)
            self.avatar.pinBottom(to: self, 23)
        }
        self.message.text = message
        UIViewController().returnImage(imageView: self.avatar, key: avatar)
    }
    
    private func configureUI() {
        self.avatar = UIImageView()

        self.avatar.setHeight(40)
        self.avatar.setWidth(50)
        self.avatar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.avatar)
        
        self.name = UILabel()
        
        self.addSubview(self.name)
    
        self.name.textColor = Constants.color
        self.name.font = UIFont.boldSystemFont(ofSize: 18)
        self.name.translatesAutoresizingMaskIntoConstraints = false
        
        self.name.pinCenterX(to: self.avatar)
        self.name.setWidth(50)
        self.name.pinBottom(to: self)
        
        self.message = UILabel()
        
        self.addSubview(self.message)
        
        self.message.textColor = .black
        self.message.font = UIFont.boldSystemFont(ofSize: 18)
        self.message.lineBreakMode = .byWordWrapping
        self.message.numberOfLines = .zero
        self.message.translatesAutoresizingMaskIntoConstraints = false
        self.message.backgroundColor = Constants.color
        self.message.layer.cornerCurve = CALayerCornerCurve.circular

        self.message.setWidth(190)
        self.message.pinBottom(to: self, 5)
        
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

