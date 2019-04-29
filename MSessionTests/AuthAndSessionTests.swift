//
//  AuthAndSessionTests.swift
//  MSessionTests
//
//  Created by Vitor Mesquita on 26/04/19.
//

import XCTest
@testable import MSession

class AuthAndSessionTests: XCTestCase {
   
   private static let service = "AuthSessionTestService"
   private let user = User(id: 0, name: "test", email: "user@test.com")
   
   private let auth = AuthManager(service: service)
   private let session = SessionManager<User>(service: service)
   
   override func setUp() {
      session.logout()
   }
   
   func testSaveAccountAndSession() {
      try? auth.saveAccount(account: "user@test.com", password: "secret123")      
      try? session.createSession(secretKey: "token", user: user)
      
      let accounts = try? auth.getSavedAccounts()
      XCTAssertTrue((accounts ?? []).count == 1)
   }
}
