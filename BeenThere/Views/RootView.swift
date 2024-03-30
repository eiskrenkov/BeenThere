//
//  RootView.swift
//  BeenThere
//
//  Created by Egor Iskrenkov on 30/3/24.
//

import SwiftUI
import SwiftData

struct RootView: View {

    @StateObject private var router: Router<RootRoute> = .init()

    var body: some View {
        RoutingView(router: router) {
            PlacesListView()
        }
    }

}

#Preview {
    RootView()
        .modelContainer(for: Place.self, inMemory: true)
}
