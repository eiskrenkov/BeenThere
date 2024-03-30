//
//  PlaceForm.swift
//  BeenThere
//
//  Created by Egor Iskrenkov on 30/3/24.
//

import SwiftUI

struct PlaceForm: View {

    enum Field: Int, Hashable {
        case name
    }

    @EnvironmentObject private var router: Router<RootRoute>

    @Environment(\.modelContext) private var modelContext
    @FocusState private var focusedField: Field?

    var place: Place?

    @State private var name: String = ""

    var body: some View {
        Form {
            TextField("Name", text: $name)
                .focused($focusedField, equals: .name)
        }
        .navigationTitle(place == nil ? "New Place" : "Edit Place")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                let newPlace = Place(name: name, createdAt: Date())
                modelContext.insert(newPlace)

                self.router.navigateBack()
            } label: {
                Text("Save")
            }
        }
        .onAppear() {
            self.focusedField = .name

            if let place = place {
                name = place.name
            }
        }
    }

}
