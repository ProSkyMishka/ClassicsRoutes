//
//  SuggestViewController.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 13.03.2024.
//

import UIKit

class SuggestViewController: UIViewController {
    var infoView = UIScrollView()
    lazy var contentView = UIView()
    
    private var makeButton = UIButton()
    
    private var raiting: [String] = []
    private var id = Constants.nilString
    private var name = UITextField()
    private var person = UITextField()
    private var desc = UITextField()
    private var time = UITextField()
    private var place = UITextField()
    private var stackField = UIStackView()
    
    var locations: [String] = []
    private var addButton = UIButton()
    private var table = UITableView(frame: .zero)
    
    private let imagePicker = ImagePicker()
    
    private var photo = UILabel()
    var pictures: [UIImageView] = []
    private var picturesPath: [String] = []
    private var picturesResource: [String] = []
    private let selectPhotoButton = UIButton()
    private var picturesCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private let avatarLabel = UILabel()
    private var avatar = UIImageView()
    private var avatarPath: String = Constants.nilString
    private var avatarResource: String = Constants.nilString
    private let selectButton = UIButton()
    
    private var themeView = UIView()
    private var themeLabel = UILabel()
    private var theme = Int(Constants.coef24)
    private var themeOne = UIButton()
    private var themeTwo = UIButton()
    private var themeThree = UIButton()
    private var themeStack = UIStackView()
    
    private lazy var error = UILabel()
    private lazy var errorView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    private func configureUI() {
        configureBackGroundImage()
        configureStartButton()
        configureBackButton()
        configureInfoView()
        hideKeyboardOnTapAround(view)
    }
    
    func configure(id: String, name : String, person : String, desc : String, time : String, place : String, locations: [String], avatar: String, pictures: [String], theme: Int, raiting: [String]) {
        self.name.text = name
        self.name.isEnabled = false
        self.person.text = person
        self.desc.text = desc
        self.time.text = time
        self.place.text = place
        self.locations = locations
        self.raiting = raiting
        returnImage(imageView: self.avatar, key: avatar)
        let avatarCopy = Constants.splash + String(avatar.split(separator: (name + Constants.splash))[.zero])
        self.avatarPath = avatarCopy
        self.avatarResource = avatarCopy
        for image in pictures {
            let newPicture = UIImageView()
            returnImage(imageView: newPicture, key: image)
            self.pictures.append(newPicture)
            let imageCopy = Constants.splash + String(image.split(separator: (name + Constants.splash))[.zero])
            self.picturesPath.append(imageCopy)
            self.picturesResource.append(imageCopy)
            i += Constants.one
        }
        self.theme = theme
        self.id = id
        configureUI()
        configurePicturesCollection()
    }
    
    private func configureInfoView() {
        view.addSubview(infoView)
        
        infoView.isScrollEnabled = true
        infoView.backgroundColor = Constants.color
        infoView.layer.cornerRadius = Constants.value
        infoView.layer.borderWidth = Constants.coef5
        infoView.layer.borderColor = UIColor.black.cgColor
        
        infoView.contentSize = CGSize(width: view.bounds.width * Constants.coef9, height: view.bounds.height * Constants.coef5)
        
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        infoView.pinWidth(to: view, Constants.coef9)
        infoView.pinBottom(to: makeButton.topAnchor, view.bounds.height * Constants.coef34)
        infoView.pinCenterX(to: view)
        
        configureContentView()
    }
    
    private func configureContentView() {
        infoView.addSubview(contentView)
        contentView.frame.size = CGSize(width: view.bounds.width * Constants.coef9, height: view.bounds.height * Constants.coef5)
        contentView.backgroundColor = Constants.color
        
        configureAvatarLabel()
        configureStackField()
        configureThemeView()
        configureAddButton()
        configureTableLocations()
        configurePhoto()
    }
    
