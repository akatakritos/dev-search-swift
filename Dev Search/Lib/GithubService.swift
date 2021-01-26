//
//  GithubService.swift
//  Dev Search
//
//  Created by Matt Burke on 1/25/21.
//

import Foundation
import Combine
import os



struct GithubService {
    private let gitHubDecoder = JSONDecoder()
    private static let log = Logger(subsystem: "GithubService", category: "networking")

    init () {
        gitHubDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func getUser(username: String) -> AnyPublisher<GithubUser?, Never> {
        let url = URL(string: "https://api.github.com/users/\(username)")!

        return get(url: url, type: GithubUser?.self)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }

    func get<T: Decodable>(url: URL, type: T.Type) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"

        return URLSession.shared.dataTaskPublisher(for: request)
            .handleEvents(receiveSubscription: { _ in
                Self.log.debug("\(request.httpMethod!) \(request.url!)")
            })
            .map { $0.data }
            .decode(type: type, decoder: gitHubDecoder)
            .eraseToAnyPublisher()
    }
}

struct GithubUser: Decodable {
    let login: String
    let name: String
    let avatarUrl: String
}

struct GithubRepository: Decodable {
    let name: String
    let fullName: String
    let description: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
}
