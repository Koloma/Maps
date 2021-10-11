//
//  DataBaseLocationProtocol.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 11.10.2021.
//

import Foundation
import CoreLocation

protocol DataBaseLocationProtocol{

    func readPathLocation() -> [CLLocationCoordinate2D]
    func addPontToPath(coordinate: CLLocationCoordinate2D)
}
