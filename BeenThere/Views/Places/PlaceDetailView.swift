//
//  PlaceDetailView.swift
//  BeenThere
//
//  Created by Egor Iskrenkov on 30/3/24.
//

import SwiftUI

struct PlaceDetailView: View {

    var place: Place

    var body: some View {
        PlaceMap(place: place, spanDelta: 0.5)
            .ignoresSafeArea()
            .navigationTitle(place.name)
            .navigationBarTitleDisplayMode(.inline)
    }

}
