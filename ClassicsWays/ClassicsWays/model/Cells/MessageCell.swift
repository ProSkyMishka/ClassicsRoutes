//
//  MessageCell.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 05.03.2024.
//

import UIKit
import Foundation

final class MessageCell: UICollectionViewCell {
    static let reuseId: String = "MessageCell"
    
    private var name = UILabel()
    private var message = UILabel()
    private var avatar = UIImageView()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with name: String, with message: String, with avatar: String, with height: Double) -> Double {
        self.avatar.isHidden = true
        self.name.isHidden = true
        self.message.isHidden = true
        configureUI()
        self.message.font = UIFont.boldSystemFont(ofSize: height * 0.02)
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
        let number = numberOfLines()
        var coef = 1.0
        if number > 3 {
            coef = (Double(number) / 3.0)
            self.message.numberOfLines = number
        }
        UIViewController().returnImage(imageView: self.avatar, key: avatar)
        return coef
    }
    
    private func configureUI() {
        avatar = UIImageView()
        
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.setHeight(40)
        avatar.setWidth(50)
        
        addSubview(avatar)
        
        name = UILabel()
        
        addSubview(name)
        
        name.textColor = Constants.color
        name.font = UIFont.boldSystemFont(ofSize: 18)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.pinCenterX(to: avatar)
        name.setWidth(50)
        name.pinBottom(to: self)
        
        message = UILabel()
        
        addSubview(message)
        
        message.textColor = .black
        message.lineBreakMode = .byWordWrapping
        message.numberOfLines = 3
        message.translatesAutoresizingMaskIntoConstraints = false
        message.backgroundColor = Constants.color
        
        message.setWidth(self.bounds.width * 0.6)
        message.pinBottom(to: self, 5)
    }
    
    func numberOfLines() -> Int {
        message.numberOfLines = 200000
        let size = message.sizeThatFits(CGSize(width: self.bounds.width * 0.6, height: CGFloat.greatestFiniteMagnitude))
        let numberOfLines = Int(size.height / message.font.lineHeight)
        message.numberOfLines = 3
        
        return numberOfLines
    }
}

