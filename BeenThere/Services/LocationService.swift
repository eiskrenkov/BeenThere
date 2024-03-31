//
//  LocationService.swift
//  BeenThere
//
//  Created by Egor Iskrenkov on 31/3/24.
//

import MapKit

struct SearchCompletions: Identifiable {

    let id = UUID()
    let title: String
    let subTitle: String

}

struct LocationSearchResult: Identifiable, Hashable {

    let id = UUID()
    let country: String?
    let name: String?
    let coordinate: CLLocationCoordinate2D

    static func == (lhs: LocationSearchResult, rhs: LocationSearchResult) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}

@Observable
class LocationService: NSObject, MKLocalSearchCompleterDelegate {

    private let completer: MKLocalSearchCompleter

    var completions = [SearchCompletions]()

    init(completer: MKLocalSearchCompleter) {
        self.completer = completer
        super.init()
        self.completer.delegate = self
    }

    func update(queryFragment: String) {
        completer.resultTypes = .address
        completer.queryFragment = queryFragment
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completions = completer.results.map { .init(title: $0.title, subTitle: $0.subtitle) }
    }

    func search(with query: String, coordinate: CLLocationCoordinate2D? = nil) async throws -> [LocationSearchResult] {
        let mapKitRequest = MKLocalSearch.Request()
        mapKitRequest.naturalLanguageQuery = query
        mapKitRequest.resultTypes = .address
        if let coordinate {
            mapKitRequest.region = .init(.init(origin: .init(coordinate), size: .init(width: 1, height: 1)))
        }
        let search = MKLocalSearch(request: mapKitRequest)

        let response = try await search.start()

        return response.mapItems.compactMap { mapItem in
            guard let location = mapItem.placemark.location else { return nil }

            return .init(
                country: mapItem.placemark.country,
                name: mapItem.placemark.title,
                coordinate: location.coordinate
            )
        }
    }

}
