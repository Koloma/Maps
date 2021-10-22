//
//  LocationDataObjectRealm.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 11.10.2021.
//

import RealmSwift
import CoreLocation

class LocationRealm: Object {
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var created = NSDate()

    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init()

        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }
}

class PathObject: Object {
    @objc dynamic var name = ""
    @objc dynamic var created = NSDate()
    let path = List<LocationRealm>()
}
