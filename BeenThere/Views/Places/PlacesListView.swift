//
//  PlacesListView.swift
//  BeenThere
//
//  Created by Egor Iskrenkov on 30/3/24.
//

import SwiftUI
import SwiftData

struct PlacesListView: View {

    @EnvironmentObject private var router: Router<RootRoute>

    @Environment(\.modelContext) private var modelContext
    @Query private var places: [Place]

    var body: some View {
        List {
            ForEach(places) { place in
                Button {
                    router.navigate(to: .placeDetailView(place))
                } label: {
                    Text(place.name)
                }
            }
            .onDelete(perform: deleteItems)
        }
        .overlay {
            if places.isEmpty {
                ContentUnavailableView(
                    "You haven't been anywhere yet",
                    systemImage: "airplane",
                    description: Text("Add your first place using plus button at the top right corner")
                )
            }
        }
        .scrollDisabled(places.isEmpty)
        .navigationTitle("Been There")
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            #endif

            ToolbarItem {
                Button {
                    router.navigate(to: .placeForm())
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(places[index])
            }
        }
    }

}
