//
//  Utils.swift
//  MSession
//
//  Created by Vitor Mesquita on 15/07/2018.
//

import UIKit

public typealias MUser = NSObject & NSCoding

// MARK: - Enuns

public enum SessionState: Equatable {
    case none
    case expired
    case runnig(Session)
}

public enum SessionDataStoreError: Error {
    case noSessionToUpdate
    case errorToCreateSession
}

// MARK: - Protocols

public protocol SessionDataStoreProtocol {
    func getSession() -> Session?
    func createSession(accessToken: String?, user: MUser?) throws -> Session
    func updateSession(accessToken: String?, user: MUser?) throws -> Session
    func deleteSession()
}

public protocol SessionManagerDelegate: class {
    
    func sessionStateDidChange(_ state: SessionState)
}
