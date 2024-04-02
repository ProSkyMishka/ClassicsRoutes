//
//  ChatCell.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 31.03.2024.
//

import UIKit

final class ChatCell: UITableViewCell {
    static let reuseId: String = "ChatCellId"
    
    private let name = UILabel()
    private let circle = UIView()
    private let avatar = UIImageView()
    private let wrap: UIView = UIView()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with name: String, with avatar: String) {
        self.name.text = name
        if name == Vars.user?.name {
            wrap.backgroundColor = Constants.gold
        }
        UIViewController().returnImage(imageView: self.avatar, key: avatar)
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        addSubview(wrap)
        
        wrap.layer.borderWidth = CGFloat(Constants.one)
        wrap.backgroundColor = .gray
        wrap.layer.borderColor = UIColor.black.cgColor
        
        wrap.translatesAutoresizingMaskIntoConstraints = false
        wrap.pinVertical(to: self)
        wrap.pinHorizontal(to: self)
        
        wrap.addSubview(circle)
        circle.backgroundColor = Constants.color
        circle.setHeight(Constants.coef25)
        circle.setWidth(Constants.coef25)
        circle.layer.cornerRadius = Constants.coef26
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.pinCenterY(to: self)
        circle.pinLeft(to: self, Constants.coef14)
        
        circle.addSubview(avatar)
        avatar.setHeight(Constants.coef26)
        avatar.setWidth(Constants.coef27)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.pinCenter(to: circle)
        
        wrap.addSubview(name)
        name.textColor = .black
        name.font = UIFont.boldSystemFont(ofSize: Constants.horiz1)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.pinLeft(to: circle.trailingAnchor, Constants.coef)
        name.pinCenterY(to: self)
        name.setWidth(self.bounds.width * Constants.avatarCoef1)
    }
}
