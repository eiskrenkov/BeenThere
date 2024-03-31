//
//  PlaceMap.swift
//  BeenThere
//
//  Created by Egor Iskrenkov on 31/3/24.
//

import SwiftUI
import MapKit

struct PlaceMap: View {

    var place: Place
    var spanDelta: CLLocationDegrees = 5

    var body: some View {
        Map(
            initialPosition: .region(
                MKCoordinateRegion(
                    center: place.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta)
                )
            )
        ) {
            Marker(
                place.name,
                coordinate: CLLocationCoordinate2D(
                    latitude: place.latitude,
                    longitude: place.longitude)
            )
//                                .tint(.orange)
        }
    }

}
