//
//  GithubServiceTests.swift
//  Dev SearchTests
//
//  Created by Matt Burke on 1/25/21.
//

import XCTest
@testable import Dev_Search

class GithubServiceTests: XCTestCase {

    func testGithubLoadUser() {
        let expectation = self.expectation(description: "loading user")
        let subject = GithubService()

        let user$ = subject.getUser(username: "octocat")

        var user: GithubUser?
        let token = user$.sink {
            user = $0
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
        token.cancel();
        XCTAssertEqual("octocat", user!.login)
        XCTAssertEqual("The Octocat", user!.name)
        XCTAssertEqual("https://avatars.githubusercontent.com/u/583231?v=4", user!.avatarUrl)
    }

    func testGithubLoadUser_notFound_nil() {
        let expectation = self.expectation(description: "loading user")
        let subject = GithubService()

        let user$ = subject.getUser(username: "jfsdlkfujsdlfjlx")

        var user: GithubUser?
        let token = user$.sink {
            user = $0
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
        token.cancel();
        XCTAssertNil(user)
    }

}
