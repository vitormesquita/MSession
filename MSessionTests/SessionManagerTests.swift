//
//  SessionManagerTests.swift
//  MSessionTests
//
//  Created by Vitor Mesquita on 16/04/19.
//

import XCTest

@testable import MSession

class SessionManagerTests: XCTestCase {
   
   private let manager = SessionManager<User>()
   private let user = User(id: 0, name: "test", email: "user@test.com")

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

   func testCreateSessionFailure() {
      try? manager.createSession(secretKey: nil, user: user)
      XCTAssertNil(manager.session)
      XCTAssertTrue(manager.state == .none)
   }
   
   func testCreateSessionSuccess() {
     try? manager.createSession(secretKey: "secret_key", user: user)
      XCTAssertNotNil(manager.session)
      XCTAssertEqual(manager.secretKey, "secret_key")
      XCTAssertEqual(manager.user?.id, 0)
      XCTAssertEqual(manager.user?.name, "test")
      XCTAssertEqual(manager.user?.email, "user@test.com")
   }
}
