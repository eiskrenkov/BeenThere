//
//  PlaceForm.swift
//  BeenThere
//
//  Created by Egor Iskrenkov on 30/3/24.
//

import SwiftUI
import MapKit

struct PlaceForm: View {

    enum Field: Int, Hashable {
        case country
        case name
    }

    @EnvironmentObject private var router: Router<RootRoute>

    @Environment(\.modelContext) private var modelContext
    @FocusState private var focusedField: Field?

    var place: Place?

    @State private var country: String = ""
    @State private var name: String = ""
    @State private var selectedLocation: LocationSearchResult?

    @State private var locationPickerPresented: Bool = false

    var body: some View {
        HStack {
            Form {
                Section("Location") {
                    TextField("Country", text: $country)
                        .focused($focusedField, equals: .country)

                    TextField("Name", text: $name)
                        .focused($focusedField, equals: .name)

                    Button {
                        locationPickerPresented = true
                    } label: {
                        Group {
                            if let selectedLocation = selectedLocation {
                                let newPlace = buildNewPlace(selectedLocation)

                                PlaceMap(place: newPlace)
                            } else {
                                Map()
                            }
                        }
                        .frame(height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                    }
                }
            }
        }
        .navigationTitle(place == nil ? "New Place" : "Edit Place")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                if let selectedLocation = selectedLocation {
                    let newPlace = buildNewPlace(selectedLocation)
                    modelContext.insert(newPlace)

                    router.navigateBack()
                }
            } label: {
                Text("Save")
            }
            .disabled(!isValid)
        }
        .onChange(of: selectedLocation) {
            if let selectedLocation = selectedLocation,
                let selectedCountry = selectedLocation.country,
                let selectedName = selectedLocation.name {

                if country.isEmpty {
                    country = selectedCountry
                }

                if name.isEmpty {
                    name = selectedName
                }
            }
        }
        .onAppear() {
            focusedField = .country

            if let place = place {
                name = place.name
            }
        }
        .sheet(isPresented: $locationPickerPresented) {
            LocationPicker(selectedLocation: $selectedLocation)
        }
    }

    private var isValid: Bool {
        !country.isEmpty && !name.isEmpty && selectedLocation != nil
    }

    private func buildNewPlace(_ selectedLocation: LocationSearchResult) -> Place {
        Place(
            country: country,
            name: name,
            latitude: selectedLocation.coordinate.latitude,
            longtitude: selectedLocation.coordinate.longitude,
            createdAt: Date()
        )
    }

}