    private func configureAvatarLabel() {
        contentView.addSubview(avatarLabel)
        
        avatarLabel.text = Constants.chooseImage
        avatarLabel.font = UIFont.systemFont(ofSize: view.bounds.height * Constants.coef11)
        
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarLabel.pinCenterX(to: contentView)
        avatarLabel.pinTop(to: contentView, Constants.coef14)
        
        configureSelectButton(button: selectButton, text: Constants.chooseOne, topView: avatarLabel)
        selectButton.addTarget(self, action: #selector(selectButtonWasPressed), for: .touchUpInside)
        configureAvatar()
    }
    
    private func configureSelectButton(button: UIButton, text: String, topView: UIView) {
        contentView.addSubview(button)
        
        button.setTitle(text, for: .normal)
        button.setTitleColor(Constants.color, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = Constants.value
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setHeight(Constants.height)
        button.setWidth(view.bounds.width * Constants.coef15)
        button.pinCenterX(to: contentView)
        button.pinTop(to: topView.bottomAnchor, Constants.value)
    }
    
    @objc
    private func selectButtonWasPressed() {
        var imageUrl: Any?
        imagePicker.showImagePicker(in: self) { image, url in
            self.avatar.image = image
            imageUrl = url
            var copy = imageUrl.debugDescription.split(separator: Constants.file)[Constants.one]
            copy.removeLast()
            let urlArray = copy.split(separator: Constants.dote)
            let body: String = String(urlArray[.zero].split(separator: Constants.splash).last!)
            let type: String = String(urlArray[Constants.one])
            self.avatarResource = Constants.splash + body + Constants.dote + type
            self.avatarPath = String(copy)
        }
    }
    
    private func configureAvatar() {
        contentView.addSubview(avatar)
        
        avatar.layer.cornerRadius = Constants.value
        avatar.layer.masksToBounds = true
        
        avatar.pinCenterX(to: contentView)
        avatar.pinTop(to: selectButton.bottomAnchor, Constants.coef14)
        avatar.setHeight(Constants.height1)
        avatar.setWidth(Constants.width)
    }
    
    private func configurePerson() {
        person.attributedPlaceholder = NSAttributedString(string: Constants.personString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    private func configureName() {
        name.attributedPlaceholder = NSAttributedString(string: Constants.newNameRoute, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    private func configureDescription() {
        desc.attributedPlaceholder = NSAttributedString(string: Constants.newDescRoute, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    private func configureTime() {
        time.attributedPlaceholder = NSAttributedString(string: Constants.newTimeRoute, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    private func configurePlace() {
        place.attributedPlaceholder = NSAttributedString(string: Constants.newStartRoute, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    private func configureStackField() {
        contentView.addSubview(stackField)
        
        stackField.axis = .vertical
        stackField.spacing = view.bounds.height * Constants.coef20
        
        for field in [person, name, desc, time, place] {
            field.returnKeyType = UIReturnKeyType.done
            
            field.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef2)
            field.textColor = .black
            field.backgroundColor = .white
            field.layer.cornerRadius = view.bounds.height * Constants.coef20
            
            field.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
            field.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
            field.leftViewMode = .always
            field.rightViewMode = .always
            field.layer.borderWidth = CGFloat(Constants.one)
            field.layer.borderColor = UIColor.black.cgColor
            
            field.translatesAutoresizingMaskIntoConstraints = false
            field.setHeight(view.bounds.height * Constants.coef29)
            
            stackField.addArrangedSubview(field)
        }
        
        configurePerson()
        configureName()
        configureDescription()
        configureTime()
        configurePlace()
        
        stackField.translatesAutoresizingMaskIntoConstraints = false
        stackField.pinLeft(to: contentView, view.bounds.width * Constants.coef16)
        stackField.pinRight(to: contentView, view.bounds.width * Constants.coef16)
        stackField.pinTop(to: avatar.bottomAnchor, view.bounds.height * Constants.coef11)
        stackField.pinCenterX(to: contentView)
    }
    
    private func configureThemeView() {
        contentView.addSubview(themeView)
        
        themeView.backgroundColor = .lightGray
        themeView.layer.borderWidth = Constants.coef5
        themeView.layer.borderColor = UIColor.black.cgColor
        themeView.layer.cornerRadius = Constants.value
        
        themeView.pinHorizontal(to: contentView, Constants.coef14)
        themeView.pinTop(to: stackField.bottomAnchor, Constants.value)
        themeView.setHeight(view.bounds.height * Constants.coef10)
        
        configureThemeLabel(themeView: themeView, themeLabel: themeLabel)
        configureThemeStack(themeView: themeView, themeLabel: themeLabel, themeStack: themeStack, themeOne: themeOne, themeTwo: themeTwo, themeThree: themeThree)
        themeLabel.text = Constants.themeRoute
        configureThemeBorder()
    }
    
    private func configureThemeBorder() {
        if theme == Constants.one {
            themeOne.layer.borderColor = UIColor.green.cgColor
        } else if theme == Int(Constants.coef5) {
            themeTwo.layer.borderColor = UIColor.green.cgColor
        } else if theme == Int(Constants.coef18) {
            themeThree.layer.borderColor = UIColor.green.cgColor
        }
    }
    
    @objc
    override func themeButtonWasPressed(_ sender: UIButton) {
        var theme: Int = .zero
        switch sender {
        case themeOne:
            theme = Constants.one
        case themeTwo:
            theme = Int(Constants.coef5)
        default:
            theme = Int(Constants.coef18)
        }
        if self.theme == theme {
            sender.layer.borderColor = UIColor.black.cgColor
            self.theme = Int(Constants.coef24)
            makeButton.isEnabled = false
        } else {
            for button in [themeOne, themeTwo, themeThree] {
                button.layer.borderColor = UIColor.black.cgColor
            }
            sender.layer.borderColor = UIColor.green.cgColor
            self.theme = theme
            makeButton.isEnabled = true
        }
    }
    
    private func configureAddButton() {
        contentView.addSubview(addButton)
        
        addButton.setTitle(Constants.addLocation, for: .normal)
        addButton.setTitleColor(Constants.color, for: .normal)
        addButton.backgroundColor = .lightGray
        addButton.layer.cornerRadius = Constants.value
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setHeight(Constants.height)
        addButton.setWidth(view.bounds.width * Constants.coef15)
        addButton.pinCenterX(to: contentView)
        addButton.pinTop(to: themeView.bottomAnchor, Constants.value)
        
        addButton.addTarget(self, action: #selector(addButtonWasPressed), for: .touchUpInside)
    }
    
    @objc
    private func addButtonWasPressed() {
        let vc = AddingPlaceViewController()
        present(vc, animated: true, completion: nil)
        vc.didAdd = { [weak self] (item) in
            self?.locations.append(item.0)
            self?.locations.append(item.1)
            self?.table.reloadData()
        }
    }
    
    private func configureTableLocations() {
        contentView.addSubview(table)
        
        table.register(LocationCell.self, forCellReuseIdentifier: LocationCell.reuseId)
        table.backgroundColor = Constants.color
        table.layer.borderWidth = Constants.coef5
        table.layer.borderColor = UIColor.black.cgColor
        table.layer.cornerRadius = Constants.value
        table.keyboardDismissMode = .onDrag
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .singleLine
        
        table.pinTop(to: addButton.bottomAnchor, Constants.value)
        table.pinHorizontal(to: contentView, Constants.coef14)
        table.setHeight(view.bounds.height * Constants.coef10)
    }
    
    func handleDelete(indexPath: IndexPath) {
        if !locations.isEmpty {
            if indexPath.row % Int(Constants.coef5) == .zero {
                locations.remove(at: indexPath.row)
                locations.remove(at: indexPath.row)
            } else {
                locations.remove(at: indexPath.row)
                locations.remove(at: indexPath.row - Constants.one)
            }
            table.reloadData()
        }
    }
    
    private var variant: IndexPath = []
    private let popUp = UIView()
    private let text = UITextField()
    func handleEdit(indexPath: IndexPath) {
        if !locations.isEmpty {
            let vc = EditingCellViewController()
            vc.configure(with: locations[indexPath.row], with: indexPath.row % Int(Constants.coef5))
            present(vc, animated: true, completion: nil)
            vc.didAdd = { [weak self] (item) in
                self?.locations[indexPath.row] = item
                self?.table.reloadData()
            }
        }
    }
    
    
    private func configurePhoto() {
        contentView.addSubview(photo)
        
        photo.font = UIFont.boldSystemFont(ofSize: view.bounds.height * Constants.coef11)
        photo.text = Constants.places
        photo.textColor = .black
        
        photo.pinCenterX(to: contentView)
        photo.pinTop(to: table.bottomAnchor, Constants.coef14)
        
        configureSelectButton(button: selectPhotoButton, text: Constants.addImage, topView: photo)
        selectPhotoButton.addTarget(self, action: #selector(selectPhotoButtonWasPressed), for: .touchUpInside)
    }
    
    private var i: Int = .zero
    @objc
    private func selectPhotoButtonWasPressed() {
        var imageUrl: Any?
        imagePicker.showImagePicker(in: self) { image, url in
            self.pictures.append(UIImageView(image: image))
            imageUrl = url
            var copy = imageUrl.debugDescription.split(separator: Constants.file)[Constants.one]
            copy.removeLast()
            let urlArray = copy.split(separator: Constants.dote)
            let body: String = String(urlArray[.zero].split(separator: Constants.splash).last!)
            let type: String = String(urlArray[Constants.one])
            self.picturesResource.append(Constants.splash + body + Constants.dote + type)
            self.picturesPath.append(String(copy))
            if (self.i == .zero) {
                self.i += Constants.one
                self.configurePicturesCollection()
            } else {
                self.picturesCollection.reloadData()
            }
        }
    }
    
    private func configurePicturesCollection() {
        contentView.addSubview(picturesCollection)
        
        picturesCollection.register(MakePictureCell.self, forCellWithReuseIdentifier: MakePictureCell.reuseIdentifier)
        
        picturesCollection.dataSource = self
        picturesCollection.delegate = self
        picturesCollection.alwaysBounceVertical = true
        picturesCollection.backgroundColor = Constants.color
        picturesCollection.layer.cornerRadius = Constants.value
        
        if let layout = picturesCollection.collectionViewLayout as?
            UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = .zero
            layout.minimumLineSpacing = .zero
            layout.invalidateLayout()
        }
        
        picturesCollection.translatesAutoresizingMaskIntoConstraints = false
        picturesCollection.pinHorizontal(to: contentView, view.bounds.width * Constants.coef16)
        picturesCollection.pinTop(to: selectPhotoButton.bottomAnchor, Constants.coef14)
        picturesCollection.pinBottom(to: contentView.bottomAnchor, Constants.coef14)
    }
    
    @objc
    func trashPressed(_ sender: UIButton) {
        pictures.remove(at: sender.tag)
        picturesResource.remove(at: sender.tag)
        picturesPath.remove(at: sender.tag)
        picturesCollection.reloadData()
    }
    
    private func configureStartButton() {
        view.addSubview(makeButton)
        
        if (id.isEmpty) {
            makeButton.setTitle(Constants.createString, for: .normal)
        } else {
            makeButton.setTitle(Constants.updateString, for: .normal)
        }
        makeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.height * Constants.coef29)
        makeButton.setTitleColor(.black, for: .normal)
        makeButton.setTitleColor(.lightGray, for: .disabled)
        makeButton.layer.borderColor = UIColor.black.cgColor
        makeButton.layer.borderWidth = Constants.coef5
        makeButton.backgroundColor = Constants.color
        
        makeButton.translatesAutoresizingMaskIntoConstraints = false
        makeButton.pinWidth(to: view)
        makeButton.pinHeight(to: view, Constants.avatarCoef3)
        makeButton.pinBottom(to: view)
        
        makeButton.addTarget(self, action: #selector(startButtonWasPressed), for: .touchUpInside)
    }
    
    @objc
    private func startButtonWasPressed() {
        if (person.text != Constants.nilString && name.text != Constants.nilString && desc.text != Constants.nilString && time.text != Constants.nilString && place.text != Constants.nilString && avatarPath != Constants.nilString && theme != Int(Constants.coef24) && locations.count != .zero) {
            guard let timeInt = Int(self.time.text!) else {
                time.backgroundColor = Constants.red
                return
            }
            makeButton.isEnabled = false
            var routes: [Route] = []
            Task {
                do {
                    if (id.isEmpty) {
                        routes = try await NetworkService.shared.getAllRoutes()
                        DispatchQueue.main.async {
                            for route in routes {
                                if self.name.text == route.name {
                                    self.error.text = Constants.routeNameError
                                    self.configureErrorView(errorView: self.errorView, error: self.error)
                                    self.errorView.isHidden = false
                                    self.name.attributedPlaceholder = NSAttributedString(string: Constants.routeNameTaken, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                                    self.name.backgroundColor = .red
                                    self.makeButton.isEnabled = true
                                    return
                                }
                            }
                            self.avatarResource = (self.name.text!) + (self.avatarResource)
                            if !self.picturesPath.isEmpty {
                                for index in (.zero)...self.picturesResource.count - Constants.one {
                                    self.picturesResource[index] = (self.name.text!) + (self.picturesResource[index])
                                }
                            }
                            Task {
                                do {
                                    _ = try await NetworkService.shared.createRoute(avatar: self.avatarResource, person: self.person.text!, name: self.name.text!, description: self.desc.text!, theme: self.theme, time: timeInt, start: self.place.text!, pictures: self.picturesResource, raiting: self.raiting, locations: self.locations)
                                    self.uploadPictures()
                                    try await Task.sleep(nanoseconds:  Constants.chatWait)
                                    DispatchQueue.main.async {
                                        self.navigationController?.pushViewController(RoutesViewController(), animated: true)
                                    }
                                } catch {
                                    print("Произошла ошибка: \(error)")
                                    self.navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                                }
                            }
                        }
                    } else {
                        self.avatarResource = (self.name.text!) + (self.avatarResource)
                        if !picturesResource.isEmpty {
                            for index in (.zero)...self.picturesResource.count - Constants.one {
                                self.picturesResource[index] = (self.name.text!) + (self.picturesResource[index])
                            }
                        }
                        _ = try await NetworkService.shared.updateRoute(id: id, avatar: self.avatarResource, person: self.person.text!, name: self.name.text!, description: self.desc.text!, theme: self.theme, time: timeInt, start: self.place.text!, pictures: self.picturesResource, raiting: self.raiting, locations: self.locations)
                        uploadPictures()
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(RoutesViewController(), animated: true)
                        }
                    }
                } catch {
                    navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                    print("Произошла ошибка: \(error)")
                }
            }
        }
    }
    
    private func uploadPictures() {
        self.uploadFile(with: self.avatarResource, path: self.avatarPath)
        if !self.picturesPath.isEmpty {
            for index in (.zero)...self.picturesPath.count - Constants.one {
                self.uploadFile(with: self.picturesResource[index], path: self.picturesPath[index])
            }
        }
    }
}
