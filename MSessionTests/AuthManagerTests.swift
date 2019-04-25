//
//  AuthManagerTests.swift
//  MSessionTests
//
//  Created by Vitor Mesquita on 24/04/19.
//

import XCTest
@testable import MSession

class AuthManagerTests: XCTestCase {
   
   let authManager = AuthManager(serviceName: "test_service_group")
   
   override func setUp() {
      authManager.deleteAllAccounts()
   }
   
   func testSavePassword() {
      XCTAssertNoThrow(try authManager.saveAccount(account: "test_account", password: "password"))
      
      let accounts = try? authManager.getSavedAccounts()
      XCTAssertNotNil(accounts)
      XCTAssertFalse((accounts ?? []).isEmpty)
      
      let lastAccount = accounts?.first
      XCTAssertEqual(lastAccount?.account, "test_account")
      XCTAssertEqual(lastAccount?.password, "password")
   }
   
   func testSavePasswordBlank() {
      XCTAssertThrowsError(try authManager.saveAccount(account: "test_account", password: ""))
   }
   
   func testSaveAccountBlank() {
      XCTAssertThrowsError(try authManager.saveAccount(account: "", password: "password"))
   }
   
   func testSaveAccountAndDeleteOthers() {
      XCTAssertNoThrow(try authManager.saveAccount(account: "test_account", password: "password"))
      XCTAssertNoThrow(try authManager.saveAccount(account: "test_account1", password: "password"))
      XCTAssertNoThrow(try authManager.saveAccount(account: "test_account2", password: "password"))
      XCTAssertNoThrow(try authManager.saveAccount(account: "test_account3", password: "password"))
      
      var accounts = try? authManager.getSavedAccounts()
      XCTAssertTrue((accounts ?? []).count == 4)
      
      XCTAssertNoThrow(try authManager.saveAccount(account: "test_account_delete_others", password: "1234", deleteOthers: true))
      accounts = try? authManager.getSavedAccounts()
      XCTAssertTrue((accounts ?? []).count == 1)
      
      let lastAccount = accounts?.last
      XCTAssertEqual(lastAccount?.account, "test_account_delete_others")
      XCTAssertEqual(lastAccount?.password, "1234")
   }
   
   func testRenameAccount() {
      XCTAssertNoThrow(try authManager.saveAccount(account: "test_account", password: "1234"))
      XCTAssertNoThrow(try authManager.renameAccount("test_account", newAccount: "test_account_2"))
      
      let accounts = try? authManager.getSavedAccounts()
      let lastAccount = accounts?.last
      XCTAssertEqual(lastAccount?.account, "test_account_2")
      XCTAssertEqual(lastAccount?.password, "1234")
   }
}
