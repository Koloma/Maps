//
//  User.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 17.10.2021.
//

import Foundation

final public class User: NSObject {

    public let login: String
    public let password: String
    public let created: NSDate

    public init(login: String, password: String, created: NSDate) {

        self.login = login
        self.password = password
        self.created = created
    }
}

extension User{
    func toRealm() -> UserObjectRealm{
        return UserObjectRealm(login: self.login, password: self.password)
    }

}
