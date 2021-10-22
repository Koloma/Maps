//
//  UserObjectRealm.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 17.10.2021.
//

import RealmSwift

class UserObjectRealm: Object {
    @objc dynamic var name = ""
    @objc dynamic var password = ""
    @objc dynamic var created = NSDate()


    override class func primaryKey() -> String? {
        return "name"
    }

    convenience init(name: String, password: String) {
        self.init()

        self.name = name
        self.password = password
    }

}

extension UserObjectRealm{

    func toUser() -> User{
        return User(name: self.name, password: self.password, created: self.created)
    }

}
