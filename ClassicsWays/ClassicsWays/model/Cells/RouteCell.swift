//
//  RouteCell.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 28.02.2024.
//

import UIKit

final class RouteCell: UITableViewCell {
    static let reuseId: String = "RouteCellId"
    
    private let person = UILabel()
    private let name = UILabel()
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
    
    func configure(with person: String, with name: String, with avatar: String, with id: String, with height: Double) {
        self.person.text = person
        if Vars.user!.routes.contains(id) {
            wrap.layer.borderColor = Constants.gold.cgColor
            wrap.layer.borderWidth = 10
        }
        self.name.text = name
        UIViewController().returnImage(imageView: self.avatar, key: avatar)
        self.name.font = UIFont.boldSystemFont(ofSize: height * 0.028)
        self.person.font = UIFont.boldSystemFont(ofSize: height * 0.042)
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        addSubview(wrap)
        wrap.layer.borderWidth = CGFloat(Constants.one)
        wrap.backgroundColor = Constants.color
        wrap.layer.borderColor = UIColor.black.cgColor
        wrap.layer.cornerRadius = Constants.radius
        wrap.translatesAutoresizingMaskIntoConstraints = false
        wrap.pinHeight(to: heightAnchor, 0.9)
        wrap.pinWidth(to: widthAnchor, 0.9)
        wrap.pinCenter(to: self)
        
        wrap.addSubview(avatar)
        avatar.pinHeight(to: heightAnchor, 0.52)
        avatar.pinWidth(to: widthAnchor, 0.37)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.pinRight(to: wrap, 10)
        avatar.pinTop(to: wrap, 10)
        
        wrap.addSubview(person)
        person.textColor = .black
        person.translatesAutoresizingMaskIntoConstraints = false
        person.lineBreakMode = .byWordWrapping
        person.numberOfLines = .zero
        person.pinLeft(to: wrap, 10)
        person.pinRight(to: avatar.leadingAnchor, 10)
        person.pinTop(to: wrap, 10)
        
        wrap.addSubview(name)
        name.textColor = .black
        name.translatesAutoresizingMaskIntoConstraints = false
        name.lineBreakMode = .byWordWrapping
        name.numberOfLines = .zero
        name.pinCenterX(to: wrap)
        name.pinWidth(to: widthAnchor, 0.85)
        name.pinBottom(to: wrap, 10)
        name.textAlignment = .center
    }
}
