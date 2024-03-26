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
    private var users: [User] = []
    private var messages: [MessageDate] = []
    private var newMessage = UITextField()
    private var newMessageView = UIView()
    private var newMessageButton = UIButton()
    private var userView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        Task {
            do {
                users = try await NetworkService.shared.getAllUsers()
                messages = try await NetworkService.shared.getAllMessages()
                DispatchQueue.main.async { [self] in
                    messages.sort(by: {$0.time < $1.time})
                    configureNewMessageView()
                    configureMessagesCollection()
                    configureGrayView()
                }
            } catch {
                navigationController?.pushViewController(ServerErrorViewController(), animated: true)
                print("Произошла ошибка: \(error)")
            }
        }
        configureBackGroundImage()
        configureUserView()
        configureBackButton()
        hideKeyboardOnTapAround()
    }
    
    private func configureUserView() {
        view.addSubview(userView)
        
        userView.layer.borderWidth = CGFloat(Constants.one)
        userView.backgroundColor = .gray
        userView.layer.borderColor = UIColor.black.cgColor
        
        userView.translatesAutoresizingMaskIntoConstraints = false
        userView.pinHeight(to: view, 0.13)
        userView.pinHorizontal(to: view)
        userView.pinTop(to: view)
        
        let circle = UIView()
        userView.addSubview(circle)
        circle.backgroundColor = Constants.color
        circle.setHeight(view.bounds.height * 0.08)
        circle.setWidth(view.bounds.height * 0.08)
        circle.layer.cornerRadius = view.bounds.height * 0.04
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.pinBottom(to: userView, 5)
        circle.pinRight(to: userView, 20)
        
        let avatar = UIImageView()
        circle.addSubview(avatar)
        returnImage(imageView: avatar, key: Vars.chatAvatar)
        avatar.setHeight(view.bounds.height * 0.04)
        avatar.setWidth(view.bounds.height * 0.05)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.pinCenter(to: circle)
        
        let name = UILabel()
        userView.addSubview(name)
        name.text = Vars.chatName
        name.textColor = .black
        name.font = UIFont.boldSystemFont(ofSize: 30)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.pinCenterX(to: userView)
        name.pinBottom(to: userView, 2)
    }
    
    private func configureGrayView() {
        let grayView = UIView()
        
        view.addSubview(grayView)
        
        grayView.backgroundColor = .gray
        
        grayView.translatesAutoresizingMaskIntoConstraints = false
        grayView.pinTop(to: newMessageView.bottomAnchor, -2)
        grayView.pinHorizontal(to: view)
        grayView.pinBottom(to: view)
    }
    
    private func configureMessagesCollection() {
        view.addSubview(messagesCollection)
        
        messagesCollection.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.reuseId)
        
        messagesCollection.dataSource = self
        messagesCollection.delegate = self
        messagesCollection.alwaysBounceVertical = true
        messagesCollection.isScrollEnabled = true
        messagesCollection.backgroundColor = .clear
        messagesCollection.layer.cornerRadius = Constants.radius
        
        if let layout = messagesCollection.collectionViewLayout as?
            UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = .zero
            layout.minimumLineSpacing = .zero
            layout.invalidateLayout()
        }
        
        messagesCollection.translatesAutoresizingMaskIntoConstraints = false
        messagesCollection.pinBottom(to: newMessageView.topAnchor, view.bounds.height * 0.01)
        messagesCollection.pinHorizontal(to: view)
        messagesCollection.pinTop(to: userView.bottomAnchor, view.bounds.height * 0.01)
    }
    
    private func configureNewMessageView() {
        view.addSubview(newMessageView)
        
        newMessageView.backgroundColor = .gray
        newMessageView.translatesAutoresizingMaskIntoConstraints = false
        newMessageView.pinHeight(to: view, 0.08)
        newMessageView.pinWidth(to: view)
        newMessageView.pinHorizontal(to: view)
        newMessageView.pinBottom(to: view.keyboardLayoutGuide.topAnchor)
        
        configureNewMessage()
        configureNewMessageButton()
    }
    
    private func configureNewMessage() {
        newMessageView.addSubview(newMessage)
        
        newMessage.attributedPlaceholder = NSAttributedString(string: "Сообщение", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        newMessage.returnKeyType = UIReturnKeyType.done
        
        newMessage.font = UIFont.boldSystemFont(ofSize: view.bounds.height * 0.02)
        newMessage.textColor = .black
        newMessage.backgroundColor = .white
        newMessage.layer.cornerRadius = view.bounds.height * 0.02
        
        newMessage.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
        newMessage.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.offset, height: Constants.offset))
        newMessage.leftViewMode = .always
        newMessage.rightViewMode = .always
        newMessage.layer.borderWidth = CGFloat(Constants.one)
        newMessage.layer.borderColor = UIColor.black.cgColor
        
        newMessage.translatesAutoresizingMaskIntoConstraints = false
        newMessage.pinLeft(to: newMessageView, view.bounds.width * 0.05)
        newMessage.pinCenterY(to: newMessageView)
        newMessage.setHeight(view.bounds.height * 0.06)
        newMessage.setWidth(view.bounds.width * 0.8)
    }
    
    private func configureNewMessageButton() {
        newMessageView.addSubview(newMessageButton)
    
        let largeFont = UIFont.systemFont(ofSize: view.bounds.height * 0.06, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: configuration)
        newMessageButton.setBackgroundImage(image, for: .normal)
        newMessageButton.tintColor = .black
        
        newMessageButton.translatesAutoresizingMaskIntoConstraints = false
        newMessageButton.pinCenterX(to: newMessageView, view.bounds.width * 0.425)
        newMessageButton.pinCenterY(to: newMessageView)
        
        newMessageButton.addTarget(self, action: #selector(newMessageButtonWasPressed), for: .touchUpInside)
    }
    
    @objc
    private func newMessageButtonWasPressed() {
        if (newMessage.text?.count != 0) {
            let newMessageString = newMessage.text
            newMessage.text = nil
            var newMessageDB: MessageDate?
            Task {
                do {
                    newMessageDB = try await NetworkService.shared.createMessage(user: Vars.user!.id, route: "", routeSuggest: "", time: Constants.format.string(from: Date.now), text: newMessageString!)
                    Vars.chat = try await NetworkService.shared.getChat(id: Vars.chat!.id)
                    DispatchQueue.main.async { [self] in
                        messages.append(newMessageDB!)
                        messagesCollection.reloadData()
                        Vars.chat?.messages.append(newMessageDB!.id)
                        Task {
                            do {
                                Vars.chat = try await NetworkService.shared.updateChat(id: Vars.chat!.id, users: Vars.chat!.users, messages: Vars.chat!.messages, last: Constants.format.string(from: newMessageDB!.time))
                            } catch {
                                navigationController?.pushViewController(ServerErrorViewController(), animated: true)
                                print("Произошла ошибка: \(error)")
                            }
                        }
                    }
                } catch {
                    navigationController?.pushViewController(ServerErrorViewController(), animated: true)
                    print("Произошла ошибка: \(error)")
                }
            }
        }
    }
    
//    @objc
//    override func dismissKeyboard() {
//        view.endEditing(true)
//        Task {
//            do {
//                users = try await NetworkService.shared.getAllUsers()
//                Vars.chat = try await NetworkService.shared.getChat(id: Vars.chat!.id)
//                messages = try await NetworkService.shared.getAllMessages()
//                for i in messages {
//                    print(i)
//                }
//                DispatchQueue.main.async { [self] in
//                    messages.sort(by: {$0.time < $1.time})
//                    messagesCollection.reloadData()
//                }
//            } catch {
//                navigationController?.pushViewController(ServerErrorViewController(), animated: true)
//                print("Произошла ошибка: \(error)")
//            }
//        }
//    }
}

// MARK: - UICollectionViewDataSource
extension ChatViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.reuseId, for: indexPath)
        guard let messageCell = cell as? MessageCell else {
            return cell
        }
        var user: User?
        user = users[users.firstIndex(where: {$0.id == messages[indexPath.row].user})!]
        messageCell.configure(with: user!.name, with: messages[indexPath.row].text, with: user!.avatar)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        return CGSize(width: width, height: width * 0.2)
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


