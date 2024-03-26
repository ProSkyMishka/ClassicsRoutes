//
//  EditingCellViewController.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 22.03.2024.
//

import UIKit

class EditingCellViewController: UIViewController {
    private var variant: IndexPath = []
    private let text = UITextField()
    private let ok = UIButton()
    private let back = UIButton()
    private var status = 0
    
    var didAdd: ((_ item: String) -> Void)?
    
    override func viewDidLoad() {
        configureUI()
    }
    
    func configure(with row: String, with status: Int) {
        text.text = row
        self.status = status
    }
    
    private func configureUI() {
        view.backgroundColor = Constants.color
        configureButtons()
        configureText()
    }
    
    private func configureText() {
        view.addSubview(text)
        
        text.pinTop(to: ok.bottomAnchor, 10)
        text.pinHorizontal(to: view, 10)
    }
    
    private func configureButtons() {
        view.addSubview(ok)
        view.addSubview(back)
        
        let largeFont = UIFont.systemFont(ofSize: view.bounds.height * 0.03, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let imageTick = UIImage(systemName: "checkmark", withConfiguration: configuration)
        let imageCross = UIImage(systemName: "xmark", withConfiguration: configuration)
        
        ok.setBackgroundImage(imageTick, for: .normal)
        back.setBackgroundImage(imageCross, for: .normal)
        
        ok.tintColor = .green
        back.tintColor = .red
        
        ok.pinTop(to: view, 5)
        ok.pinRight(to: view, 5)
        back.pinTop(to: view, 5)
        back.pinLeft(to: view, 5)
        
        ok.addTarget(self, action: #selector(buttonOkWasPressed), for: .touchUpInside)
        back.addTarget(self, action: #selector(buttonBackWasPressed), for: .touchUpInside)
    }
    
    @objc
    func buttonOkWasPressed() {
        if text.text != "" {
            if status == 1 {
                guard let coordinates = text.text?.split(separator: " ") else {
                    text.backgroundColor = Constants.red
                    return
                }
                
                if coordinates.count == 2 {
                    guard (Double(coordinates[0]) != nil) && (Double(coordinates[1]) != nil) else {
                        text.backgroundColor = Constants.red
                        return
                    }
                } else {
                    text.backgroundColor = Constants.red
                    return
                }
            }
            
            didAdd?(text.text!)
            dismiss(animated: true)
        } else {
            text.backgroundColor = Constants.red
        }
    }
    
    @objc
    func buttonBackWasPressed() {
        dismiss(animated: true)
    }
}
