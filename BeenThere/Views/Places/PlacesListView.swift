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

    @State private var searchQuery: String = ""

    private var searchResults: [Place] {
        if searchQuery.isEmpty {
            return places
        } else {
            return places.filter { $0.name.contains(searchQuery) }
        }
    }

    var body: some View {
        view
            .navigationTitle("Been There")
            .searchable(text: $searchQuery)
            .toolbarBackground(.automatic, for: .navigationBar)
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
            LazyVStack(spacing: 0, pinnedViews: [/*.sectionHeaders*/]) {
                let favoritePlaces = searchResults.filter { $0.favorite }

                if !favoritePlaces.isEmpty {
                    Section(
                        header: SectionHeader(title: "Favorites"),
                        footer: SectionFooter()
                    ) {
                        ForEach(favoritePlaces) { place in
                            PlaceView(place: place)
                                .padding(.horizontal)
                                .padding(.bottom)
                        }
                    }
                }

                ForEach(searchResults.filter { !$0.favorite }) { place in
                    PlaceView(place: place)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
            }
        }
    }

    private struct PlaceView: View {

        @EnvironmentObject private var router: Router<RootRoute>

        var place: Place

        var body: some View {
            Button {
                router.navigate(to: .placeDetailView(place))
            } label: {
                PlaceMap(place: place)
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 13))
            }
        }

    }

    private struct SectionHeader: View {

        var title: String

        var body: some View {
            HStack {
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
        }

    }

    private struct SectionFooter: View {

        var body: some View {
            Divider()
                .padding(.horizontal)
                .padding(.bottom)
        }

    }

}
