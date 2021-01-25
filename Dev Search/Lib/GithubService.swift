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
    let gitHubDecoder = JSONDecoder()
    static let log = Logger(subsystem: "GithubService", category: "networking")

    init () {
        gitHubDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func getUser(username: String) -> AnyPublisher<GithubUser?, Never> {
        var request = URLRequest(url: URL(string: "https://api.github.com/users/\(username)")!)
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"


        return URLSession.shared.dataTaskPublisher(for: request)
            .handleEvents(receiveSubscription: { _ in
                GithubService.log.debug("\(request.httpMethod!) \(request.url!)")
            })
            .map { $0.data }
            .handleEvents(receiveOutput: { data in print(data) })
            .decode(type: GithubUser?.self, decoder: gitHubDecoder)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

struct GithubUser: Decodable {
    let login: String
    let name: String
    let avatarUrl: String
}
