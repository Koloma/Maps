//
//  UserManager.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 17.10.2021.
//

import Foundation

final class UserManager {

    static let instance = UserManager()

    var isAuthorized: Bool {
        UserDefaults.standard.bool(forKey: "isAuthorized")
    }

    func authorize(username: String, password: String) -> Bool {
        guard username == Constants.username,
              password == Constants.password else {
            return false
        }
        UserDefaults.standard.set(true, forKey: "isAuthorized")
        return true
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: "isAuthorized")
    }

    private init() {}

}

extension UserManager {
    enum Constants {
        static let username = "admin"
        static let password = "123456"
    }
}
