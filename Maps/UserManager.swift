//
//  UserManager.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 17.10.2021.
//

import Foundation

final class UserManager {

    static let instance = UserManager()

    private(set) var currentUser: User?
    private var dataBase: DataBaseAuthProtocol = RealDataBase()

    public var isAuthorized: Bool {
        return currentUser != nil
    }

    public func authorize(username: String, password: String) -> Bool {
        guard let user = dataBase.loadUser(login: username) else {
            //"Show message user not found"
            return false
        }
        guard username == user.name,
              password == user.password else {
            return false
        }
        self.currentUser = user
        return true
    }

    public func loadUser(username: String) -> User? {
        return dataBase.loadUser(login: username) 
    }

    public func saveUser(username: String, password: String){
        dataBase.saveUser(user: User(name: username, password: password, created: NSDate()))
    }

    public func logout() {
        currentUser = nil
    }

    private init() {}

}

extension UserManager {
    enum Constants {
        static let rootUsername = "admin"
        static let rootPassword = "123456"
    }
}
