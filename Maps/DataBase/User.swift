//
//  User.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 17.10.2021.
//

import Foundation

final public class User: NSObject {

    public let name: String
    public let password: String
    public let created: NSDate

    public init(name: String, password: String, created: NSDate) {

        self.name = name
        self.password = password
        self.created = created
    }
}

extension User{
    func toRealm() -> UserObjectRealm{
        return UserObjectRealm(name: self.name, password: self.password)
    }

}
