//
//  DataBaseLocationProtocol.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 11.10.2021.
//

import Foundation
import CoreLocation

protocol DataBaseLocationProtocol{

    var defaultPathName: String { get }

    func loadPath(name: String) -> [CLLocationCoordinate2D]
    func savePath(name: String, path: [CLLocationCoordinate2D])
    func deletePath(name: String)

    func addPoint(path name: String, coordinate: CLLocationCoordinate2D)

}
