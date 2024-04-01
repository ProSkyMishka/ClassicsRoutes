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
    private var firstTheme = 0
    private var secondTheme = 0
    private var thirdTheme = 0
    private var second: [RouteWithGrade] = []
    private var third: [RouteWithGrade] = []
    private var themes = Vars.user!.themes
    private var firstHeader = ""
    private var secondHeader = ""
    private var thirdHeader = ""
    private var themesArray = ["Писатели", "Художники", "Исторические лица"]
    private var themesArrayInt = [1, 2, 3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch themes[0] {
        case themesArrayInt[0]:
            firstTheme = themesArrayInt[0]
            firstHeader = themesArray[0]
            themesArray.remove(at: 0)
            themesArrayInt.remove(at: 0)
        case themesArrayInt[1]:
            firstTheme = themesArrayInt[1]
            firstHeader = themesArray[1]
            themesArray.remove(at: 1)
            themesArrayInt.remove(at: 1)
        default:
            firstTheme = themesArrayInt[2]
            firstHeader = themesArray[2]
            themesArray.remove(at: 2)
            themesArrayInt.remove(at: 2)
        }
        
        if themes.count > 1 {
            switch themes[1] {
            case themesArrayInt[0]:
                secondTheme = themesArrayInt[0]
                secondHeader = themesArray[0]
                themesArray.remove(at: 0)
                themesArrayInt.remove(at: 0)
            default:
                secondTheme = themesArrayInt[1]
                secondHeader = themesArray[1]
                themesArray.remove(at: 1)
                themesArrayInt.remove(at: 1)
            }
        } else {
            secondTheme = themesArrayInt[0]
            secondHeader = themesArray[0]
            themesArray.remove(at: 0)
            themesArrayInt.remove(at: 0)
        }
        
        thirdTheme = themesArrayInt[0]
        thirdHeader = themesArray[0]
        
        Task {
            do {
                routes = try await NetworkService.shared.getAllRoutes()
                DispatchQueue.main.async {
                    for route in self.routes {
                        var sum = 0.0
                        for i in route.raiting {
                            if i == "+" {
                                sum += 5.0
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
        status = 3
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
        table.rowHeight = view.bounds.height * 0.3
        table.sectionHeaderHeight = view.bounds.height * 0.05
        
        
        table.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        table.pinWidth(to: view)
        table.pinBottom(to: bar.topAnchor)
    }
    
    func handleDelete(indexPath: IndexPath) {
        if !routes.isEmpty {
            var array: [RouteWithGrade] = []
            switch indexPath[0] {
            case 0:
                array = first
            case 1:
                array = second
            default:
                array = third
            }
            let route = array[indexPath[1]]
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
            switch indexPath[0] {
            case 0:
                array = first
            case 1:
                array = second
            default:
                array = third
            }
            let route = array[indexPath[1]].route
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
        if (section == 0) {
            return firstHeader
        } else if (section == 1) {
            return secondHeader
        }
        return thirdHeader
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return first.count
        } else if section == 1 {
            return second.count
        }
        return third.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RouteCell.reuseId, for: indexPath)
        guard let routeCell = cell as? RouteCell else { return cell }
        if indexPath.section == 0 {
            configureCell(arrayWithGrade: first, indexPath: indexPath, routeCell: routeCell)
        } else if indexPath.section == 1 {
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
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: self.view.bounds.height * 0.04)
        header.layer.borderWidth = 2
        header.layer.borderColor = UIColor.black.cgColor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var array: [RouteWithGrade] = []
        switch indexPath[0] {
        case 0:
            array = first
        case 1:
            array = second
        default:
            array = third
        }
        Vars.route = array[indexPath[1]]
        let vc = RouteViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
                   indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if (Vars.user?.role == "admin") {
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
            deleteAction.backgroundColor = Constants.red
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt
                   indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if (Vars.user?.role == "admin") {
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
            editAction.backgroundColor = Constants.green
            return UISwipeActionsConfiguration(actions: [editAction])
        }
        return nil
    }
}
