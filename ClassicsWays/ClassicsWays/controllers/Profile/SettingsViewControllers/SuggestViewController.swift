//
//  SuggestViewController.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 13.03.2024.
//

import UIKit

class SuggestViewController: UIViewController {
    private var infoView = UIScrollView()
    private lazy var contentView = UIView()
    private var contentSize: CGSize?
    private var coef = 0.0
    private var rest: Int = 0
    
    private var makeButton = UIButton()
    
    private var raiting: [String] = []
    private var id = ""
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
    private var avatarPath: String = ""
    private var avatarResource: String = ""
    private let selectButton = UIButton()
    
    private var themeView = UIView()
    private var themeLabel = UILabel()
    private var theme = -1
    private var themeOne = UIButton()
    private var themeTwo = UIButton()
    private var themeThree = UIButton()
    private var themeStack = UIStackView()
    
    private lazy var error = UILabel()
    private lazy var errorView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rest = (pictures.count - 4) / 2 + (pictures.count - 4) % 2
        coef = 1.0 + Double(rest) * 0.25
        configureUI()
    }
    
    private func configureUI() {
        configureBackGroundImage()
        configureStartButton()
        configureBackButton()
        configureInfoView()
        hideKeyboardOnTapAround()
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
        let avatarCopy = "/" + String(avatar.split(separator: "\(name)/")[0])
        self.avatarPath = avatarCopy
        self.avatarResource = avatarCopy
        for image in pictures {
            let newPicture = UIImageView()
            returnImage(imageView: newPicture, key: image)
            self.pictures.append(newPicture)
            let imageCopy = "/" + String(image.split(separator: "\(name)/")[0])
            self.picturesPath.append(imageCopy)
            self.picturesResource.append(imageCopy)
            i += 1
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
        infoView.layer.cornerRadius = Constants.radius
        infoView.layer.borderWidth = 2
        infoView.layer.borderColor = UIColor.black.cgColor
        
        contentSize = CGSize(width: view.bounds.width * 0.95, height: view.bounds.height * 2)
        if pictures.count > 4 {
            contentSize = CGSize(width: view.bounds.width * 0.95, height: view.bounds.height * 2)
        }
        infoView.contentSize = contentSize!
        
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        infoView.pinWidth(to: view, 0.95)
        infoView.pinBottom(to: makeButton.topAnchor, view.bounds.height * 0.01)
        infoView.pinCenterX(to: view)
        
        configureContentView()
    }
    
    private func configureContentView() {
        infoView.addSubview(contentView)
        contentView.frame.size = CGSize(width: view.bounds.width * 0.95, height: view.bounds.height * 2)
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
        
        avatarLabel.text = "Выберите аватар маршрута"
        avatarLabel.font = UIFont.systemFont(ofSize: view.bounds.height * 0.028)
        
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarLabel.pinCenterX(to: contentView)
        avatarLabel.pinTop(to: contentView, 10)
        
        configureSelectButton(button: selectButton, text: "выбрать", topView: avatarLabel)
        selectButton.addTarget(self, action: #selector(selectButtonWasPressed), for: .touchUpInside)
        configureAvatar()
    }
    
    private func configureSelectButton(button: UIButton, text: String, topView: UIView) {
        contentView.addSubview(button)
        
        button.setTitle(text, for: .normal)
        button.setTitleColor(Constants.color, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = Constants.radius
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setHeight(50)
        button.setWidth(view.bounds.width * 0.7)
        button.pinCenterX(to: contentView)
        button.pinTop(to: topView.bottomAnchor, 20)
    }
    
    @objc
    private func selectButtonWasPressed() {
        var imageUrl: Any?
        imagePicker.showImagePicker(in: self) { image, url in
            self.avatar.image = image
            imageUrl = url
            var copy = imageUrl.debugDescription.split(separator: "(file:")[1]
            copy.removeLast()
            let urlArray = copy.split(separator: ".")
            let body: String = String(urlArray[0].split(separator: "/").last!)
            let type: String = String(urlArray[1])
            self.avatarResource = "/\(body).\(type)"
            self.avatarPath = String(copy)
        }
    }
    
    private func configureAvatar() {
        contentView.addSubview(avatar)
        
        avatar.layer.cornerRadius = Constants.radius
        avatar.layer.masksToBounds = true
        
        avatar.pinCenterX(to: contentView)
        avatar.pinTop(to: selectButton.bottomAnchor, 10)
        avatar.setHeight(150)
        avatar.setWidth(180)
    }
    
    private func configurePerson() {
        person.attributedPlaceholder = NSAttributedString(string: "деятель", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    private func configureName() {
        name.attributedPlaceholder = NSAttributedString(string: "введите название", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    private func configureDescription() {
        desc.attributedPlaceholder = NSAttributedString(string: "введите описание", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    private func configureTime() {
        time.attributedPlaceholder = NSAttributedString(string: "введите время в минутах", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    private func configurePlace() {
        place.attributedPlaceholder = NSAttributedString(string: "введите точку старта", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    private func configureStackField() {
        contentView.addSubview(stackField)
        
        stackField.axis = .vertical
        stackField.spacing = view.bounds.height * 0.02
        
        for field in [person, name, desc, time, place] {
            field.returnKeyType = UIReturnKeyType.done
            
            field.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef2)
            field.textColor = .black
            field.backgroundColor = .white
            field.layer.cornerRadius = view.bounds.height * 0.02
            
            field.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
            field.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
            field.leftViewMode = .always
            field.rightViewMode = .always
            field.layer.borderWidth = CGFloat(Constants.one)
            field.layer.borderColor = UIColor.black.cgColor
            
            field.translatesAutoresizingMaskIntoConstraints = false
            field.setHeight(view.bounds.height * 0.04)
            
            stackField.addArrangedSubview(field)
        }
        
        configurePerson()
        configureName()
        configureDescription()
        configureTime()
        configurePlace()
        
        stackField.translatesAutoresizingMaskIntoConstraints = false
        stackField.pinLeft(to: contentView, view.bounds.width * 0.05)
        stackField.pinRight(to: contentView, view.bounds.width * 0.05)
        stackField.pinTop(to: avatar.bottomAnchor, view.bounds.height * 0.03)
        stackField.pinCenterX(to: contentView)
    }
    
    private func configureThemeView() {
        contentView.addSubview(themeView)
        
        themeView.backgroundColor = .lightGray
        themeView.layer.borderWidth = 2
        themeView.layer.borderColor = UIColor.black.cgColor
        themeView.layer.cornerRadius = Constants.radius
        
        themeView.pinHorizontal(to: contentView, 10)
        themeView.pinTop(to: stackField.bottomAnchor, 20)
        themeView.setHeight(view.bounds.height * 0.3)
        
        configureThemeLabel()
        configureThemeStack()
    }
    
    private func configureThemeLabel() {
        themeView.addSubview(themeLabel)
        
        themeLabel.text = "Тема маршрута"
        themeLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef2)
        themeLabel.textColor = .black
        
        themeLabel.translatesAutoresizingMaskIntoConstraints = false
        themeLabel.pinCenterX(to: themeView)
        themeLabel.pinTop(to: themeView, 10)
    }
    
    private func configureThemeOne() {
        themeOne.setTitle("Писатели", for: .normal)
        if theme == 1 {
            themeOne.layer.borderColor = UIColor.green.cgColor
        }
    }
    
    private func configureThemeTwo() {
        themeTwo.setTitle("Художники", for: .normal)
        if theme == 2 {
            themeTwo.layer.borderColor = UIColor.green.cgColor
        }
    }
    
    private func configureThemeThree() {
        themeThree.setTitle("Исторические лица", for: .normal)
        if theme == 3 {
            themeThree.layer.borderColor = UIColor.green.cgColor
        }
    }
    
    private func configureThemeStack() {
        themeView.addSubview(themeStack)
        
        themeStack.axis = .vertical
        themeStack.spacing = view.bounds.height / Constants.coef2
        
        for button in [themeOne, themeTwo, themeThree] {
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef2)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = Constants.color
            button.layer.cornerRadius = Constants.radius
            
            button.layer.borderWidth = CGFloat(Constants.one)
            button.layer.borderColor = UIColor.black.cgColor
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setWidth(view.bounds.width * 0.7)
            
            button.addTarget(self, action: #selector(themeButtonWasPressed), for: .touchUpInside)
            themeStack.addArrangedSubview(button)
        }
        
        configureThemeOne()
        configureThemeTwo()
        configureThemeThree()
        
        themeStack.translatesAutoresizingMaskIntoConstraints = false
        themeStack.pinTop(to: themeLabel.bottomAnchor, view.bounds.height * 0.02)
        themeStack.pinCenterX(to: themeView)
    }
    
    @objc
    private func themeButtonWasPressed(_ sender: UIButton) {
        var theme = 0
        switch sender {
        case themeOne:
            theme = 1
        case themeTwo:
            theme = 2
        default:
            theme = 3
        }
        if self.theme == theme {
            sender.layer.borderColor = UIColor.black.cgColor
            self.theme = -1
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
        
        addButton.setTitle("Добавить локацию", for: .normal)
        addButton.setTitleColor(Constants.color, for: .normal)
        addButton.backgroundColor = .lightGray
        addButton.layer.cornerRadius = Constants.radius
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setHeight(50)
        addButton.setWidth(view.bounds.width * 0.7)
        addButton.pinCenterX(to: contentView)
        addButton.pinTop(to: themeView.bottomAnchor, 20)
        
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
        table.layer.borderWidth = 2
        table.layer.borderColor = UIColor.black.cgColor
        table.layer.cornerRadius = Constants.radius
        table.keyboardDismissMode = .onDrag
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .singleLine
        
        table.pinTop(to: addButton.bottomAnchor, 20)
        table.pinHorizontal(to: contentView, 10)
        table.setHeight(view.bounds.height * 0.3)
    }
    
    func handleDelete(indexPath: IndexPath) {
        if !locations.isEmpty {
            if indexPath.row % 2 == 0 {
                locations.remove(at: indexPath.row)
                locations.remove(at: indexPath.row)
            } else {
                locations.remove(at: indexPath.row)
                locations.remove(at: indexPath.row - 1)
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
            vc.configure(with: locations[indexPath.row], with: indexPath.row % 2)
            present(vc, animated: true, completion: nil)
            vc.didAdd = { [weak self] (item) in
                self?.locations[indexPath.row] = item
                self?.table.reloadData()
            }
        }
    }
    
    
    private func configurePhoto() {
        contentView.addSubview(photo)
        
        photo.font = UIFont.boldSystemFont(ofSize: view.bounds.height * 0.03)
        photo.text = "Места из маршрута"
        photo.textColor = .black
        
        photo.pinCenterX(to: contentView)
        photo.pinTop(to: table.bottomAnchor, 10)
        
        configureSelectButton(button: selectPhotoButton, text: "добавить фото", topView: photo)
        selectPhotoButton.addTarget(self, action: #selector(selectPhotoButtonWasPressed), for: .touchUpInside)
    }
    
    private var i = 0
    @objc
    private func selectPhotoButtonWasPressed() {
        var imageUrl: Any?
        imagePicker.showImagePicker(in: self) { image, url in
            self.pictures.append(UIImageView(image: image))
            imageUrl = url
            var copy = imageUrl.debugDescription.split(separator: "(file:")[1]
            copy.removeLast()
            let urlArray = copy.split(separator: ".")
            let body: String = String(urlArray[0].split(separator: "/").last!)
            let type: String = String(urlArray[1])
            self.picturesResource.append("/\(body).\(type)")
            self.picturesPath.append(String(copy))
            if (self.i == 0) {
                self.i += 1
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
        picturesCollection.layer.cornerRadius = Constants.radius
        
        if let layout = picturesCollection.collectionViewLayout as?
            UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = .zero
            layout.minimumLineSpacing = .zero
            layout.invalidateLayout()
        }
        
        picturesCollection.translatesAutoresizingMaskIntoConstraints = false
        picturesCollection.pinHeight(to: view, 0.5)
        picturesCollection.pinHorizontal(to: contentView, view.bounds.width * 0.05)
        picturesCollection.pinTop(to: selectPhotoButton.bottomAnchor, 10)
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
            makeButton.setTitle("CОЗДАТЬ", for: .normal)
        } else {
            makeButton.setTitle("ИЗМЕНИТЬ", for: .normal)
        }
        makeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.height * 0.05)
        makeButton.setTitleColor(.black, for: .normal)
        makeButton.setTitleColor(.lightGray, for: .disabled)
        makeButton.layer.borderColor = UIColor.black.cgColor
        makeButton.layer.borderWidth = 2
        makeButton.backgroundColor = Constants.color
        
        makeButton.translatesAutoresizingMaskIntoConstraints = false
        makeButton.pinWidth(to: view)
        makeButton.pinHeight(to: view, 0.07)
        makeButton.pinBottom(to: view)
        
        makeButton.addTarget(self, action: #selector(startButtonWasPressed), for: .touchUpInside)
    }
    
    @objc
    private func startButtonWasPressed() {
        if (person.text != "" && name.text != "" && desc.text != "" && time.text != "" && place.text != "" && avatarPath != "" && theme != -1 && locations.count != 0) {
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
                                    self.error.text = "error - Пользователь с таким именем уже существует"
                                    self.configureErrorView(errorView: self.errorView, error: self.error)
                                    self.errorView.isHidden = false
                                    self.name.attributedPlaceholder = NSAttributedString(string: "название занято", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                                    self.name.backgroundColor = .red
                                    self.makeButton.isEnabled = true
                                    return
                                }
                            }
                            self.avatarResource = "\(self.name.text!)\(self.avatarResource)"
                            for index in 0...self.picturesResource.count - 1 {
                                self.picturesResource[index] = "\(self.name.text!)\(self.picturesResource[index])"
                            }
                            Task {
                                do {
                                    _ = try await NetworkService.shared.createRoute(avatar: self.avatarResource, person: self.person.text!, name: self.name.text!, description: self.desc.text!, theme: self.theme, time: timeInt, start: self.place.text!, pictures: self.picturesResource, raiting: self.raiting, locations: self.locations)
                                    DispatchQueue.main.async {
                                        self.uploadFile(with: self.avatarResource, path: self.avatarPath)
                                        for index in 0...self.picturesPath.count - 1 {
                                            self.uploadFile(with: self.picturesResource[index], path: self.picturesPath[index])
                                        }
                                        self.navigationController?.pushViewController(RoutesViewController(), animated: true)
                                    }
                                } catch {
                                    print("Произошла ошибка: \(error)")
                                    self.navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                                }
                            }
                        }
                    } else {
                        self.avatarResource = "\(self.name.text!)\(self.avatarResource)"
                        for index in 0...self.picturesResource.count - 1 {
                            self.picturesResource[index] = "\(self.name.text!)\(self.picturesResource[index])"
                        }
                        _ = try await NetworkService.shared.updateRoute(id: id, avatar: self.avatarResource, person: self.person.text!, name: self.name.text!, description: self.desc.text!, theme: self.theme, time: timeInt, start: self.place.text!, pictures: self.picturesResource, raiting: self.raiting, locations: self.locations)
                        DispatchQueue.main.async {
                            self.uploadFile(with: self.avatarResource, path: self.avatarPath)
                            for index in 0...self.picturesPath.count - 1 {
                                self.uploadFile(with: self.picturesResource[index], path: self.picturesPath[index])
                            }
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
}
