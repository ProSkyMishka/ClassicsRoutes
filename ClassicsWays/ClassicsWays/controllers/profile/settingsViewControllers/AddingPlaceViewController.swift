//
//  AddingPlaceViewController.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 15.03.2024.
//

import UIKit

class AddingPlaceViewController: UIViewController {
    private var coordinate = UITextField()
    private var placeDesc = UITextView()
    private var descLabel = UILabel()
    private var coordLabel = UILabel()
    private var addButton = UIButton()
    var didAdd: ((_ item: (String, String)) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        configureBackGroundImage()
        hideKeyboardOnTapAround(view)
        configureCoordLabel()
        configureCoordinate()
        configureAddButton()
        configureDescLabel()
        configurePlaceDesc()
    }
    
    private func configureCoordLabel() {
        view.addSubview(coordLabel)
        
        coordLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.height * Constants.coef11)
        coordLabel.text = Constants.inputCoordinates
        coordLabel.textColor = Constants.color
        
        coordLabel.pinCenterX(to: view)
        coordLabel.pinTop(to: view, view.bounds.height * Constants.coef11)
    }
    
    private func configureCoordinate() {
        view.addSubview(coordinate)
        
        coordinate.text = Constants.nilString
        coordinate.attributedPlaceholder = NSAttributedString(string: Constants.coordinatesFormat, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        coordinate.returnKeyType = UIReturnKeyType.done
        
        coordinate.font = UIFont.boldSystemFont(ofSize: view.bounds.height * Constants.coef8)
        coordinate.textColor = .black
        coordinate.backgroundColor = .white
        coordinate.layer.cornerRadius = view.bounds.height * Constants.coef20
        
        coordinate.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
        coordinate.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
        coordinate.leftViewMode = .always
        coordinate.rightViewMode = .always
        coordinate.layer.borderWidth = CGFloat(Constants.one)
        coordinate.layer.borderColor = UIColor.black.cgColor
        
        coordinate.translatesAutoresizingMaskIntoConstraints = false
        coordinate.pinWidth(to: view, Constants.coef17)
        coordinate.pinHeight(to: view, Constants.avatarCoef3)
        coordinate.pinCenterX(to: view)
        coordinate.pinTop(to: coordLabel.bottomAnchor, view.bounds.height * Constants.coef20)
    }
    
    private func configureDescLabel() {
        view.addSubview(descLabel)
        
        descLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.height * Constants.coef11)
        descLabel.text = Constants.locationDesc
        descLabel.textColor = Constants.color
        
        descLabel.pinCenterX(to: view)
        descLabel.pinTop(to: coordinate.bottomAnchor, view.bounds.height * Constants.coef11)
    }
    
    private func configurePlaceDesc() {
        view.addSubview(placeDesc)
                
        placeDesc.font = .systemFont(ofSize: view.bounds.width * Constants.coef16, weight: .regular)
        placeDesc.textColor = .black
        placeDesc.layer.cornerRadius = Constants.value
        placeDesc.backgroundColor = Constants.color
        placeDesc.pinTop(to: descLabel.bottomAnchor, view.bounds.height * Constants.coef20)
        placeDesc.pinBottom(to: addButton.topAnchor, view.bounds.height * Constants.coef16)
        placeDesc.pinCenterX(to: view)
        placeDesc.pinWidth(to: view, Constants.coef17)
    }
    
    private func configureAddButton() {
        view.addSubview(addButton)
        
        addButton.setTitle(Constants.add, for: .normal)
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.height * Constants.coef29)
        addButton.setTitleColor(.black, for: .normal)
        addButton.setTitleColor(.lightGray, for: .disabled)
        addButton.layer.borderColor = UIColor.black.cgColor
        addButton.layer.borderWidth = Constants.coef5
        addButton.backgroundColor = Constants.color
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.pinWidth(to: view)
        addButton.pinHeight(to: view, Constants.avatarCoef3)
        addButton.pinBottom(to: view)
        
        addButton.addTarget(self, action: #selector(addButtonWasPressed), for: .touchUpInside)
    }
    
    @objc
    private func addButtonWasPressed() {
        if placeDesc.text != Constants.nilString && coordinate.text != Constants.nilString {
            
            guard let coordinates = coordinate.text?.split(separator: Constants.space) else {
                coordinate.backgroundColor = Constants.red
                return
            }
            
            if coordinates.count == Int(Constants.coef5) {
                guard (Double(coordinates[.zero]) != nil) && (Double(coordinates[Constants.one]) != nil) else {
                    coordinate.backgroundColor = Constants.red
                    return
                }
            } else {
                coordinate.backgroundColor = Constants.red
                return
            }
            
            didAdd?((placeDesc.text, coordinate.text!))
            self.dismiss(animated: true)
        }
    }
}
