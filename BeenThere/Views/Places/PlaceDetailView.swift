//
//  PlaceDetailView.swift
//  BeenThere
//
//  Created by Egor Iskrenkov on 30/3/24.
//

import SwiftUI

struct PlaceDetailView: View {

    @EnvironmentObject private var router: Router<RootRoute>

    @Environment(\.modelContext) private var modelContext
    @State var deletionConfirmationPresented: Bool = false

    var place: Place

    var body: some View {
        PlaceMap(place: place, spanDelta: 0.5)
            .ignoresSafeArea()
            .navigationTitle(place.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(role: .destructive) {
                    deletionConfirmationPresented = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
            .confirmationDialog(
                "Are you sure you want to delete \(place.name)?",
                isPresented: $deletionConfirmationPresented
            ) {
                Button("Delete \(place.name)", role: .destructive) {
                    modelContext.delete(place)
                    router.navigateBack()
                }
            }
    }

}
