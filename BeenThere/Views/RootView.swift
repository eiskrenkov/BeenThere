//
//  RootView.swift
//  BeenThere
//
//  Created by Egor Iskrenkov on 30/3/24.
//

import SwiftUI
import SwiftData

struct RootView: View {

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @StateObject private var router: Router<RootRoute> = .init()

    var body: some View {
        RoutingView(router: router) {
            if self.horizontalSizeClass == .compact {
                TabBarRootView()
            } else {
                SidebarRootView()
            }
        }
    }

    private struct TabBarRootView: View {

        var body: some View {
            PlacesListView()
        }

    }

    private struct SidebarRootView: View {

        var body: some View {
            NavigationSplitView {
                EmptyView()
                    #if os(macOS)
                    .navigationSplitViewColumnWidth(min: 180, ideal: 200)
                    #endif
            } detail: {
                Text("Select an item")
            }
        }

    }

}

#Preview {
    RootView()
        .modelContainer(for: Place.self, inMemory: true)
}
