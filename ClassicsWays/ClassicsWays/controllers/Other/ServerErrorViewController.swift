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
        error.font = UIFont.systemFont(ofSize: view.bounds.height * 0.03)
        error.lineBreakMode = .byWordWrapping
        error.numberOfLines = .zero
        error.text = "Возникла проблема соединения, проверьте подключение к сети и перезапустите приложение. Если не помогло, то значит проблемы со стороны сервера и мы их уже решаем, немного подождите и перезапустите приложение. Приносим свои извинения"
        
        error.pinCenter(to: errorView)
        error.setWidth(view.bounds.width * 0.85)
    }
    
    private func configureErrorView() {
        view.addSubview(errorView)
        
        errorView.backgroundColor = Constants.red
        errorView.layer.borderWidth = 2
        errorView.layer.borderColor = UIColor.black.cgColor
        errorView.layer.cornerRadius = Constants.radius
        
        errorView.pinWidth(to: view, 0.95)
        errorView.pinHeight(to: view, 0.5)
        errorView.pinCenter(to: view)
        
        configureError()
    }
}
