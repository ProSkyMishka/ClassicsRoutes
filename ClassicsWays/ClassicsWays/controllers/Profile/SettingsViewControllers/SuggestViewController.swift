//
//  SuggestController\.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 13.03.2024.
//

import UIKit

class SuggestViewController: UIViewController {
    private var startButton = UIButton()
    private var name = UITextField()
    private var person = UITextField()
    private var desc = UITextField()
    private var time = UITextField()
    private var place = UITextField()
    private var raiting = UITextField()
    private var photo = UILabel()
    private var locations: [String] = []
    private var coordinatesCount = UILabel()
    private var addButton = UIButton()
    private var descView = UITextView()
    private var infoView = UIScrollView()
    private lazy var contentView = UIView()
    private var stackField = UIStackView()
    private var picturesCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    private var table = UITableView(frame: .zero)
    private var avatar = UIImageView()
    private var contentSize: CGSize?
    private var coef = 0.0
    private var pictures: [String] = []
    private var rest: Int = 0
    private let imagePicker = ImagePicker()
    private let selectButton = UIButton()
    private let avatarLabel = UILabel()
    private let picturesPathes: [String] = []
    private var avatarPath: String = ""
    private var avatarResource: String = ""
    private var themeView = UIView()
    private var themeLabel = UILabel()
    private var theme = -1
    private var themeOne = UIButton()
    private var themeTwo = UIButton()
    private var themeThree = UIButton()
    private var themeStack = UIStackView()
    
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
        infoView.pinBottom(to: startButton.topAnchor, view.bounds.height * 0.01)
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
        configurePicturesCollection()
        configureTableLocations()
    }
    
    private func configureAvatarLabel() {
        contentView.addSubview(avatarLabel)
        
        avatarLabel.text = "Выберите аватар маршрута"
        avatarLabel.font = UIFont.systemFont(ofSize: view.bounds.height * 0.028)
        
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarLabel.pinCenterX(to: contentView)
        avatarLabel.pinTop(to: contentView, 10)
        
        configureSelectButton()
        configureAvatar()
    }
    
    private func configureSelectButton() {
        contentView.addSubview(selectButton)
        
        selectButton.setTitle("выбрать", for: .normal)
        selectButton.setTitleColor(Constants.color, for: .normal)
        selectButton.backgroundColor = .lightGray
        selectButton.layer.cornerRadius = Constants.radius
        
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.setHeight(50)
        selectButton.setWidth(view.bounds.width * 0.7)
        selectButton.pinCenterX(to: contentView)
        selectButton.pinTop(to: avatarLabel.bottomAnchor, 20)
        
        selectButton.addTarget(self, action: #selector(selectButtonWasPressed), for: .touchUpInside)
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
            //            self.uploadFile(with: resource, path: String(copy))
        }
    }
    
    private func configureAvatar() {
        contentView.addSubview(avatar)
        
        avatar.pinCenterX(to: contentView)
        avatar.pinTop(to: selectButton.bottomAnchor, 10)
        avatar.setHeight(150)
        avatar.setWidth(180)
    }
    
    private func configurePerson() {
        person.attributedPlaceholder = NSAttributedString(string: "человек, к которому относится", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
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
    
//    private func configurePhoto() {
//        photo.text = "Добавьте места из маршрута"
//        
//        view.addSubview(coordLabel)
//        
//        coordLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.height * 0.03)
//        coordLabel.text = "Введите координаты"
//        coordLabel.textColor = Constants.color
//        
//        coordLabel.pinCenterX(to: view)
//        coordLabel.pinTop(to: view, view.bounds.height * 0.03)
//    }
    
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
    
    private func configurePicturesCollection() {
        contentView.addSubview(picturesCollection)
        
        picturesCollection.register(PictureCell.self, forCellWithReuseIdentifier: PictureCell.reuseIdentifier)
        
        picturesCollection.dataSource = self
        picturesCollection.delegate = self
        picturesCollection.alwaysBounceVertical = true
        picturesCollection.isScrollEnabled = false
        picturesCollection.backgroundColor = Constants.color
        picturesCollection.layer.cornerRadius = Constants.radius
        
        if let layout = picturesCollection.collectionViewLayout as?
            UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = .zero
            layout.minimumLineSpacing = .zero
            layout.invalidateLayout()
        }
        
        picturesCollection.translatesAutoresizingMaskIntoConstraints = false
        let heightRest = pictures.count / 2 + pictures.count % 2
        let heightCoef = Double(heightRest) * 0.25
        picturesCollection.pinHeight(to: view, 0.85 * heightCoef)
        picturesCollection.pinHorizontal(to: contentView, view.bounds.width * 0.05)
        picturesCollection.pinTop(to: stackField.bottomAnchor, view.bounds.height * 0.02)
    }
    
    private func configureStartButton() {
        view.addSubview(startButton)
        
        startButton.setTitle("CОЗДАТЬ", for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.height * 0.05)
        startButton.setTitleColor(.black, for: .normal)
        startButton.setTitleColor(.lightGray, for: .disabled)
        startButton.layer.borderColor = UIColor.black.cgColor
        startButton.layer.borderWidth = 2
        startButton.backgroundColor = Constants.color
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.pinWidth(to: view)
        startButton.pinHeight(to: view, 0.07)
        startButton.pinBottom(to: view)
        
        startButton.addTarget(self, action: #selector(startButtonWasPressed), for: .touchUpInside)
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
    }
    
    private func configureThemeTwo() {
        themeTwo.setTitle("Художники", for: .normal)
    }
    
    private func configureThemeThree() {
        themeThree.setTitle("Исторические лица", for: .normal)
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
            startButton.isEnabled = false
        } else {
            for button in [themeOne, themeTwo, themeThree] {
                button.layer.borderColor = UIColor.black.cgColor
            }
            sender.layer.borderColor = UIColor.green.cgColor
            self.theme = theme
            startButton.isEnabled = true
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
        table.headerView(forSection: 0)?.tintColor = .gray
        
        table.pinTop(to: addButton.bottomAnchor, 20)
        table.pinHorizontal(to: contentView, 10)
        table.setHeight(view.bounds.height * 0.3)
    }
    
    private func handleDelete(indexPath: IndexPath) {
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
    
    var variant: IndexPath = []
    let popUp = UIView()
    let text = UITextField()
    private func handleEdit(indexPath: IndexPath) {
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
    
    @objc
    private func startButtonWasPressed() {
        if (name.text != "" && desc.text != "" && time.text != "" && place.text != "" && avatarPath != "" && theme != -1) {
            guard let timeInt = Int(self.time.text!) else {
                return
            }
            print("yes")
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SuggestViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCell.reuseIdentifier, for: indexPath)
        guard let pictureCell = cell as? PictureCell else {
            return cell
        }
        pictureCell.configure(with: pictures[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SuggestViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width * 0.35
        return CGSize(width: width, height: width * 0.89)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return view.bounds.width * 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return view.bounds.width * 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: view.bounds.height * 0.02, left: 0, bottom: view.bounds.height * 0.02, right: 0)
    }
}

extension SuggestViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
                   indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: .none
        ) { [weak self] (action, view, completion) in
            self?.handleDelete(indexPath: indexPath)
            completion(true)
        }
        
        deleteAction.image = UIImage(
            systemName: "trash.fill",
            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
        )?.withTintColor(.white)
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt
                   indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(
            style: .destructive,
            title: .none
        ) { [weak self] (action, view, completion) in
            self?.handleEdit(indexPath: indexPath)
            completion(true)
        }
        editAction.image = UIImage(
            systemName: "square.and.pencil",
            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
        )?.withTintColor(.white)
        editAction.backgroundColor = UIColor(red: 0.6, green: 1, blue: 0.6, alpha: 1)
        return UISwipeActionsConfiguration(actions: [editAction])
    }
}

extension SuggestViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                   section: Int) -> String? {
        return "Here is a list of the locations"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Int(Constants.one)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = locations[indexPath.row]
        if let noteCell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseId, for: indexPath) as? LocationCell {
            noteCell.configure(with: note)
            return noteCell
        }
        return UITableViewCell()
    }
}
