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
        hideKeyboardOnTapAround()
        configureCoordLabel()
        configureCoordinate()
        configureAddButton()
        configureDescLabel()
        configurePlaceDesc()
    }
    
    private func configureCoordLabel() {
        view.addSubview(coordLabel)
        
        coordLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.height * 0.03)
        coordLabel.text = "Введите координаты"
        coordLabel.textColor = Constants.color
        
        coordLabel.pinCenterX(to: view)
        coordLabel.pinTop(to: view, view.bounds.height * 0.03)
    }
    
    private func configureCoordinate() {
        view.addSubview(coordinate)
        
        coordinate.text = ""
        coordinate.attributedPlaceholder = NSAttributedString(string: "десятичные дроби через пробел", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        coordinate.returnKeyType = UIReturnKeyType.done
        
        coordinate.font = UIFont.boldSystemFont(ofSize: view.bounds.height * 0.025)
        coordinate.textColor = .black
        coordinate.backgroundColor = .white
        coordinate.layer.cornerRadius = view.bounds.height * 0.02
        
        coordinate.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
        coordinate.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
        coordinate.leftViewMode = .always
        coordinate.rightViewMode = .always
        coordinate.layer.borderWidth = CGFloat(Constants.one)
        coordinate.layer.borderColor = UIColor.black.cgColor
        
        coordinate.translatesAutoresizingMaskIntoConstraints = false
        coordinate.pinWidth(to: view, 0.9)
        coordinate.pinHeight(to: view, 0.07)
        coordinate.pinCenterX(to: view)
        coordinate.pinTop(to: coordLabel.bottomAnchor, view.bounds.height * 0.02)
    }
    
    private func configureDescLabel() {
        view.addSubview(descLabel)
        
        descLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.height * 0.03)
        descLabel.text = "Опишите локацию"
        descLabel.textColor = Constants.color
        
        descLabel.pinCenterX(to: view)
        descLabel.pinTop(to: coordinate.bottomAnchor, view.bounds.height * 0.03)
    }
    
    private func configurePlaceDesc() {
        view.addSubview(placeDesc)
                
        placeDesc.font = .systemFont(ofSize: view.bounds.width * 0.05, weight: .regular)
        placeDesc.textColor = .black
        placeDesc.layer.cornerRadius = Constants.radius
        placeDesc.backgroundColor = Constants.color
        placeDesc.pinTop(to: descLabel.bottomAnchor, view.bounds.height * 0.02)
        placeDesc.pinBottom(to: addButton.topAnchor, view.bounds.height * 0.05)
        placeDesc.pinCenterX(to: view)
        placeDesc.pinWidth(to: view, 0.9)
    }
    
    private func configureAddButton() {
        view.addSubview(addButton)
        
        addButton.setTitle("ДОБАВИТЬ", for: .normal)
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.height * 0.04)
        addButton.setTitleColor(.black, for: .normal)
        addButton.setTitleColor(.lightGray, for: .disabled)
        addButton.layer.borderColor = UIColor.black.cgColor
        addButton.layer.borderWidth = 2
        addButton.backgroundColor = Constants.color
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.pinWidth(to: view)
        addButton.pinHeight(to: view, 0.07)
        addButton.pinBottom(to: view)
        
        addButton.addTarget(self, action: #selector(addButtonWasPressed), for: .touchUpInside)
    }
    
    @objc
    private func addButtonWasPressed() {
        if placeDesc.text != "" && coordinate.text != "" {
            
            guard let coordinates = coordinate.text?.split(separator: " ") else {
                coordinate.backgroundColor = Constants.red
                return
            }
            
            if coordinates.count == 2 {
                guard (Double(coordinates[0]) != nil) && (Double(coordinates[1]) != nil) else {
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
