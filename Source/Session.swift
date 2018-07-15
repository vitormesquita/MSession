//
//  Session.swift
//  MSession
//
//  Created by Vitor Mesquita on 03/07/2018.
//

import UIKit

public class Session: NSObject, NSCoding {
    
    private(set) var accessToken: String
    private(set) var user: MUser
    
    init(accessToken: String, user: MUser) {
        self.accessToken = accessToken
        self.user = user
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        if let accessToken = aDecoder.decodeObject(forKey: "msession_accessToken") as? String,
            let user = aDecoder.decodeObject(forKey: "msession_user") as? MUser {
            self.init(accessToken: accessToken, user: user)
        } else {
            return nil
        }
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(accessToken, forKey: "msession_accessToken")
        aCoder.encode(user, forKey: "msession_user")
    }
}
