//
//  RouteFunctions.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 02.03.2024.
//

import Foundation

extension NetworkService {
    func getAllRoutes() async throws -> [Route] {
        guard let url = URL(string: "\(localhost)\(APIMethod.getAllRoutes.rawValue)")
        else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue(Constants.applicationJSON, forHTTPHeaderField: Constants.contentType)
        request.httpMethod = HTTPMethod.get.rawValue
        let userResponce = try await URLSession.shared.data(for: request)
        let userData = userResponce.0
        let decoder = JSONDecoder()
        let routes = try decoder.decode([Route].self, from: userData)
        return routes
    }
    
    func getRoute(id: String) async throws -> RouteWithGrade {
        let idUrl = "/\(id)"
        guard let url = URL(string: "\(localhost)\(APIMethod.getAllRoutes.rawValue)\(idUrl)")
        else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue(Constants.applicationJSON, forHTTPHeaderField: Constants.contentType)
        request.httpMethod = "GET"
        let routeResponce = try await URLSession.shared.data(for: request)
        let routeData = routeResponce.0
        let decoder = JSONDecoder()
        let route = try decoder.decode(Route.self, from: routeData)
        var sum: Double = .zero
        for i in route.raiting {
            if i == Constants.plus {
                sum += Constants.coef7
            }
        }
        let routeWithGrade = RouteWithGrade(route: route, grade: sum / Double(route.raiting.count))
        return routeWithGrade
    }
    
    func updateRoute(id: String,
                     avatar: String,
                     person: String,
                     name: String,
                     description: String,
                     theme: Int,
                     time: Int,
                     start: String,
                     pictures: [String],
                     raiting: [String],
                     locations: [String]) async throws -> Route {
        let dto = RouteDTOAll(avatar: avatar, person: person, name: name, description: description, theme: theme, time: time, start: start, pictures: pictures, raiting: raiting, locations: locations)
        let idUrl = "/\(id)"
        guard let url = URL(string: "\(localhost)\(APIMethod.getAllRoutes.rawValue)\(idUrl)")
        else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue(Constants.applicationJSON, forHTTPHeaderField: Constants.contentType)
        request.httpMethod = HTTPMethod.put.rawValue
        let encoder = JSONEncoder()
        let data = try encoder.encode(dto)
        request.httpBody = data
        
        let routeResponce = try await URLSession.shared.data(for: request)
        let routeData = routeResponce.0
        let decoder = JSONDecoder()
        let route = try decoder.decode(Route.self, from: routeData)
        return route
    }
    
    func createRoute(avatar: String,
                     person: String,
                     name: String,
                     description: String,
                     theme: Int,
                     time: Int,
                     start: String,
                     pictures: [String],
                     raiting: [String],
                     locations: [String]) async throws -> Route {
        let dto = RouteDTOAll(avatar: avatar, person: person, name: name, description: description, theme: theme, time: time, start: start, pictures: pictures, raiting: raiting, locations: locations)
        guard let url = URL(string: "\(localhost)\(APIMethod.getAllRoutes.rawValue)")
        else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue(Constants.applicationJSON, forHTTPHeaderField: Constants.contentType)
        request.httpMethod = HTTPMethod.post.rawValue
        let encoder = JSONEncoder()
        let data = try encoder.encode(dto)
        request.httpBody = data
        
        let routeResponce = try await URLSession.shared.data(for: request)
        let routeData = routeResponce.0
        let decoder = JSONDecoder()
        let route = try decoder.decode(Route.self, from: routeData)
        return route
    }
    
    func deleteRoute(id: String) async throws {
        let idUrl = "/\(id)"
        guard let url = URL(string: "\(localhost)\(APIMethod.getAllRoutes.rawValue)\(idUrl)")
        else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue(Constants.applicationJSON, forHTTPHeaderField: Constants.contentType)
        request.httpMethod = HTTPMethod.delete.rawValue
        _ = try await URLSession.shared.data(for: request)
    }
}

struct RouteDTOAll: Encodable {
    let avatar: String
    let person: String
    let name: String
    let description: String
    let theme: Int
    let time: Int
    let start: String
    let pictures: [String]
    let raiting: [String]
    let locations: [String]
}
