//
//  PictureCell.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 29.02.2024.
//

import UIKit

class PictureCell: UICollectionViewCell {
    static let reuseIdentifier: String = "PictureCell"
    
    private let picture = UIImageView()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    func configureUI() {
        configurePicture()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Configuration
    func configure(with picture: String) {
        UIViewController().returnImage(imageView: self.picture, key: picture)
    }
    
    // MARK: - UI Configuration
    private func configurePicture() {
        addSubview(picture)
        
        picture.layer.cornerRadius = Constants.radius
        picture.layer.masksToBounds = true
        picture.pinHeight(to: heightAnchor)
        picture.pinWidth(to: widthAnchor)
    }
}
