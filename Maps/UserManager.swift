//
//  UserManager.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 17.10.2021.
//

import Foundation

final class UserManager {

    static let instance = UserManager()

    private(set) var user: User?
    private var dataBase: DataBaseAuthProtocol = RealDataBase()

    var isAuthorized: Bool {
        return user != nil
    }

    func authorize(username: String, password: String) -> Bool {
        guard let user = dataBase.loadUser(login: username) else {
            //"Show message user not found"
            return false
        }
        guard username == user.name,
              password == user.password else {
            return false
        }
        self.user = user
        return true
    }

    func saveUser(username: String, password: String){
        dataBase.saveUser(user: User(name: username, password: password, created: NSDate()))
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
