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
    private var addButton = UIButton()
    var didAdd: ((_ item: (String, String)) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        configureBackGroundImage()
        hideKeyboardOnTapAround()
        configureCoordinate()
        configureAddButton()
        configurePlaceDesc()
    }
    
    private func configureCoordinate() {
        view.addSubview(coordinate)
        
        coordinate.text = ""
        coordinate.attributedPlaceholder = NSAttributedString(string: "введите координаты", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        coordinate.returnKeyType = UIReturnKeyType.done
        
        coordinate.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef2)
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
        coordinate.pinHeight(to: view, 0.1)
        coordinate.pinVertical(to: view, 15)
        coordinate.pinTop(to: view, 15)
    }
    
    private func configurePlaceDesc() {
        view.addSubview(placeDesc)
                
        placeDesc.text = ""
        placeDesc.font = .systemFont(ofSize: view.bounds.width * 0.05, weight: .regular)
        placeDesc.textColor = .black
        placeDesc.backgroundColor = .clear
        placeDesc.pinBottom(to: addButton.topAnchor, view.bounds.height * 0.1)
        placeDesc.pinCenterX(to: view)
        placeDesc.pinTop(to: coordinate.bottomAnchor, view.bounds.height * 0.1)
    }
    
    private func configureAddButton() {
        view.addSubview(addButton)
        
        addButton.setTitle("CОЗДАТЬ", for: .normal)
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.height * 0.05)
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
                return
            }
            if coordinates.count == 2 {
                guard (Double(coordinates[0]) != nil) && (Double(coordinates[1]) != nil) else {
                    return
                }
            } else {
                return
            }
            
            didAdd?((placeDesc.text, coordinate.text!))
            self.dismiss(animated: true)
        }
    }
}
