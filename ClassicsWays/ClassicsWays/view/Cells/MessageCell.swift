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
        self.message.font = UIFont.boldSystemFont(ofSize: height * Constants.coef20)
        self.name.text = name

        if name == Vars.user?.name {
            self.avatar.pinRight(to: self, Constants.coef14)
            self.name.isHidden = true
            self.message.pinRight(to: self.avatar.leadingAnchor, Constants.coef14)
            self.avatar.pinBottom(to: self)
        } else {
            self.avatar.pinLeft(to: self, Constants.coef14)
            self.name.isHidden = false
            self.message.pinLeft(to: self.avatar.trailingAnchor, Constants.coef14)
            self.avatar.pinBottom(to: self, Constants.coef14)
        }
        self.message.text = message
        let number = numberOfLines()
        var coef: Double = Double(Constants.one)
        if number > Int(Constants.coef18) {
            coef = (Double(number) / Constants.coef18)
            self.message.numberOfLines = number
        }
        UIViewController().returnImage(imageView: self.avatar, key: avatar)
        return coef
    }
    
    private func configureUI() {
        avatar = UIImageView()
        
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.setHeight(Constants.coef26)
        avatar.setWidth(Constants.coef27)
        
        addSubview(avatar)
        
        name = UILabel()
        
        addSubview(name)
        
        name.textColor = Constants.color
        name.font = UIFont.boldSystemFont(ofSize: Constants.coef4)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.pinCenterX(to: avatar)
        name.setWidth(Constants.coef27)
        name.pinBottom(to: self)
        
        message = UILabel()
        
        addSubview(message)
        
        message.textColor = .black
        message.lineBreakMode = .byWordWrapping
        message.numberOfLines = Int(Constants.coef18)
        message.translatesAutoresizingMaskIntoConstraints = false
        message.backgroundColor = Constants.color
        
        message.setWidth(self.bounds.width * Constants.coef32)
        message.pinBottom(to: self, Constants.coef7)
    }
    
    func numberOfLines() -> Int {
        message.numberOfLines = Int(Constants.coef33)
        let size = message.sizeThatFits(CGSize(width: self.bounds.width * Constants.coef32, height: CGFloat.greatestFiniteMagnitude))
        let numberOfLines = Int(size.height / message.font.lineHeight)
        message.numberOfLines = Int(Constants.coef18)
        
        return numberOfLines
    }
}
