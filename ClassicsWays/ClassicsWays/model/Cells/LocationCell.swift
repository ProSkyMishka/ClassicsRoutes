//
//  LocationCell.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 22.03.2024.
//

import UIKit

final class LocationCell: UITableViewCell {
    static let reuseId: String = "LocationCell"
    
    private enum ThisConstants {
        static let wrapColor: UIColor = .white
        static let wrapRadius: CGFloat = 16
        static let wrapOffsetV: CGFloat = 5
        static let wrapOffsetH: CGFloat = 10
        static let wishLabelOffset: CGFloat = 8
    }
    
    private let wishLabel: UILabel = UILabel()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with place: String) {
        wishLabel.text = place
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        let wrap: UIView = UIView()
        addSubview(wrap)
        
        wrap.backgroundColor = ThisConstants.wrapColor
        wrap.layer.cornerRadius = ThisConstants.wrapRadius
        wrap.pinVertical(to: self, ThisConstants.wrapOffsetV)
        wrap.pinHorizontal(to: self, ThisConstants.wrapOffsetH)
        
        wrap.addSubview(wishLabel)
        wishLabel.textColor = .black
        wishLabel.pin(to: wrap, ThisConstants.wishLabelOffset)
    }
}
