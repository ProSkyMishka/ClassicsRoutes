//
//  RoutesViewController.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 28.02.2024.
//

import UIKit

class RouteViewController: UIViewController {
    private var startButton = UIButton()
    private var name = UILabel()
    private var desc = UILabel()
    private var time = UILabel()
    private var place = UILabel()
    private var raiting = UILabel()
    private var photo = UILabel()
    private var infoView = UIScrollView()
    private lazy var contentView = UIView()
    private var stackLabel = UIStackView()
    private var picturesCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    private func configureUI() {
        configureBackGroundImage()
        configureStartButton()
        configureBackButton()
        configureSharedButton()
        configureInfoView()
    }
    
    private func configureSharedButton() {
        navigationItem.hidesBackButton = true
        let largeFont = UIFont.systemFont(ofSize: view.bounds.height * Constants.coef8, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: configuration)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(sharedButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constants.color
    }
    
    @objc
    private func sharedButtonTapped() {
        let vc = ChatsViewController()
        vc.configure(with: Vars.route!.route!.id)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureInfoView() {
        view.addSubview(infoView)
        
        infoView.isScrollEnabled = true
        infoView.backgroundColor = Constants.color
        infoView.layer.cornerRadius = Constants.value
        infoView.layer.borderWidth = Constants.coef5
        infoView.layer.borderColor = UIColor.black.cgColor
        
        infoView.contentSize = CGSize(width: view.bounds.width * Constants.coef9, height: view.bounds.height * Constants.coef12)
        
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        infoView.pinWidth(to: view, Constants.coef9)
        infoView.pinBottom(to: startButton.topAnchor, view.bounds.height * Constants.coef34)
        infoView.pinCenterX(to: view)
        
        configureContentView()
    }
    
    private func configureContentView() {
        infoView.addSubview(contentView)
        contentView.frame.size = CGSize(width: view.bounds.width * Constants.coef9, height: view.bounds.height * Constants.coef5)
        contentView.backgroundColor = Constants.color
        
        configureStackLabel()
        configurePicturesCollection()
    }
    
    private func configureName() {
        name.text = Vars.route!.route!.name
        name.font = UIFont.boldSystemFont(ofSize: view.bounds.height * Constants.coef29)
    }
    
    private func configureDescription() {
        desc.text = Vars.route!.route!.description
        desc.font = UIFont.systemFont(ofSize: view.bounds.height * Constants.coef11)
    }
    
    private func configureTime() {
        let minutes = Vars.route!.route!.time
        let rest = minutes % Constants.minutes
        let hours: Int = minutes / Constants.minutes
        var hoursStr = Constants.nilString
        var minStr = Constants.nilString
        if hours != .zero {
            hoursStr = Constants.space + String(hours) + Constants.hour
        }
        if rest != .zero {
            minStr = Constants.space + String(rest) + Constants.min
        }
        time.text = Constants.time + hoursStr + minStr
    }
    
    private func configurePlace() {
        place.text = Constants.startPlace + (Vars.route!.route!.start)
    }
    
    private func configureRaiting() {
        raiting.textColor = .green
        if Vars.route!.route!.raiting.count == .zero {
            raiting.text = Constants.withOutGrades
            raiting.textColor = Constants.gold
            return
        }
        let result = Vars.route!.grade!
        if result < Constants.coef1 {
            raiting.textColor = .red
        }
        raiting.text = Constants.grade + String(NSString(format: Constants.stringFormat, result)) + Constants.fromFive
    }
    
    private func configurePhoto() {
        if Vars.route!.route!.pictures.count == .zero {
            photo.isHidden = true
        }
        photo.text = Constants.places
        photo.font = UIFont.systemFont(ofSize: view.bounds.height * Constants.coef11)
    }
    
    private func configureStackLabel() {
        contentView.addSubview(stackLabel)
        
        stackLabel.axis = .vertical
        stackLabel.spacing = view.bounds.height * Constants.coef20
        
        for label in [name, desc, time, place, raiting, photo] {
            label.textAlignment = .center
            label.textColor = .black
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = .zero
            label.font = UIFont.systemFont(ofSize: view.bounds.height * Constants.coef20)
            
            stackLabel.addArrangedSubview(label)
        }
        
        configureName()
        configureDescription()
        configureTime()
        configurePlace()
        configureRaiting()
        configurePhoto()
        
        stackLabel.translatesAutoresizingMaskIntoConstraints = false
        stackLabel.pinLeft(to: contentView, view.bounds.width * Constants.coef16)
        stackLabel.pinRight(to: contentView, view.bounds.width * Constants.coef16)
        stackLabel.pinTop(to: contentView, view.bounds.height * Constants.coef11)
        stackLabel.pinCenterX(to: contentView)
    }
    
    private func configurePicturesCollection() {
        contentView.addSubview(picturesCollection)
        
        picturesCollection.register(MakePictureCell.self, forCellWithReuseIdentifier: MakePictureCell.reuseIdentifier)
        
        picturesCollection.dataSource = self
        picturesCollection.delegate = self
        picturesCollection.alwaysBounceVertical = true
        picturesCollection.isScrollEnabled = false
        picturesCollection.backgroundColor = Constants.color
        picturesCollection.layer.cornerRadius = Constants.value
        
        if let layout = picturesCollection.collectionViewLayout as?
            UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = .zero
            layout.minimumLineSpacing = .zero
            layout.invalidateLayout()
        }
        
        picturesCollection.translatesAutoresizingMaskIntoConstraints = false
        let heightRest = Vars.route!.route!.pictures.count / Int(Constants.coef5) + Vars.route!.route!.pictures.count % Int(Constants.coef5)
        let heightCoef = Double(heightRest) * Constants.coef35
        picturesCollection.setHeight(view.bounds.width * heightCoef)
        picturesCollection.pinHorizontal(to: contentView, view.bounds.width * Constants.coef16)
        picturesCollection.pinTop(to: stackLabel.bottomAnchor, view.bounds.height * Constants.coef20)
    }
    
    private func configureStartButton() {
        view.addSubview(startButton)
        
        startButton.setTitle(Constants.start.uppercased(), for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.height * Constants.coef29)
        startButton.setTitleColor(.black, for: .normal)
        startButton.setTitleColor(.lightGray, for: .disabled)
        startButton.layer.borderColor = UIColor.black.cgColor
        startButton.layer.borderWidth = Constants.coef5
        startButton.backgroundColor = Constants.color
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.pinWidth(to: view)
        startButton.pinHeight(to: view, Constants.avatarCoef3)
        startButton.pinBottom(to: view)
        
        startButton.addTarget(self, action: #selector(startButtonWasPressed), for: .touchUpInside)
    }
    
    @objc
    private func startButtonWasPressed() {
        let vc = MapViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension RouteViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let newHeight = returnHeight(thisView: stackLabel) + returnHeight(thisView: picturesCollection) + view.bounds.height * Constants.coef16
        let newSize = CGSize(width: view.bounds.width * Constants.coef9, height: newHeight)
        contentView.frame.size = newSize
        infoView.contentSize = newSize
        return Constants.one
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Vars.route!.route!.pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MakePictureCell.reuseIdentifier, for: indexPath)
        guard let pictureCell = cell as? MakePictureCell else {
            return cell
        }
        let image = UIImageView()
        UIViewController().returnImage(imageView: image, key: Vars.route!.route!.pictures[indexPath.row])
        pictureCell.configure(with: image)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RouteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width * Constants.coef22
        return CGSize(width: width, height: width * Constants.coef23)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return view.bounds.width / Constants.coef14
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return view.bounds.width / Constants.coef14
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: view.bounds.height * Constants.coef20, left: .zero, bottom: view.bounds.height * Constants.coef20, right: .zero)
    }
}
