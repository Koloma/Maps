//
//  RealmDataBase.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 11.10.2021.
//

import Foundation
import RealmSwift
import CoreLocation

final public class RealDataBase: DataBaseLocationProtocol, DataBaseAuthProtocol {

    func loadUser(login: String) -> User? {
        guard let userRealm = realm.object(ofType: UserObjectRealm.self, forPrimaryKey: login)
        else { return nil}

        return userRealm.toUser()
    }

    func saveUser(user: User) {

        do {

            guard let userRealm = realm.object(ofType: UserObjectRealm.self, forPrimaryKey: user.login)
            else {
                try realm.write {
                    realm.add(user.toRealm())
                }
                return
            }
            userRealm.password = user.password
            try realm.write {
                realm.add(userRealm, update: .modified)
            }

        } catch let error as NSError {
            print("Could not SaveUser to Realm database: ", error.localizedDescription)
        }

    }

    func deleteUser(login: String) {
        do {

            let objects = realm.objects(UserObjectRealm.self)

            try realm.write {
                realm.delete(objects)
            }
        } catch let error as NSError {
            print("Could not delete object from Realm database: ", error.localizedDescription)
        }
    }


    let defaultPathName: String = "default"

    private var realm: Realm {
        get {
            do {
                let realm = try Realm()
                return realm
            }
            catch let error as NSError{
                print("Could not access Realm database: ", error.localizedDescription)
            }
            return self.realm
        }
    }

    private func write(writeClosure: () -> ()) {
        do {
            try realm.write {
                writeClosure()
            }
        } catch let error as NSError {
            print("Could not write to Realm database: ", error.localizedDescription)
        }
    }

    func deletePath(name: String) {
        do {

            let objects = realm.objects(LocationRealm.self)

            try realm.write {
                realm.delete(objects)
            }
        } catch let error as NSError {
            print("Could not delete object from Realm database: ", error.localizedDescription)
        }
    }

    func savePath(name: String, path: [CLLocationCoordinate2D]) {

        for location in path {
            self.addPoint(path: name, coordinate: location)
        }
    }

    func loadPath(name: String) -> [CLLocationCoordinate2D] {
        let locationPath = realm.objects(LocationRealm.self)
        var arr:[CLLocationCoordinate2D] = []
        for loc in locationPath {
            arr.append(loc.coordinate)
        }
        return arr
    }

    func addPoint(path name: String,  coordinate: CLLocationCoordinate2D) {

        let realmLocation = LocationRealm(coordinate: coordinate)
        write {
            realm.add(realmLocation)
        }

    }

    
}
