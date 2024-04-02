//
//  MapViewController.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 01.03.2024.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, MKMapViewDelegate
{
    private var infoView = UIScrollView()
    private lazy var contentView = UIView()
    private let locationManager = CLLocationManager()
    private var coordinatesArray = [CLLocationCoordinate2D]()
    private var annotationsArray = [MKAnnotation]()
    private var overlaysArray = [MKOverlay]()
    private var startLocation = Constants.nilString
    private var finishLocation = Constants.nilString
    private var continueButton = UIButton()
    private var backButton = UIButton()
    private var endButton = UIButton()
    private var stackButton = UIStackView()
    private var currentIndex: Int = .zero
    private var locations = Vars.route!.route!.locations
    private lazy var error = UILabel()
    private lazy var errorView = UIView()
    private var desc = UILabel()
    private let id = Vars.route!.route!.id
    private var raiting = Vars.route!.route!.raiting
    private var likes = Vars.user!.likes
    private var routes = Vars.user!.routes
    private let tick = UIButton()
    private let cross = UIButton()
    private let like = UIButton()
    private let dislike = UIButton()
    private var largeFont: UIFont?
    private var configuration: UIImage.SymbolConfiguration?
    
    private func configureInfoView() {
        view.addSubview(infoView)
        
        infoView.isScrollEnabled = true
        infoView.backgroundColor = Constants.color
        infoView.layer.cornerRadius = Constants.value
        infoView.layer.borderWidth = Constants.coef5
        infoView.layer.borderColor = UIColor.black.cgColor
        
        infoView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.pinTop(to: mapView.bottomAnchor, view.bounds.height * Constants.coef34)
        infoView.pinWidth(to: view)
        infoView.pinBottom(to: stackButton.topAnchor, view.bounds.height * Constants.coef34)
        infoView.pinCenterX(to: view)
        
        configureContentView()
    }
    
    private func configureContentView() {
        infoView.addSubview(contentView)
        contentView.frame.size = CGSize(width: view.bounds.width, height: view.bounds.height)
        contentView.backgroundColor = Constants.color
        
        configureDesc()
    }
    
    private func configureDesc() {
        contentView.addSubview(desc)
        
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.textColor = .black
        desc.font = UIFont.systemFont(ofSize: view.bounds.height * Constants.coef8)
        desc.lineBreakMode = .byWordWrapping
        desc.numberOfLines = .zero
        
        desc.pinCenterX(to: contentView)
        desc.setWidth(view.bounds.width * Constants.coef17)
        desc.pinTop(to: contentView, Constants.coef14)
    }
    
    let mapView: MKMapView = {
        let control = MKMapView()
        control.layer.masksToBounds = true
        control.clipsToBounds = false
        control.translatesAutoresizingMaskIntoConstraints = false
        control.showsScale = true
        control.showsCompass = true
        control.showsTraffic = true
        control.showsBuildings = true
        control.showsUserLocation = true
        return control
    }()
    
    private func findLocation(location: String, showRegion: Bool = false, completion: @escaping () -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                let coordinates = placemark.location!.coordinate
                self.coordinatesArray.append(coordinates)
                let point = MKPointAnnotation()
                point.coordinate = coordinates
                
                if let country = placemark.country {
                    point.subtitle = country
                }
                
                self.mapView.addAnnotation(point)
                self.annotationsArray.append(point)
                
                if showRegion {
                    self.mapView.centerCoordinate = coordinates
                    let span = MKCoordinateSpan(latitudeDelta: Constants.coef17, longitudeDelta: Constants.coef17)
                    let region = MKCoordinateRegion(center: coordinates, span: span)
                    self.mapView.setRegion(region, animated: showRegion)
                }
            } else {
                print(String(describing: error))
            }
            completion()
        }
    }
    
    private func showCurrent(coordinates: CLLocationCoordinate2D, showRegion: Bool = false, completion: @escaping () -> Void ) {
        let point = MKPointAnnotation()
        point.coordinate = coordinates
        point.title = Constants.nilString
        point.subtitle = Constants.nilString
        
        self.mapView.addAnnotation(point)
        self.annotationsArray.append(point)
        
        if showRegion {
            self.mapView.centerCoordinate = coordinates
            let span = MKCoordinateSpan(latitudeDelta: Constants.coef17, longitudeDelta: Constants.coef17)
            let region = MKCoordinateRegion(center: coordinates, span: span)
            self.mapView.setRegion(region, animated: showRegion)
        }
        completion()
    }
    
    private func doAfterOne() {
        let completion2 = findLocations
        DispatchQueue.global(qos: .utility).async {
            self.findLocation(location: self.finishLocation, showRegion: true, completion: completion2)
        }
    }
    
    private func findLocations() {
        if self.coordinatesArray.count < Int(Constants.coef5) {
            return
        }
        
        let markLocationOne = MKPlacemark(coordinate: self.coordinatesArray.first!)
        let markLocationTwo = MKPlacemark(coordinate: self.coordinatesArray.last!)
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: markLocationOne)
        directionRequest.destination = MKMapItem(placemark: markLocationTwo)
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { response, error in
            if error != nil {
                print(String(describing: error))
            } else {
                let myRoute: MKRoute? = response?.routes.first
                if let a = myRoute?.polyline {
                    if self.overlaysArray.count > .zero {
                        self.mapView.removeOverlays(self.overlaysArray)
                        self.overlaysArray = []
                    }
                    self.overlaysArray.append(a)
                    self.mapView.addOverlay(a)
                    
                    let rect = a.boundingMapRect
                    self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                    
                    self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: Constants.coef26, left: Constants.coef26, bottom: Constants.coef26, right: Constants.coef26), animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        largeFont = UIFont.systemFont(ofSize: view.bounds.height * Constants.coef16, weight: .bold)
        configuration = UIImage.SymbolConfiguration(font: largeFont!)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startMap()
    }
    
    private func startMap() {
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[.zero] as CLLocation
        manager.stopUpdatingLocation()
        
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: Constants.coef38, longitudeDelta: Constants.coef38)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    private func setupUI() {
        locationManager.delegate = self
        mapView.delegate = self
        configureBackButton()
        configureBackGroundImage()
        configureEndButton()
        configureStackButton()
        hideKeyboardOnTapAround(view)
        
        self.view.addSubview(mapView)
        
        locationManager.startUpdatingLocation()
        
        mapView.pinLeft(to: view)
        mapView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        mapView.pinRight(to: view)
        mapView.pinHeight(to: view, Constants.coef38)
        
        configureInfoView()
        
        getYourRoute()
    }
    
    @objc
    override func dismissKeyboard() {
        crossWaspressed()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if overlay is MKPolyline {
            polylineRenderer.strokeColor = UIColor.green
            polylineRenderer.lineWidth = Constants.coef1
        }
        return polylineRenderer
    }
    
    private func configureEndButton() {
        view.addSubview(endButton)
        
        endButton.setTitle(Constants.end, for: .normal)
        endButton.backgroundColor = Constants.red
        endButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.height * Constants.coef11)
        endButton.setTitleColor(.black, for: .normal)
        endButton.setTitleColor(.darkGray, for: .disabled)
        
        endButton.layer.borderWidth = CGFloat(Constants.one)
        endButton.layer.borderColor = UIColor.black.cgColor
        
        endButton.translatesAutoresizingMaskIntoConstraints = false
        endButton.setHeight(view.bounds.height * Constants.coef16)
        endButton.setWidth(view.bounds.width)
        endButton.pinBottom(to: view)
        
        endButton.addTarget(self, action: #selector(endButtonWasPressed), for: .touchUpInside)
    }
    
    
    private func configureContinueButton() {
        let imageTick = UIImage(systemName: Constants.arrowRightSymbol, withConfiguration: configuration)
        continueButton.setBackgroundImage(imageTick, for: .normal)
        
        continueButton.addTarget(self, action: #selector(getYourRoute), for: .touchUpInside)
    }
    
    private func configureThisBackButton() {
        let imageTick = UIImage(systemName: Constants.arrowLeftSymbol, withConfiguration: configuration)
        backButton.setBackgroundImage(imageTick, for: .normal)
        
        backButton.addTarget(self, action: #selector(thisBackButtonWasTapped), for: .touchUpInside)
    }
    
    private func configureStackButton() {
        view.addSubview(stackButton)
        
        stackButton.axis = .horizontal
        stackButton.spacing = view.bounds.width * Constants.coef32
        
        for button in [backButton, continueButton] {
            button.tintColor = .black
            button.backgroundColor = Constants.color
            
            button.layer.borderWidth = CGFloat(Constants.one)
            button.layer.borderColor = UIColor.black.cgColor
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setHeight(view.bounds.height * Constants.avatarCoef3)
            button.setWidth(view.bounds.height * Constants.avatarCoef3)
            button.layer.cornerRadius = view.bounds.height * Constants.coef37
            stackButton.addArrangedSubview(button)
        }
        
        configureContinueButton()
        configureThisBackButton()
        
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        stackButton.pinBottom(to: endButton.topAnchor)
        stackButton.pinCenterX(to: view)
    }
    
    @objc
    private func thisBackButtonWasTapped() {
        if currentIndex == Int(Constants.coef18) {
            currentIndex = .zero
            startLocation = Constants.nilString
        } else {
            currentIndex -= Int(Constants.coef1)
        }
        getYourRoute()
    }
    
    @objc
    func getYourRoute() {
        let completion1 = doAfterOne
        if locations.count == .zero {
            endButtonWasPressed()
            return
        }
        
        if self.mapView.annotations.count > .zero {
            self.mapView.removeAnnotations(self.annotationsArray)
            self.annotationsArray = []
        }
        
        if self.overlaysArray.count > .zero {
            self.mapView.removeOverlays(self.overlaysArray)
            self.overlaysArray = []
        }
        
        self.coordinatesArray = []
        
        if startLocation.count == .zero {
            desc.text = locations[currentIndex]
            currentIndex += Constants.one
            finishLocation = locations[currentIndex]
        } else {
            startLocation = locations[currentIndex]
            currentIndex += Constants.one
            desc.text = locations[currentIndex]
            currentIndex += Constants.one
            finishLocation = locations[currentIndex]
        }
        setSize()
        
        blockButtons()

        if startLocation.count == .zero {
            startLocation = finishLocation
            guard let sourceCoordinate = locationManager.location?.coordinate else { return }
            self.coordinatesArray.append(sourceCoordinate)
            doAfterOne()
        } else {
            DispatchQueue.global(qos: .utility).async {
                self.findLocation(location: self.startLocation, showRegion: false, completion: completion1)
            }
        }
    }
    
    private func blockButtons() {
        if locations.count <= Int(Constants.coef5) {
            backButton.isEnabled = false
            continueButton.isEnabled = false
        } else if currentIndex + Constants.one == locations.count {
            backButton.isEnabled = true
            continueButton.isEnabled = false
        } else if currentIndex == Constants.one {
            backButton.isEnabled = false
            continueButton.isEnabled = true
        } else {
            backButton.isEnabled = true
            continueButton.isEnabled = true
        }
    }
    
    @objc
    private func endButtonWasPressed() {
        continueButton.isEnabled = false
        backButton.isEnabled = false
        endButton.isEnabled = false
        errorView.isHidden = false
        configureErrorView(errorView: errorView, error: error)
        
        if currentIndex + Constants.one < locations.count {
            like.isHidden = true
            dislike.isHidden = true
            
            error.pinTop(to: errorView)
            error.text = Constants.routeEnd
            error.textAlignment = .center
            
            errorView.backgroundColor = Constants.red
            
            configureTick(tick: tick, errorView: errorView, configuration: configuration!)
            tick.addTarget(self, action: #selector(tickWaspressed), for: .touchUpInside)
            
            configureCross(cross: cross, errorView: errorView, configuration: configuration!)
            cross.addTarget(self, action: #selector(crossWaspressed), for: .touchUpInside)
        } else {
            tick.isHidden = true
            cross.isHidden = true
            like.isHidden = false
            dislike.isHidden = false
            error.text = Constants.routeLike
            
            errorView.backgroundColor = Constants.color
            
            let imageLike = UIImage(systemName: Constants.likeSymbol, withConfiguration: configuration)
            like.setBackgroundImage(imageLike, for: .normal)
            like.addTarget(self, action: #selector(likeWaspressed), for: .touchUpInside)
            errorView.addSubview(like)
            like.tintColor = .green
            like.pinLeft(to: errorView, view.bounds.width * Constants.coef9 * Constants.coef36)
            like.pinBottom(to: errorView, Constants.coef7)
            
            let imageDislike = UIImage(systemName: Constants.dislikeSymbol, withConfiguration: configuration)
            dislike.setBackgroundImage(imageDislike, for: .normal)
            dislike.addTarget(self, action: #selector(dislikeWaspressed), for: .touchUpInside)
            errorView.addSubview(dislike)
            dislike.tintColor = .red
            dislike.pinRight(to: errorView, view.bounds.width * Constants.coef9 * Constants.coef36)
            dislike.pinBottom(to: errorView, Constants.coef7)
        }
    }
    
    @objc
    private func tickWaspressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func crossWaspressed() {
        tick.isHidden = true
        cross.isHidden = true
        errorView.isHidden = true
        endButton.isEnabled = true
        blockButtons()
    }
    
    @objc
    private func likeWaspressed() {
        errorView.isHidden = true
        if routes.contains(id) && !likes.contains(id) {
            likes.append(id)
            let index = raiting.firstIndex(of: Constants.minus)
            raiting[index!] = Constants.plus
        } else if !routes.contains(id) {
            raiting.append(Constants.plus)
            likes.append(id)
        }
        end()
    }
    
    @objc
    private func dislikeWaspressed() {
        errorView.isHidden = true
        if routes.contains(id) && likes.contains(id) {
            let likeIndex = likes.firstIndex(of: id)
            likes.remove(at: likeIndex!)
            let index = raiting.firstIndex(of: Constants.plus)
            raiting[index!] = Constants.minus
        } else if !routes.contains(id) {
            raiting.append(Constants.minus)
        }
        end()
    }
    
    private func end() {
        if !routes.contains(id) {
            routes.append(id)
        }
        Task {
            do {
                Vars.route = try await NetworkService.shared.getRoute(id: Vars.route!.route!.id)
                DispatchQueue.main.async { [self] in
                    let newRaiting = Vars.route!.route!.raiting
                    if raiting.count - Constants.one < newRaiting.count {
                        for i in (raiting.count - Constants.one)...(newRaiting.count - Constants.one) {
                            raiting.append(newRaiting[i])
                        }
                    }
                }
                Vars.route!.route = try await NetworkService.shared.updateRoute(id: Vars.route!.route!.id, avatar: Vars.route!.route!.avatar, person: Vars.route!.route!.person, name: Vars.route!.route!.name, description: Vars.route!.route!.description, theme: Vars.route!.route!.theme, time: Vars.route!.route!.time, start: Vars.route!.route!.start, pictures: Vars.route!.route!.pictures, raiting: raiting, locations: Vars.route!.route!.locations)
                Vars.user = try await NetworkService.shared.updateUser(id: Vars.user!.id, name: Vars.user!.name, date: Vars.user!.date, avatar: Vars.user!.avatar, routes: routes, role: Vars.user!.role, likes: likes, themes: Vars.user!.themes, password: Vars.password)
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(RoutesViewController(), animated: true)
                }
            } catch {
                print("Произошла ошибка: \(error)")
                navigationController?.pushViewController(RoutesViewController(), animated: true)
            }
        }
    }
    
    private func setSize() {
        desc.numberOfLines = Int(Constants.coef33)
        let sizeDesc = desc.sizeThatFits(CGSize(width: view.bounds.width * Constants.coef17, height: CGFloat.greatestFiniteMagnitude))
        desc.numberOfLines = .zero
        let size = CGSize(width: view.bounds.width, height: sizeDesc.height * Constants.coef39)
        infoView.contentSize = size
        contentView.frame.size = size
    }
}