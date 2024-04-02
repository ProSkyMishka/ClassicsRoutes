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
    private var status: Int = .zero
    
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
        
        text.textColor = .black
        text.pinTop(to: ok.bottomAnchor, Constants.coef14)
        text.pinHorizontal(to: view, Constants.coef14)
    }
    
    private func configureButtons() {
        view.addSubview(ok)
        view.addSubview(back)
        
        let largeFont = UIFont.systemFont(ofSize: view.bounds.height * Constants.coef11, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let imageTick = UIImage(systemName: Constants.tickSymbol, withConfiguration: configuration)
        let imageCross = UIImage(systemName: Constants.crossSymbol, withConfiguration: configuration)
        
        ok.setBackgroundImage(imageTick, for: .normal)
        back.setBackgroundImage(imageCross, for: .normal)
        
        ok.tintColor = .green
        back.tintColor = .red
        
        ok.pinTop(to: view, Constants.coef7)
        ok.pinRight(to: view, Constants.coef7)
        back.pinTop(to: view, Constants.coef7)
        back.pinLeft(to: view, Constants.coef7)
        
        ok.addTarget(self, action: #selector(buttonOkWasPressed), for: .touchUpInside)
        back.addTarget(self, action: #selector(buttonBackWasPressed), for: .touchUpInside)
    }
    
    @objc
    func buttonOkWasPressed() {
        if text.text != Constants.nilString {
            if status == Constants.one {
                guard let coordinates = text.text?.split(separator: Constants.space) else {
                    text.backgroundColor = Constants.red
                    return
                }
                
                if coordinates.count == Int(Constants.coef5) {
                    guard (Double(coordinates[.zero]) != nil) && (Double(coordinates[Constants.one]) != nil) else {
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
