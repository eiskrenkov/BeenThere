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

    var country: String
    var name: String

    var latitude: Double
    var longitude: Double

    var favorite: Bool

    var createdAt: Date

    init(country: String, name: String, latitude: Double, longtitude: Double, favorite: Bool = false, createdAt: Date) {
        self.country = country
        self.name = name

        self.latitude = latitude
        self.longitude = longtitude

        self.favorite = favorite

        self.createdAt = createdAt
    }

    var coordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }

}
