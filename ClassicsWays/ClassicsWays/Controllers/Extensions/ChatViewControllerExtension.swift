//
//  ChatViewControllerExtension.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 01.04.2024.
//

import UIKit

// MARK: - UICollectionViewDataSource
extension ChatViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constants.one
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Vars.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !Vars.messages[indexPath.row].route.isEmpty {
            let routeId = Vars.messages[indexPath.row].route
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RouteSuggestCell.reuseId, for: indexPath)
            guard let messageCell = cell as? RouteSuggestCell else {
                return cell
            }
            if self.indexes[indexPath] == nil {
                self.indexes[indexPath] = Constants.coef18
            }
            messageCell.configure(with: routeId, with: self.view.bounds.height)
            return messageCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.reuseId, for: indexPath)
            guard let messageCell = cell as? MessageCell else {
                return cell
            }
            
            var user: User?
            user = users[users.firstIndex(where: {$0.id == Vars.messages[indexPath.row].user})!]
            let coef = messageCell.configure(with: user!.name, with: Vars.messages[indexPath.row].text, with: user!.avatar, with: view.bounds.height)
            guard self.indexes[indexPath] != nil else {
                self.indexes[indexPath] = coef
                return messageCell
            }
            return messageCell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let coef = indexes[indexPath] else {
            return CGSize(width: view.bounds.width, height: view.bounds.height * Constants.coef19)
        }
        return CGSize(width: view.bounds.width, height: view.bounds.height * Constants.coef19 * coef)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userSuggested = Vars.messages[indexPath.row].user
        if !Vars.messages[indexPath.row].route.isEmpty && userSuggested != Vars.user!.id {
            routeId = Vars.messages[indexPath.row].route
            Task {
                do {
                    Vars.route = try await NetworkService.shared.getRoute(id: routeId)
                    DispatchQueue.main.async {
                        self.configureErrorView()
                    }
                } catch {
                    navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                    print("Произошла ошибка: \(error)")
                }
            }
        }
    }
}

