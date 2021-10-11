//
//  RealmDataBase.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 11.10.2021.
//

import Foundation
import RealmSwift
import CoreLocation

final public class RealDataBase: DataBaseLocationProtocol{

    private var realm: Realm {
        get {
            do {
                let realm = try Realm()
                return realm
            }
            catch let error as NSError{
                print("Could not access Realm database: ",error.localizedDescription)
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
            print("Could not write to Realm database: ",error.localizedDescription)

        }
    }

    func readPathLocation() -> [CLLocationCoordinate2D] {
        guard let locationPath = realm.objects(Location.self).first else { return [] }
        return [locationPath.coordinate]
    }

    func addPontToPath(coordinate: CLLocationCoordinate2D) {



        let realmLocation = Location(coordinate: coordinate)
        write {
            realm.add(realmLocation)
        }
//        do {
//            try realm.write({
//                realm.add(realmLocation)
//            })
//
//        } catch let error as NSError{
//            print("Could not write to Realm database: ",error.localizedDescription)
//        }

    }

    
}
