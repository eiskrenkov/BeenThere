//
//  RootRoute.swift
//  BeenThere
//
//  Created by Egor Iskrenkov on 30/3/24.
//

import SwiftUI

enum RootRoute: Routable {

    case placeForm(Place? = nil)
    case placeDetailView(Place)

    var body: some View {
        switch self {
        case .placeForm(let place):
            PlaceForm(place: place)
        case .placeDetailView(let place):
            PlaceDetailView(place: place)
        }
    }

}
