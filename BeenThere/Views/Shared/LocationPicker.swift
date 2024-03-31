//
//  LocationPicker.swift
//  BeenThere
//
//  Created by Egor Iskrenkov on 31/3/24.
//

import SwiftUI
import MapKit

struct LocationPicker: View {

    @Environment(\.dismiss) private var dismiss

    @State private var position = MapCameraPosition.automatic
    @State private var isSheetPresented: Bool = true
    @State private var searchResults = [LocationSearchResult]()

    @State private var searchResult: LocationSearchResult?
    @Binding var selectedLocation: LocationSearchResult?

    var body: some View {
        Map(position: $position, selection: $searchResult) {
            ForEach(searchResults) { result in
                Marker(coordinate: result.coordinate) {
                    Image(systemName: "mappin")
                }
                .tag(result)
            }
        }
        .ignoresSafeArea()
        .safeAreaInset(edge: .bottom) {
            Button("Save") {
                if let searchResult = searchResult {
                    selectedLocation = searchResult
                }

                dismiss()
            }
            .disabled(searchResult == nil)
        }
        .safeAreaInset(edge: .top) {
            HStack {
                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "multiply")
                        .foregroundStyle(.gray)
                        .padding(10)
                        .background(.thickMaterial)
                        .clipShape(Circle())
                }
                .padding()
            }
        }
        .onChange(of: searchResult) {
            isSheetPresented = searchResult == nil
        }
        .onChange(of: searchResults) {
            if let firstResult = searchResults.first, searchResults.count == 1 {
                searchResult = firstResult
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            SheetView(searchResults: $searchResults)
        }
    }

    struct SheetView: View {

        @State private var locationService = LocationService(completer: .init())
        @State private var search: String = ""
        @Binding var searchResults: [LocationSearchResult]

        var body: some View {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray.opacity(0.9))

                    TextField("Search for a place", text: $search)
                        .autocorrectionDisabled()
                        .onSubmit {
                            Task {
                                searchResults = (try? await locationService.search(with: search)) ?? []
                            }
                        }
                }
                .modifier(TextFieldGrayBackgroundColor())

                Spacer()

                List {
                    ForEach(locationService.completions) { completion in
                        Button(action: { didTapOnCompletion(completion) }) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(completion.title)
                                    .font(.headline)
                                    .fontDesign(.rounded)
                                Text(completion.subTitle)
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .onChange(of: search) {
                locationService.update(queryFragment: search)
            }
            .padding()
            .interactiveDismissDisabled()
            .presentationDetents([.height(85), .large])
            .presentationBackground(.regularMaterial)
            .presentationBackgroundInteraction(.enabled(upThrough: .large))
        }

        private func didTapOnCompletion(_ completion: SearchCompletions) {
            Task {
                if let singleLocation = try? await locationService.search(with: "\(completion.title) \(completion.subTitle)").first {
                    searchResults = [singleLocation]
                }
            }
        }

    }

    struct TextFieldGrayBackgroundColor: ViewModifier {

        func body(content: Content) -> some View {
            content
                .padding(12)
                .background(.gray.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(.primary)
        }

    }

}
