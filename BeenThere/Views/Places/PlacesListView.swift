//
//  PlacesListView.swift
//  BeenThere
//
//  Created by Egor Iskrenkov on 30/3/24.
//

import SwiftUI
import SwiftData
import MapKit

struct PlacesListView: View {

    @EnvironmentObject private var router: Router<RootRoute>

    @Environment(\.modelContext) private var modelContext
    @Query private var places: [Place]

    var body: some View {
        view
            .navigationTitle("Been There")
            .toolbar {
                ToolbarItem {
                    Button {
                        router.navigate(to: .placeForm())
                    } label: {
                        Label("Add Place", systemImage: "plus")
                    }
                }
            }
    }

    @ViewBuilder
    private var view: some View {
        if places.isEmpty {
            emptyState
        } else {
            list
        }
    }

    @ViewBuilder
    private var emptyState: some View {
        ContentUnavailableView(
            "You haven't been anywhere yet",
            systemImage: "airplane",
            description: Text("Add your first place using plus button at the top right corner")
        )
    }

    @ViewBuilder 
    private var list: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(places) { place in
                    Button {
                        router.navigate(to: .placeDetailView(place))
                    } label: {
                        PlaceMap(place: place)
                            .frame(height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 13))
                    }
                }
            }
            .padding()
        }
    }

}
