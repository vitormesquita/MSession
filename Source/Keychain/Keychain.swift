//
//  Keychain.swift
//  MSession
//
//  Created by Vitor Mesquita on 26/04/19.
//

import Foundation

struct Keychain {
   
   public enum Error: Swift.Error {
      case noItemFound
      case unexpectedStringData
      case unexpectedItemData
      case unhandledError(status: OSStatus)
   }
   
   private let service: String
   private let accessGroup: String?
   
   init(service: String, accessGroup: String? = nil) {
      self.service = service
      self.accessGroup = accessGroup
   }
   
   func getItemBy(account: String) -> KeychainItem? {
      let items = try? self.items()
      return items?.first(where: { $0.account == account })
   }
   
   func getOrCreateItemBy(account: String) -> KeychainItem {
      let items = try? self.items()
      let firstItem = items?.first(where: { $0.account == account })
      
      return firstItem ?? KeychainItem(service: service, account: account)
   }
   
   func items() throws -> [KeychainItem] {
      var query = Keychain.query(withService: service, accessGroup: accessGroup)
      query[kSecReturnData as String] = kCFBooleanFalse
      query[kSecMatchLimit as String] = kSecMatchLimitAll
      query[kSecReturnAttributes as String] = kCFBooleanTrue
      
      var queryResult: AnyObject?
      let status = withUnsafeMutablePointer(to: &queryResult) {
         SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
      }
      
      guard status != errSecItemNotFound else { return [] }
      guard status == noErr else { throw Keychain.Error.unhandledError(status: status) }
      
      guard let resultData = queryResult as? [[String : AnyObject]] else { throw Keychain.Error.unexpectedItemData }
      
      var passwordItems = [KeychainItem]()
      
      for result in resultData {
         guard let account  = result[kSecAttrAccount as String] as? String else {
            continue
         }
         
         let passwordItem = KeychainItem(service: service, account: account, accessGroup: accessGroup)
         passwordItems.append(passwordItem)
      }
      
      return passwordItems
   }
}

extension Keychain {
   
   static func query(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
      var query = [String : AnyObject]()
      
      query[kSecClass as String] = kSecClassGenericPassword
      query[kSecAttrService as String] = service as AnyObject?
      
      if let account = account {
         query[kSecAttrAccount as String] = account as AnyObject?
      }
      
      if let accessGroup = accessGroup {
         query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
      }
      
      return query
   }
}
