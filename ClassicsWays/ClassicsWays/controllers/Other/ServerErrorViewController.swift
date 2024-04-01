//
//  ServerErrorViewController.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 28.02.2024.
//

import UIKit

class ServerErrorViewController: TemplateViewController {
    private lazy var error = UILabel()
    private lazy var errorView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        configureBackGroundImage()
        configureErrorView()
        navigationItem.hidesBackButton = true
    }
    
    private func configureError() {
        errorView.addSubview(error)
        
        error.translatesAutoresizingMaskIntoConstraints = false
        error.textColor = .black
        error.font = UIFont.systemFont(ofSize: view.bounds.height * Constants.coef11)
        error.lineBreakMode = .byWordWrapping
        error.numberOfLines = .zero
        error.text = Constants.serverError
        
        error.pinCenter(to: errorView)
        error.setWidth(view.bounds.width * Constants.coef12)
    }
    
    private func configureErrorView() {
        view.addSubview(errorView)
        
        errorView.backgroundColor = Constants.red
        errorView.layer.borderWidth = Constants.coef5
        errorView.layer.borderColor = UIColor.black.cgColor
        errorView.layer.cornerRadius = Constants.value
        
        errorView.pinWidth(to: view, Constants.coef9)
        errorView.pinHeight(to: view, Constants.coef38)
        errorView.pinCenter(to: view)
        
        configureError()
    }
}
