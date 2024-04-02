//
//  UIViewControllerExtention.swift
//  Class'Ways
//
//  Created by Михаил Прозорский on 14.02.2024.
//

import UIKit
import AVKit
import AVFoundation
import AWSCognito
import AWSS3

extension UIViewController {    
    func returnImage(imageView: UIImageView, key: String) {
        var contentUrl: URL!
        var s3Url: URL!
        
        let credentialsProvider =
        AWSCognitoCredentialsProvider(regionType:.USEast1, identityPoolId: Constants.identityPoolId)
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        s3Url = AWSS3.default().configuration.endpoint.url
        
        contentUrl = s3Url.appendingPathComponent( Constants.bucketName).appendingPathComponent("\(key)")
        URLSession.shared.dataTask(with: contentUrl) { (data, response, error) in
            if error != nil {
                print(error ?? String.self)
                DispatchQueue.main.async {
                    imageView.image = UIImage(named: Constants.pictureError)
                }
            }
            
            guard let imageData = data else {
                return
            }
            
            DispatchQueue.main.async {
                imageView.image = UIImage(data: imageData)
            }
        }.resume()
    }
    
    func uploadFile(with resource: String, path: String) {
        let credentialsProvider =
        AWSCognitoCredentialsProvider(regionType:.USEast1, identityPoolId: Constants.identityPoolId)
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        let key = "\(resource)"
        print(resource)
        let localImageUrl = URL(fileURLWithPath: path)
        let request = AWSS3TransferManagerUploadRequest()!
        request.bucket = Constants.bucketName
        request.key = key
        request.body = localImageUrl
        request.acl = .publicReadWrite
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(request).continueWith(executor: AWSExecutor.mainThread()) { (task) -> Any?
            in
            if let error = task.error {
                print(error)
            }
            if task.result != nil {
                print("Uploaded \(key)")
            }
            
            return nil
        }
    }
    
    func configureBackGroundImage() {
        let backGroundImage = UIImageView()
        
        view.addSubview(backGroundImage)
        
        backGroundImage.image = UIImage(named: Constants.fon)
        
        backGroundImage.pinCenter(to: view)
        backGroundImage.setWidth(view.bounds.width)
        backGroundImage.setHeight(view.bounds.height)
    }
    
    func hideKeyboardOnTapAround(_ thisView: UIView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        gesture.cancelsTouchesInView = false
        thisView.addGestureRecognizer(gesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureBackButton(_ color: UIColor = Constants.color) {
        navigationItem.hidesBackButton = true
        let largeFont = UIFont.systemFont(ofSize: view.bounds.height * Constants.coef8, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: Constants.backSymbol, withConfiguration: configuration)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = color
    }
    
    @objc
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureErrorView(errorView: UIView, error: UILabel) {
        view.addSubview(errorView)
        
        errorView.backgroundColor = Constants.red
        errorView.layer.borderWidth = Constants.coef5
        errorView.layer.borderColor = UIColor.black.cgColor
        errorView.layer.cornerRadius = Constants.value
        
        errorView.pinWidth(to: view, Constants.coef9)
        errorView.pinHeight(to: view, Constants.coef10)
        errorView.pinCenter(to: view)
        
        errorView.addSubview(error)
        
        error.translatesAutoresizingMaskIntoConstraints = false
        error.textColor = .black
        error.font = UIFont.systemFont(ofSize: view.bounds.height * Constants.coef11)
        error.lineBreakMode = .byWordWrapping
        error.numberOfLines = .zero
        
        error.pinCenter(to: errorView)
        error.setWidth(view.bounds.width * Constants.coef12)
    }
    
    func configureTick(tick: UIButton, errorView: UIView, configuration: UIImage.SymbolConfiguration) {
        tick.isHidden = false
        let imageTick = UIImage(systemName: Constants.tickSymbol, withConfiguration: configuration)
        tick.setBackgroundImage(imageTick, for: .normal)
        
        errorView.addSubview(tick)
        tick.tintColor = .black
        tick.pinRight(to: errorView, view.bounds.width * Constants.coef13)
        tick.pinBottom(to: errorView, Constants.coef7)
    }
    
    func configureCross(cross: UIButton, errorView: UIView, configuration: UIImage.SymbolConfiguration) {
        cross.isHidden = false
        let imageCross = UIImage(systemName: Constants.crossSymbol, withConfiguration: configuration)
        cross.setBackgroundImage(imageCross, for: .normal)
        errorView.addSubview(cross)
        cross.tintColor = .black
        cross.pinLeft(to: errorView, view.bounds.width * Constants.coef13)
        cross.pinBottom(to: errorView, Constants.coef7)
    }
    
    func configureThemeLabel(themeView: UIView, themeLabel: UILabel) {
        themeView.addSubview(themeLabel)
        
        themeLabel.text = Constants.themeAsk
        themeLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef2)
        themeLabel.textColor = .black
        
        themeLabel.translatesAutoresizingMaskIntoConstraints = false
        themeLabel.pinCenterX(to: themeView)
        themeLabel.pinTop(to: themeView, Constants.coef14)
    }
    
    func configureThemeStack(themeView: UIView, themeLabel: UILabel, themeStack: UIStackView, themeOne: UIButton, themeTwo: UIButton, themeThree: UIButton) {
        themeView.addSubview(themeStack)
        
        themeStack.axis = .vertical
        themeStack.spacing = view.bounds.height / Constants.coef2
        
        for button in [themeOne, themeTwo, themeThree] {
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef2)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = Constants.color
            button.layer.cornerRadius = view.bounds.height * Constants.coef8
            
            button.layer.borderWidth = CGFloat(Constants.one)
            button.layer.borderColor = UIColor.black.cgColor
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setWidth(view.bounds.width * Constants.coef15)
            button.setHeight(view.bounds.height * Constants.coef16)
            
            button.addTarget(self, action: #selector(themeButtonWasPressed), for: .touchUpInside)
            themeStack.addArrangedSubview(button)
        }
        
        themeOne.setTitle(Constants.themeWriter, for: .normal)
        themeTwo.setTitle(Constants.themeArtist, for: .normal)
        themeThree.setTitle(Constants.themeHistorical, for: .normal)
        
        themeStack.translatesAutoresizingMaskIntoConstraints = false
        themeStack.pinTop(to: themeLabel.bottomAnchor, Constants.coef14)
        themeStack.pinBottom(to: themeView, Constants.coef14)
        themeStack.pinCenterX(to: themeView)
    }
    
    @objc
    func themeButtonWasPressed(_ sender: UIButton) { }
    
    func returnHeight(thisView: UIView) -> CGFloat {
        return thisView.sizeThatFits(CGSize(width: view.bounds.width * Constants.coef17, height: CGFloat.greatestFiniteMagnitude)).height
    }
}
