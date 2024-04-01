//
//  ChatViewController.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 04.03.2024.
//

import UIKit

class ChatViewController: UIViewController {
    private var messagesCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    var users: [User] = []
    private var newMessage = UITextField()
    private var newMessageView = UIView()
    private var newMessageButton = UIButton()
    private var userView = UIView()
    var indexes: [IndexPath: CGFloat] = [:]
    var images: [IndexPath: UIImageView] = [:]
    private lazy var error = UILabel()
    private lazy var errorView = UIView()
    private let tick = UIButton()
    private let cross = UIButton()
    private let eye = UIButton()
    private let startButton = UIButton()
    private let deniedButton = UIButton()
    var routeId = Constants.nilString
    private let stackButton = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Vars.messages = []
        Vars.nilMessage.user = Vars.user!.id
        Vars.nilMessage.chatId = Vars.chat!.id
        configureUI()
    }
    
    private func configureUI() {
        Task {
            do {
                try await NetworkService.shared.setUpWebSocket()
                try await NetworkService.shared.sendMessages(message: URLSessionWebSocketTask.Message.data(JSONEncoder().encode(Vars.nilMessage))
                )
                users = try await NetworkService.shared.getAllUsers()
                Vars.chat = try await NetworkService.shared.getChat(id: Vars.chat!.id)
                Vars.messages = try await NetworkService.shared.getAllMessages(chat: Vars.chat!)
                DispatchQueue.main.async { [self] in
                    Vars.messages.sort(by: {$0.time < $1.time})
                    configureUserView()
                    configureNewMessageView()
                    configureMessagesCollection()
                    messagesCollection.isHidden = true
                    configureGrayView()
                    configureStackButtons()
                    DispatchQueue.main.async {
                        Task {
                            var index: Int = .zero
                            while (index < Vars.messages.count) {
                                self.messagesCollection.scrollToItem(at: IndexPath(row: index - Constants.one, section: .zero), at: .bottom, animated: true)
                                try await Task.sleep(nanoseconds:  Constants.chatWait)
                                index += Constants.step
                            }
                            self.messagesCollection.scrollToItem(at: IndexPath(row: Vars.messages.count - Constants.one, section: .zero), at: .bottom, animated: true)
                            try await Task.sleep(nanoseconds:  Constants.chatWait)
                            self.messagesCollection.isHidden = false
                            try await NetworkService.shared.receiveMessagesChat(collection: self.messagesCollection, vc: self)
                        }
                    }
                }
            } catch {
                navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                print("Произошла ошибка: \(error)")
            }
        }
        configureBackGroundImage()
        configureBackButton()
        hideKeyboardOnTapAround(messagesCollection)
    }
    
    @objc
    override func backButtonTapped() {
        if !messagesCollection.isHidden {
            Vars.messages = []
            Vars.chat = nil
            navigationController?.pushViewController(ChatsViewController(), animated: false)
        }
        
    }
    
    private func configureUserView() {
        view.addSubview(userView)
        
        userView.layer.borderWidth = CGFloat(Constants.one)
        userView.backgroundColor = .gray
        userView.layer.borderColor = UIColor.black.cgColor
        
        userView.translatesAutoresizingMaskIntoConstraints = false
        userView.pinHeight(to: view, Constants.coef45)
        userView.pinHorizontal(to: view)
        userView.pinTop(to: view)
        
        let circle = UIView()
        userView.addSubview(circle)
        circle.backgroundColor = Constants.color
        circle.setHeight(view.bounds.height * Constants.coef46)
        circle.setWidth(view.bounds.height * Constants.coef46)
        circle.layer.cornerRadius = view.bounds.height * Constants.coef46 / Constants.coef5
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.pinBottom(to: userView, Constants.coef7)
        circle.pinRight(to: userView, Constants.value)
        
        var nameChat = Constants.nilString
        var avatarChat = Constants.nilString
        for user in Vars.chat!.users {
            if user == Vars.user!.id {
                continue
            }
            nameChat += "\(users[(users.firstIndex(where: {$0.id == user})!)].name) "
            avatarChat = users[users.firstIndex(where: {$0.id == user})!].avatar
        }
        let avatar = UIImageView()
        circle.addSubview(avatar)
        
        returnImage(imageView: avatar, key: avatarChat)
        avatar.setHeight(view.bounds.height * Constants.coef29)
        avatar.setWidth(view.bounds.height * Constants.coef16)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.pinCenter(to: circle)
        
        let name = UILabel()
        userView.addSubview(name)
        name.text = nameChat
        name.textColor = .black
        name.font = UIFont.boldSystemFont(ofSize: Constants.horiz1)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.pinCenterX(to: userView)
        name.pinBottom(to: userView, Constants.coef5)
    }
    
    func configureStackButtons() {
        if !Vars.chat!.routeSuggest.isEmpty {
            view.addSubview(stackButton)
            stackButton.isHidden = false
            
            stackButton.axis = .horizontal
            stackButton.spacing = .zero
            
            for button in [startButton, deniedButton] {
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.bounds.height / Constants.coef2)
                button.setTitleColor(.black, for: .normal)
                button.setTitleColor(.lightGray, for: .disabled)
                
                button.layer.borderWidth = CGFloat(Constants.one)
                button.layer.borderColor = UIColor.black.cgColor
                
                button.translatesAutoresizingMaskIntoConstraints = false
                button.setHeight(view.bounds.height / Constants.coef4)
                button.setWidth(view.bounds.width / Constants.coef5)
                stackButton.addArrangedSubview(button)
            }
            
            startButton.setTitle(Constants.start, for: .normal)
            deniedButton.setTitle(Constants.denied, for: .normal)
            
            startButton.backgroundColor = Constants.green
            deniedButton.backgroundColor = Constants.red
            
            startButton.addTarget(self, action: #selector(startButtonWasPressed), for: .touchUpInside)
            deniedButton.addTarget(self, action: #selector(deniedButtonWasPressed), for: .touchUpInside)
            
            stackButton.translatesAutoresizingMaskIntoConstraints = false
            stackButton.pinTop(to: userView.bottomAnchor)
            stackButton.pinCenterX(to: view)
        } else {
            stackButton.isHidden = true
        }
    }
    
    @objc
    private func startButtonWasPressed() {
        Task {
            do {
                Vars.route = try await NetworkService.shared.getRoute(id: Vars.chat!.routeSuggest)
                navigationController?.pushViewController(MapViewController(), animated: true)
            } catch {
                navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                print("Произошла ошибка: \(error)")
            }
        }
    }
    
    @objc
    private func deniedButtonWasPressed() {
        Task {
            do {
                let route = try await NetworkService.shared.getRoute(id: Vars.chat!.routeSuggest)
                newMessage.text = Constants.deniedMessage + route.route!.name
                Vars.chat = try await NetworkService.shared.getChat(id: Vars.chat!.id)
                Vars.chat = try await NetworkService.shared.updateChat(id: Vars.chat!.id, users: Vars.chat!.users, messages: Vars.chat!.messages, last: Constants.format.string(from: Date.now), routeSuggest: Constants.nilString)
                newMessageButtonWasPressed()
            } catch {
                navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                print("Произошла ошибка: \(error)")
            }
        }
    }
    
    private func configureGrayView() {
        let grayView = UIView()
        
        view.addSubview(grayView)
        
        grayView.backgroundColor = .gray
        
        grayView.translatesAutoresizingMaskIntoConstraints = false
        grayView.pinTop(to: newMessageView.bottomAnchor, -Constants.coef5)
        grayView.pinHorizontal(to: view)
        grayView.pinBottom(to: view)
    }
    
    private func configureMessagesCollection() {
        view.addSubview(messagesCollection)
        
        messagesCollection.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.reuseId)
        messagesCollection.register(RouteSuggestCell.self, forCellWithReuseIdentifier: RouteSuggestCell.reuseId)
        
        messagesCollection.dataSource = self
        messagesCollection.delegate = self
        messagesCollection.alwaysBounceVertical = true
        messagesCollection.backgroundColor = .clear
        messagesCollection.layer.cornerRadius = Constants.value
        if let layout = messagesCollection.collectionViewLayout as?
            UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = .zero
            layout.minimumLineSpacing = .zero
            layout.invalidateLayout()
        }
        
        messagesCollection.translatesAutoresizingMaskIntoConstraints = false
        messagesCollection.pinBottom(to: newMessageView.topAnchor, view.bounds.height * Constants.coef34)
        messagesCollection.pinHorizontal(to: view)
        messagesCollection.pinTop(to: userView.bottomAnchor, view.bounds.height * Constants.coef34)
    }
    
    private func configureNewMessageView() {
        view.addSubview(newMessageView)
        
        newMessageView.backgroundColor = .gray
        newMessageView.translatesAutoresizingMaskIntoConstraints = false
        newMessageView.pinHeight(to: view, Constants.coef46)
        newMessageView.pinWidth(to: view)
        newMessageView.pinHorizontal(to: view)
        newMessageView.pinBottom(to: view.keyboardLayoutGuide.topAnchor)
        
        configureNewMessage()
        configureNewMessageButton()
    }
    
    private func configureNewMessage() {
        newMessageView.addSubview(newMessage)
        
        newMessage.attributedPlaceholder = NSAttributedString(string: Constants.newMessageString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        newMessage.returnKeyType = UIReturnKeyType.done
        
        newMessage.font = UIFont.boldSystemFont(ofSize: view.bounds.height * Constants.coef20)
        newMessage.textColor = .black
        newMessage.backgroundColor = .white
        newMessage.layer.cornerRadius = view.bounds.height * Constants.coef20
        
        newMessage.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
        newMessage.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
        newMessage.leftViewMode = .always
        newMessage.rightViewMode = .always
        newMessage.layer.borderWidth = CGFloat(Constants.one)
        newMessage.layer.borderColor = UIColor.black.cgColor
        
        newMessage.translatesAutoresizingMaskIntoConstraints = false
        newMessage.pinLeft(to: newMessageView, view.bounds.width * Constants.coef16)
        newMessage.pinCenterY(to: newMessageView)
        newMessage.setHeight(view.bounds.height * Constants.coef44)
        newMessage.setWidth(view.bounds.width * Constants.avatarCoef1)
    }
    
    private func configureNewMessageButton() {
        newMessageView.addSubview(newMessageButton)
        
        let largeFont = UIFont.systemFont(ofSize: view.bounds.height * Constants.coef44, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: Constants.sendSymbol, withConfiguration: configuration)
        newMessageButton.setBackgroundImage(image, for: .normal)
        newMessageButton.tintColor = .black
        
        newMessageButton.translatesAutoresizingMaskIntoConstraints = false
        newMessageButton.pinCenterX(to: newMessageView, view.bounds.width * Constants.coef47)
        newMessageButton.pinCenterY(to: newMessageView)
        
        newMessageButton.addTarget(self, action: #selector(newMessageButtonWasPressed), for: .touchUpInside)
    }
    
    @objc
    private func newMessageButtonWasPressed() {
        if (newMessage.text?.count != .zero && !messagesCollection.isHidden) {
            let newMessageString = self.newMessage.text
            self.newMessage.text = nil
            var newMessageDB: MessageDate?
            Task {
                do {
                    newMessageDB = try await NetworkService.shared.createMessage(user: Vars.user!.id, route: Constants.nilString, time: Constants.format.string(from: Date.now), text: newMessageString!)
                    Vars.chat = try await NetworkService.shared.getChat(id: Vars.chat!.id)
                    let messageSocket = MessageSocket(chatId: Vars.chat!.id, id: newMessageDB!.id, user: newMessageDB!.user, route: newMessageDB!.route, time: newMessageDB!.time, text: newMessageDB!.text)
                    let message = URLSessionWebSocketTask.Message.data(try JSONEncoder().encode(messageSocket))
                    Vars.chat?.messages.append(newMessageDB!.id)
                    try await NetworkService.shared.sendMessages(message: message)
                    Vars.chat = try await NetworkService.shared.updateChat(id: Vars.chat!.id, users: Vars.chat!.users, messages: Vars.chat!.messages, last: Constants.format.string(from: newMessageDB!.time), routeSuggest: Vars.chat!.routeSuggest)
                } catch {
                    self.navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                    print("Произошла ошибка: \(error)")
                }
            }
        }
    }
    
    func configureErrorView() {
        newMessage.isEnabled = false
        errorView.isHidden = false
        configureErrorView(errorView: errorView, error: error)
        errorView.backgroundColor = Constants.color
        error.text = Constants.routeMessage
        error.textAlignment = .center
        
        let largeFont = UIFont.systemFont(ofSize: view.bounds.height * Constants.coef44, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        
        configureTick(tick: tick, errorView: errorView, configuration: configuration)
        configureCross(cross: cross, errorView: errorView, configuration: configuration)
        
        eye.isHidden = false
        let imageCross = UIImage(systemName: Constants.eyeSymbol, withConfiguration: configuration)
        eye.setBackgroundImage(imageCross, for: .normal)
        errorView.addSubview(eye)
        eye.tintColor = .black
        eye.pinCenterX(to: errorView)
        eye.pinTop(to: error.bottomAnchor, Constants.coef7)
        
        eye.addTarget(self, action: #selector(eyeButtonWasPressed), for: .touchUpInside)
        cross.addTarget(self, action: #selector(crossButtonWasPressed), for: .touchUpInside)
        tick.addTarget(self, action: #selector(tickButtonWasPressed), for: .touchUpInside)
    }
    
    @objc
    private func eyeButtonWasPressed() {
        navigationController?.pushViewController(RouteViewController(), animated: true)
    }
    
    @objc
    private func crossButtonWasPressed() {
        errorView.isHidden = true
        newMessage.isEnabled = true
    }
    
    @objc
    private func tickButtonWasPressed() {
        Task {
            do {
                let route = try await NetworkService.shared.getRoute(id: routeId)
                newMessage.text = Constants.acceptMessage + route.route!.name
                Vars.chat = try await NetworkService.shared.getChat(id: Vars.chat!.id)
                Vars.chat = try await NetworkService.shared.updateChat(id: Vars.chat!.id, users: Vars.chat!.users, messages: Vars.chat!.messages, last: Constants.format.string(from: Date.now), routeSuggest: routeId)
                newMessageButtonWasPressed()
                crossButtonWasPressed()
            } catch {
                self.navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                print("Произошла ошибка: \(error)")
            }
        }
    }
    
    @objc
    override func dismissKeyboard() {
        super.dismissKeyboard()
        
        crossButtonWasPressed()
    }
}
