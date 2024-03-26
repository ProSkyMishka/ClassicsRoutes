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
    private var contentSize: CGSize?
    private var rest: Int = (Vars.route!.route!.pictures.count - 4) / 2 + (Vars.route!.route!.pictures.count - 4) % 2
    private var coef = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coef = 1.0 + Double(rest) * 0.3
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
        let largeFont = UIFont.systemFont(ofSize: view.bounds.height * 0.025, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: configuration)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(sharedButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constants.color
    }
    
    @objc
    private func sharedButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureInfoView() {
        view.addSubview(infoView)
        
        infoView.isScrollEnabled = true
        infoView.backgroundColor = Constants.color
        infoView.layer.cornerRadius = Constants.radius
        infoView.layer.borderWidth = 2
        infoView.layer.borderColor = UIColor.black.cgColor
        
        contentSize = CGSize(width: view.bounds.width * 0.95, height: view.bounds.height * 0.85)
        if Vars.route!.route!.pictures.count > 4 {
            contentSize = CGSize(width: view.bounds.width * 0.95, height: view.bounds.height * 0.85 * coef)
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
        
        configureStackLabel()
        configurePicturesCollection()
    }
    
    private func configureName() {
        name.text = Vars.route!.route!.name
        name.font = UIFont.boldSystemFont(ofSize: view.bounds.height * 0.042)
    }
    
    private func configureDescription() {
        desc.text = Vars.route!.route!.description
        desc.font = UIFont.systemFont(ofSize: view.bounds.height * 0.032)
    }
    
    private func configureTime() {
        let minutes = Vars.route!.route!.time
        let rest = minutes % 60
        let hours: Int = minutes / 60
        var hoursStr = ""
        var minStr = ""
        if hours != 0 {
            hoursStr = " \(hours) ч."
        }
        if rest != 0 {
            minStr = " \(rest) мин."
        }
        time.text = "Время прохождения:\(hoursStr)\(minStr)"
    }
    
    private func configurePlace() {
        place.text = "Точка старта:\n\(Vars.route!.route!.start)"
    }
    
    private func configureRaiting() {
        raiting.textColor = .green
        if Vars.route!.route!.raiting.count == 0 {
            raiting.text = "Нет оценок"
            raiting.textColor = Constants.gold
            return
        }
        let result = Vars.route!.grade!
        if result < 4 {
            raiting.textColor = .red
        }
        raiting.text = "Оценка:  \(NSString(format: "%.2f", result))/5"
    }
    
    private func configurePhoto() {
        if Vars.route!.route!.pictures.count == 0 {
            photo.isHidden = true
        }
        photo.text = "Места из маршрута:"
        photo.font = UIFont.systemFont(ofSize: view.bounds.height * 0.032)
    }
    
    private func configureStackLabel() {
        contentView.addSubview(stackLabel)
        
        stackLabel.axis = .vertical
        stackLabel.spacing = view.bounds.height * 0.02
        
        for label in [name, desc, time, place, raiting, photo] {
            label.textAlignment = .center
            label.textColor = .black
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = .zero
            label.font = UIFont.systemFont(ofSize: view.bounds.height * 0.021)
            
            stackLabel.addArrangedSubview(label)
        }
        
        configureName()
        configureDescription()
        configureTime()
        configurePlace()
        configureRaiting()
        configurePhoto()
        
        stackLabel.translatesAutoresizingMaskIntoConstraints = false
        stackLabel.pinLeft(to: contentView, view.bounds.width * 0.05)
        stackLabel.pinRight(to: contentView, view.bounds.width * 0.05)
        stackLabel.pinTop(to: contentView, view.bounds.height * 0.03)
        stackLabel.pinCenterX(to: contentView)
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
        let heightRest = Vars.route!.route!.pictures.count / 2 + Vars.route!.route!.pictures.count % 2
        let heightCoef = Double(heightRest) * 0.3
        picturesCollection.pinHeight(to: view, 0.85 * heightCoef)
        picturesCollection.pinHorizontal(to: contentView, view.bounds.width * 0.05)
        picturesCollection.pinTop(to: stackLabel.bottomAnchor, view.bounds.height * 0.02)
    }
    
    private func configureStartButton() {
        view.addSubview(startButton)
        
        startButton.setTitle("НАЧАТЬ", for: .normal)
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
    
    @objc
    private func startButtonWasPressed() {
        let vc = MapViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension RouteViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Vars.route!.route!.pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCell.reuseIdentifier, for: indexPath)
        guard let pictureCell = cell as? PictureCell else {
            return cell
        }
        pictureCell.configure(with: Vars.route!.route!.pictures[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RouteViewController: UICollectionViewDelegateFlowLayout {
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
