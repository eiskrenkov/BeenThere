//
//  Place.swift
//  BeenThere
//
//  Created by Egor Iskrenkov on 30/3/24.
//

import Foundation
import SwiftData
import MapKit

@Model
final class Place {

    @Attribute var name: String
    var createdAt: Date
    var latitude: Double = 41.9
    var longitude: Double = 12.5

    init(name: String, createdAt: Date) {
        self.name = name
        self.createdAt = createdAt
    }

    var coordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }

}
