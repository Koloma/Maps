//
//  DataBaseAuthProtocol.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 17.10.2021.
//

import Foundation

protocol DataBaseAuthProtocol{

    func loadUser(login: String) -> User?
    func saveUser(user: User)
    func deleteUser(login: String)

}
