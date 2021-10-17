//
//  UserObjectRealm.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 17.10.2021.
//

import RealmSwift

class UserObjectRealm: Object {
    @objc dynamic var login = ""
    @objc dynamic var password = ""
    @objc dynamic var created = NSDate()


    override class func primaryKey() -> String? {
        return "login"
    }

    convenience init(login: String, password: String) {
        self.init()

        self.login = login
        self.password = password
    }

}

extension UserObjectRealm{

    func toUser() -> User{
        return User(login: self.login, password: self.password, created: self.created)
    }

}
