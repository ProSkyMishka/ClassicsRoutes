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
            wrap.layer.borderWidth = Constants.coef14
        }
        self.name.text = name
        UIViewController().returnImage(imageView: self.avatar, key: avatar)
        self.name.font = UIFont.boldSystemFont(ofSize: height * Constants.coef28)
        self.person.font = UIFont.boldSystemFont(ofSize: height * Constants.coef29)
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        addSubview(wrap)
        wrap.layer.borderWidth = CGFloat(Constants.one)
        wrap.backgroundColor = Constants.color
        wrap.layer.borderColor = UIColor.black.cgColor
        wrap.layer.cornerRadius = Constants.value
        wrap.translatesAutoresizingMaskIntoConstraints = false
        wrap.pinHeight(to: heightAnchor, Constants.coef17)
        wrap.pinWidth(to: widthAnchor, Constants.coef17)
        wrap.pinCenter(to: self)
        
        wrap.addSubview(avatar)
        avatar.layer.cornerRadius = Constants.value
        avatar.layer.masksToBounds = true
        avatar.pinHeight(to: heightAnchor, Constants.coef30)
        avatar.pinWidth(to: widthAnchor, Constants.coef31)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.pinRight(to: wrap, Constants.coef14)
        avatar.pinTop(to: wrap, Constants.coef14)
        
        wrap.addSubview(person)
        person.textColor = .black
        person.translatesAutoresizingMaskIntoConstraints = false
        person.lineBreakMode = .byWordWrapping
        person.numberOfLines = Int(Constants.coef18)
        person.pinLeft(to: wrap, Constants.coef14)
        person.pinRight(to: avatar.leadingAnchor, Constants.coef14)
        person.pinTop(to: wrap, Constants.coef14)
        
        wrap.addSubview(name)
        name.textColor = .black
        name.translatesAutoresizingMaskIntoConstraints = false
        name.lineBreakMode = .byWordWrapping
        name.numberOfLines = Int(Constants.coef5)
        name.pinCenterX(to: wrap)
        name.pinWidth(to: widthAnchor, Constants.coef12)
        name.pinBottom(to: wrap, Constants.coef14)
        name.textAlignment = .center
    }
}
