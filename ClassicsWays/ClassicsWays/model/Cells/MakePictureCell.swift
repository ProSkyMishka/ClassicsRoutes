//
//  MakePictureCell.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 26.03.2024.
//

import UIKit

class MakePictureCell: UICollectionViewCell {
    static let reuseIdentifier: String = "MakePictureCell"
    
    private var picture = UIImageView()
    private let trash = UIButton()
    
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
    func configure(with picture: UIImageView) {
        self.picture = picture
        
        configurePicture()
    }
    
    // MARK: - UI Configuration
    private func configurePicture() {
        addSubview(picture)
        
        picture.pinHeight(to: heightAnchor)
        picture.pinWidth(to: widthAnchor)
    }
}
