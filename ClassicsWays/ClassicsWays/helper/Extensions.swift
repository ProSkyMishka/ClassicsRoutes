//
//  Extentions.swift
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
        let bucketName = "classicsroutesbucket"
        var contentUrl: URL!
        var s3Url: URL!
        
        let credentialsProvider =
        AWSCognitoCredentialsProvider(regionType:.USEast1, identityPoolId: "us-east-1:b670d5bd-1bb8-426f-88b8-432b9e78cb63")
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        s3Url = AWSS3.default().configuration.endpoint.url
        
        contentUrl = s3Url.appendingPathComponent(bucketName).appendingPathComponent("\(key)")
        URLSession.shared.dataTask(with: contentUrl) { (data, response, error) in
            if error != nil {
                print(error ?? String.self)
                DispatchQueue.main.async {
                    imageView.image = UIImage(named: "pictureError.png")
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
        let bucketName = "classicsroutesbucket"
        
        let credentialsProvider =
        AWSCognitoCredentialsProvider(regionType:.USEast1, identityPoolId: "us-east-1:b670d5bd-1bb8-426f-88b8-432b9e78cb63")
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        let key = "\(resource)"
        print(resource)
        let localImageUrl = URL(fileURLWithPath: path)
        let request = AWSS3TransferManagerUploadRequest()!
        request.bucket = bucketName
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
        
        backGroundImage.image = UIImage(named: "fon.png")
        
        backGroundImage.pinCenter(to: view)
        backGroundImage.setWidth(view.bounds.width)
        backGroundImage.setHeight(view.bounds.height)
    }
    
    func hideKeyboardOnTapAround() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureBackButton() {
        navigationItem.hidesBackButton = true
        let largeFont = UIFont.systemFont(ofSize: view.bounds.height * 0.025, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = Constants.color
    }
    
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureErrorView(errorView: UIView, error: UILabel) {
        view.addSubview(errorView)
        
        errorView.backgroundColor = Constants.red
        errorView.layer.borderWidth = 2
        errorView.layer.borderColor = UIColor.black.cgColor
        errorView.layer.cornerRadius = Constants.radius
        
        errorView.pinWidth(to: view, 0.95)
        errorView.pinHeight(to: view, 0.3)
        errorView.pinCenter(to: view)
        
        errorView.addSubview(error)
        
        error.translatesAutoresizingMaskIntoConstraints = false
        error.textColor = .black
        error.font = UIFont.systemFont(ofSize: view.bounds.height * 0.03)
        error.lineBreakMode = .byWordWrapping
        error.numberOfLines = .zero
        
        error.pinCenter(to: errorView)
        error.setWidth(view.bounds.width * 0.85)
    }
}
