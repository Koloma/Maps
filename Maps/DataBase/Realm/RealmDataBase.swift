//
//  RealmDataBase.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 11.10.2021.
//

import Foundation
import RealmSwift
import CoreLocation

final public class RealDataBase: DataBaseLocationProtocol {

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

            let objects = realm.objects(Location.self)

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
        let locationPath = realm.objects(Location.self)
        var arr:[CLLocationCoordinate2D] = []
        for loc in locationPath {
            arr.append(loc.coordinate)
        }
        return arr
    }

    func addPoint(path name: String,  coordinate: CLLocationCoordinate2D) {

        let realmLocation = Location(coordinate: coordinate)
        write {
            realm.add(realmLocation)
        }

    }

    
}
