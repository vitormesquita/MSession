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
      manager.logout()
   }
   
   func testCreateSessionFailure() {
      try? manager.createSession(secretKey: nil, user: user)
      XCTAssertNil(manager.session)
      XCTAssertEqual(manager.state, .none)
   }
   
   func testCreateSessionSuccess() {
      try? manager.createSession(secretKey: "secret_key", user: user)
      XCTAssertNotNil(manager.session)
      XCTAssertEqual(manager.secretKey, "secret_key")
      XCTAssertEqual(manager.user?.id, 0)
      XCTAssertEqual(manager.user?.name, "test")
      XCTAssertEqual(manager.user?.email, "user@test.com")
      XCTAssertEqual(manager.state, .running)
   }
   
   func testUpdateSecretKeySession() {
      try? manager.createSession(secretKey: "secret_key", user: user)
      
      try? manager.updateSession(secretKey: "another_secret_key")
      
      XCTAssertNotNil(manager.session)
      XCTAssertEqual(manager.secretKey, "another_secret_key")
      XCTAssertEqual(manager.state, .running)
   }
   
   func testUpdateUserSession() {
      try? manager.createSession(secretKey: "secret_key", user: user)
      
      try? manager.updateSession(user: User(id: 1, name: "test1", email: "user1@test.com"))
      
      XCTAssertNotNil(manager.session)
      XCTAssertEqual(manager.user?.id, 1)
      XCTAssertEqual(manager.user?.name, "test1")
      XCTAssertEqual(manager.user?.email, "user1@test.com")
      XCTAssertEqual(manager.state, .running)
   }
   
   func testUpdateSessionWithoutSession() {
      XCTAssertThrowsError(try manager.updateSession(secretKey: "secret_key", user: user))
      XCTAssertTrue(manager.state == .none)
   }
   
   func testExpireSession() {
      try? manager.createSession(secretKey: "secret_key", user: user)
      manager.expireSession()
      
      XCTAssertNil(manager.session)
      XCTAssertEqual(manager.state, .expired)
   }
   
   func testLogoutSession() {
      try? manager.createSession(secretKey: "secret_key", user: user)
      manager.logout()
      
      XCTAssertNil(manager.session)
      XCTAssertEqual(manager.state, .none)
   }
}
