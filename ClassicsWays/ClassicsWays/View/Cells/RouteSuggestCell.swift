//
//  RouteSuggestCell.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 01.04.2024.
//

import UIKit

final class RouteSuggestCell: UICollectionViewCell {
    static let reuseId: String = "RouteSuggestCellId"
    
    private let person = UILabel()
    private let name = UILabel()
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
    
    func configure(with routeId: String, with height: Double) {
        Task {
            do {
                let route = try await NetworkService.shared.getRoute(id: routeId).route!
                DispatchQueue.main.async {
                    UIViewController().returnImage(imageView: self.avatar, key: route.avatar)
                    self.person.text = route.person
                    self.name.text = route.name
                }
            } catch {
                
            }
        }
        self.name.font = UIFont.boldSystemFont(ofSize: height * Constants.coef28)
        self.person.font = UIFont.boldSystemFont(ofSize: height * Constants.coef29)
    }
    
    private func configureUI() {
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
        
        configureAvatar()
        
        wrap.addSubview(person)
        person.textColor = .black
        person.translatesAutoresizingMaskIntoConstraints = false
        person.lineBreakMode = .byWordWrapping
        person.numberOfLines = Int(Constants.coef5)
        person.pinLeft(to: wrap, Constants.coef14)
        person.pinRight(to: avatar.leadingAnchor, Constants.coef14)
        person.pinTop(to: wrap, Constants.coef14)
        
        wrap.addSubview(name)
        name.textColor = .black
        name.translatesAutoresizingMaskIntoConstraints = false
        name.lineBreakMode = .byWordWrapping
        name.numberOfLines = Constants.one
        name.pinCenterX(to: wrap)
        name.pinWidth(to: widthAnchor, Constants.coef12)
        name.pinBottom(to: wrap, Constants.coef14)
        name.textAlignment = .center
    }
    
    private func configureAvatar() {
        wrap.addSubview(avatar)
        
        avatar.layer.cornerRadius = Constants.value
        avatar.layer.masksToBounds = true
        avatar.pinHeight(to: heightAnchor, Constants.coef30)
        avatar.pinWidth(to: widthAnchor, Constants.coef31)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.pinRight(to: wrap, Constants.coef14)
        avatar.pinTop(to: wrap, Constants.coef14)
    }
}
