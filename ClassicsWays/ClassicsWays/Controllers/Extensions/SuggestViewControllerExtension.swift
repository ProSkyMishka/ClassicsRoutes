//
//  SuggestViewControllerExtension.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 26.03.2024.
//

import UIKit

// MARK: - UICollectionViewDataSource
extension SuggestViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constants.one
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MakePictureCell.reuseIdentifier, for: indexPath)
        guard let pictureCell = cell as? MakePictureCell else {
            return cell
        }
        pictureCell.configure(with: pictures[indexPath.row])
        configureTrash(with: pictureCell, with: indexPath.row)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SuggestViewController: UICollectionViewDelegateFlowLayout {
    private func configureTrash(with cell: MakePictureCell, with index: Int) {
        let trash = UIButton()

        cell.addSubview(trash)
        
        trash.tag = index
        let largeFont = UIFont.systemFont(ofSize: Constants.coef, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let imageTrash = UIImage(systemName: Constants.trashSymbol, withConfiguration: configuration)
        
        trash.setBackgroundImage(imageTrash, for: .normal)
        
        trash.tintColor = .white
        trash.backgroundColor = .black
        trash.layer.cornerRadius = Constants.coef21
        trash.pinTop(to: cell, Constants.coef7)
        trash.pinRight(to: cell, Constants.coef7)
        
        trash.addTarget(self, action: #selector(trashPressed), for: .touchUpInside)
    }
    
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

// MARK: - UITableViewDelegate
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
            systemName: Constants.trashFillSymbol,
            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
        )?.withTintColor(.white)
        deleteAction.backgroundColor = Constants.red
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
            systemName: Constants.editSymbol,
            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
        )?.withTintColor(.white)
        editAction.backgroundColor = Constants.green
        return UISwipeActionsConfiguration(actions: [editAction])
    }
}

// MARK: - UITableViewDataSource
extension SuggestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = Constants.color
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.textAlignment = .center
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: self.view.bounds.height * Constants.coef20)
        header.layer.borderWidth = Constants.coef5
        header.layer.borderColor = UIColor.black.cgColor
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                   section: Int) -> String? {
        return Constants.headerLocations
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
