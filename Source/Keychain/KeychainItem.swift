/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A struct for accessing generic password keychain items.
 
 https://developer.apple.com/library/archive/samplecode/GenericKeychain/Introduction/Intro.html#//apple_ref/doc/uid/DTS40007797-Intro-DontLinkElementID_2
 */

import Foundation

struct KeychainItem {
   
   let service: String
   let accessGroup: String?
   
   private(set) var account: String
   
   init(service: String, account: String, accessGroup: String? = nil) {
      self.service = service
      self.account = account
      self.accessGroup = accessGroup
   }
}

extension KeychainItem {
   
   func set(data: Data) throws {
      let status: OSStatus
      
      do {
         try _ = getData()
         
         var attributesToUpdate = [String: AnyObject]()
         attributesToUpdate[kSecValueData as String] = data as AnyObject?
         
         let query = Keychain.query(withService: service, account: account, accessGroup: accessGroup)
         status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
         
      } catch Keychain.Error.noItemFound {
         var newItem = Keychain.query(withService: service, account: account, accessGroup: accessGroup)
         newItem[kSecValueData as String] = data as AnyObject?
         
         status = SecItemAdd(newItem as CFDictionary, nil)
      }
      
      guard status == noErr else {
         throw Keychain.Error.unhandledError(status: status)
      }
   }
   
   func getData() throws -> Data {
      var query = Keychain.query(withService: service, account: account, accessGroup: accessGroup)
      query[kSecReturnData as String] = kCFBooleanTrue
      query[kSecMatchLimit as String] = kSecMatchLimitOne
      query[kSecReturnAttributes as String] = kCFBooleanTrue
      
      var queryResult: AnyObject?
      let status = withUnsafeMutablePointer(to: &queryResult) {
         SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
      }
      
      guard status == noErr else {
         throw status == errSecItemNotFound ? Keychain.Error.noItemFound : Keychain.Error.unhandledError(status: status)
      }
      
      guard  let items = queryResult as? [String: AnyObject],
         let data = items[kSecValueData as String] as? Data else {
            throw Keychain.Error.unexpectedItemData
      }
      
      return data
   }
   
   func set(string: String) throws {
      let encodedString = string.data(using: String.Encoding.utf8)!
      try set(data: encodedString)
   }
   
   func getString() throws -> String {
      let data = try getData()
      
      guard let string = String(data: data, encoding: String.Encoding.utf8) else {
         throw Keychain.Error.unexpectedStringData
      }
      
      return string
   }
}

extension KeychainItem {
   
   mutating func renameAccount(_ newAccountName: String) throws {
      var attributesToUpdate = [String : AnyObject]()
      attributesToUpdate[kSecAttrAccount as String] = newAccountName as AnyObject?
      
      let query = Keychain.query(withService: service, account: self.account, accessGroup: accessGroup)
      let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
      
      guard status == noErr || status == errSecItemNotFound else {
         throw Keychain.Error.unhandledError(status: status)
      }
      
      self.account = newAccountName
   }
   
   func deleteItem() throws {
      let query = Keychain.query(withService: service, account: account, accessGroup: accessGroup)
      let status = SecItemDelete(query as CFDictionary)
      
      guard status == noErr || status == errSecItemNotFound else { throw Keychain.Error.unhandledError(status: status) }
   }
}
