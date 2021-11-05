//
//  OSLogger.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 24.10.2021.
//

import Foundation
import OSLog
import SwiftUI


final class OSLogger {

    static let instance = OSLogger()

    private init() { }

    struct RangeEvents {
        let id: OSSignpostID
        let name: StaticString
    }

    private let pointOfInterest = OSLog(subsystem: Bundle.main.bundleIdentifier!,
                                        category: .pointsOfInterest)


    func start(_ name: StaticString) -> RangeEvents {
        let id = OSSignpostID(log: pointOfInterest)
        os_signpost(.begin, log: pointOfInterest, name: name, signpostID: id)
        return .init(id: id, name: name)
    }

    func end(_ event: RangeEvents) {
        os_signpost(.end, log: pointOfInterest, name: event.name, signpostID: event.id)
    }

    func event(_ name: StaticString) {
        os_signpost(.event, log: pointOfInterest, name: name)
    }
}
