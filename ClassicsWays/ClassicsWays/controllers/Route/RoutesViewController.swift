//
//  RouteViewController.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 28.02.2024.
//

import UIKit

class RoutesViewController: TemplateViewController {
    private var txtLabel = UILabel()
    private var stick = UIView()
    private var table: UITableView = UITableView(frame: .zero)
    private var routes: [Route] = []
    private var first: [RouteWithGrade] = []
    private var firstTheme: Int = .zero
    private var secondTheme: Int = .zero
    private var thirdTheme: Int = .zero
    private var second: [RouteWithGrade] = []
    private var third: [RouteWithGrade] = []
    private var themes = Vars.user!.themes
    private var firstHeader = Constants.nilString
    private var secondHeader = Constants.nilString
    private var thirdHeader = Constants.nilString
    private var themesArray = [Constants.themeWriter, Constants.themeArtist, Constants.themeHistorical]
    private var themesArrayInt = [Constants.one, Int(Constants.coef5), Int(Constants.coef18)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch themes[.zero] {
        case themesArrayInt[.zero]:
            firstTheme = themesArrayInt[.zero]
            firstHeader = themesArray[.zero]
            themesArray.remove(at: .zero)
            themesArrayInt.remove(at: .zero)
        case themesArrayInt[Constants.one]:
            firstTheme = themesArrayInt[Constants.one]
            firstHeader = themesArray[Constants.one]
            themesArray.remove(at: Constants.one)
            themesArrayInt.remove(at: Constants.one)
        default:
            firstTheme = themesArrayInt[Int(Constants.coef5)]
            firstHeader = themesArray[Int(Constants.coef5)]
            themesArray.remove(at: Int(Constants.coef5))
            themesArrayInt.remove(at: Int(Constants.coef5))
        }
        
        if themes.count > Constants.one {
            switch themes[Constants.one] {
            case themesArrayInt[.zero]:
                secondTheme = themesArrayInt[.zero]
                secondHeader = themesArray[.zero]
                themesArray.remove(at: .zero)
                themesArrayInt.remove(at: .zero)
            default:
                secondTheme = themesArrayInt[Constants.one]
                secondHeader = themesArray[Constants.one]
                themesArray.remove(at: Constants.one)
                themesArrayInt.remove(at: Constants.one)
            }
        } else {
            secondTheme = themesArrayInt[.zero]
            secondHeader = themesArray[.zero]
            themesArray.remove(at: .zero)
            themesArrayInt.remove(at: .zero)
        }
        
        thirdTheme = themesArrayInt[.zero]
        thirdHeader = themesArray[.zero]
        
        Task {
            do {
                routes = try await NetworkService.shared.getAllRoutes()
                DispatchQueue.main.async {
                    for route in self.routes {
                        var sum: Double = .zero
                        for i in route.raiting {
                            if i == Constants.plus {
                                sum += Constants.coef7
                            }
                        }
                        if route.theme == self.firstTheme {
                            self.first.append(RouteWithGrade(route: route, grade: sum / Double(route.raiting.count)))
                        } else if route.theme == self.secondTheme {
                            self.second.append(RouteWithGrade(route: route, grade: sum / Double(route.raiting.count)))
                        } else {
                            self.third.append(RouteWithGrade(route: route, grade: sum / Double(route.raiting.count)))
                        }
                    }
                    self.first.sort(by: {$0.grade! > $1.grade!})
                    self.second.sort(by: {$0.grade! > $1.grade!})
                    self.third.sort(by: {$0.grade! > $1.grade!})
                    self.configureTable()
                }
            } catch {
                navigationController?.pushViewController(ServerErrorViewController(), animated: false)
                print("Произошла ошибка: \(error)")
            }
        }
        status = Int(Constants.coef18)
        configureUI()
    }
    
    private func configureUI() {
        configureBackGroundImage()
        configureBar()
    }
    
    private func configureTable() {
        table.register(RouteCell.self, forCellReuseIdentifier: RouteCell.reuseId)
        
        view.addSubview(table)
        
        table.backgroundColor = .none
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.rowHeight = view.bounds.height * Constants.coef10
        table.sectionHeaderHeight = view.bounds.height * Constants.coef16
        
        
        table.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        table.pinWidth(to: view)
        table.pinBottom(to: bar.topAnchor)
    }
    
    func handleDelete(indexPath: IndexPath) {
        if !routes.isEmpty {
            var array: [RouteWithGrade] = []
            switch indexPath[.zero] {
            case .zero:
                array = first
            case Constants.one:
                array = second
            default:
                array = third
            }
            let route = array[indexPath[Constants.one]]
            let id = route.route?.id
            Task {
                do {
                    try await NetworkService.shared.deleteRoute(id: id!)
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(RoutesViewController(), animated: false)
                    }
                } catch {
                    print("Произошла ошибка: \(error)")
                }
            }
        }
    }
    
    func handleEdit(indexPath: IndexPath) {
        if !routes.isEmpty {
            var array: [RouteWithGrade] = []
            switch indexPath[.zero] {
            case .zero:
                array = first
            case Constants.one:
                array = second
            default:
                array = third
            }
            let route = array[indexPath[Constants.one]].route
            let vc = SuggestViewController()
            vc.configure(id: route!.id, name: route!.name, person: route!.person, desc: route!.description, time: String(route!.time), place: route!.start, locations: route!.locations, avatar: route!.avatar, pictures: route!.pictures, theme: route!.theme, raiting: route!.raiting)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension RoutesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                   section: Int) -> String? {
        if (section == .zero) {
            return firstHeader
        } else if (section == Constants.one) {
            return secondHeader
        }
        return thirdHeader
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == .zero {
            return first.count
        } else if section == Constants.one {
            return second.count
        }
        return third.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Int(Constants.coef18)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RouteCell.reuseId, for: indexPath)
        guard let routeCell = cell as? RouteCell else { return cell }
        if indexPath.section == .zero {
            configureCell(arrayWithGrade: first, indexPath: indexPath, routeCell: routeCell)
        } else if indexPath.section == Constants.one {
            configureCell(arrayWithGrade: second, indexPath: indexPath, routeCell: routeCell)
        } else {
            configureCell(arrayWithGrade: third, indexPath: indexPath, routeCell: routeCell)
        }
        return routeCell
    }
    
    func configureCell(arrayWithGrade: [RouteWithGrade], indexPath: IndexPath, routeCell: RouteCell) {
        let route = arrayWithGrade[indexPath.row].route!
        routeCell.configure(with: route.person, with: route.name, with: route.avatar, with: route.id, with: view.bounds.height)
    }
}

// MARK: - UITableViewDelegate
extension RoutesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = Constants.color
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: self.view.bounds.height * Constants.coef29)
        header.layer.borderWidth = Constants.coef5
        header.layer.borderColor = UIColor.black.cgColor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var array: [RouteWithGrade] = []
        switch indexPath[.zero] {
        case .zero:
            array = first
        case Constants.one:
            array = second
        default:
            array = third
        }
        Vars.route = array[indexPath[Constants.one]]
        let vc = RouteViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
                   indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if (Vars.user?.role == Constants.adminRole) {
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
        return nil
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt
                   indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if (Vars.user?.role == Constants.adminRole) {
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
        return nil
    }
}
