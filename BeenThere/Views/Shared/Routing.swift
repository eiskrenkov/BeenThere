//
//  Routing.swift
//  BeenThere
//
//  Created by Egor Iskrenkov on 28/1/24.
//

import SwiftUI

//
// Proudly stolen from https://github.com/JamesSedlacek/Routing
// Includes fixes and adjustments for our needs
//
public struct RoutingView<RootView: View, Routes: Routable>: View {

    @StateObject var router: Router<Routes>
    @ViewBuilder let rootView: RootView

    public var body: some View {
        NavigationStack(path: self.$router.stack) {
            self.rootView
                .environmentObject(self.router)
                .navigationDestination(for: Router<Routes>.Destination.self) { route in
                    route.body.environmentObject(self.router)
                }
        }
    }

}

/// RoutableObject protocol defines the basic navigation operations for a routable object.
public protocol RoutableObject: ObservableObject {

    associatedtype Destination: Routable

    /// The navigation stack, represented as an array of destinations.
    var stack: [Destination] { get set }

    /// Navigate back in the stack by a specified count.
    func navigateBack(_ count: Int)

    /// Navigate back to a specific destination in the stack.
    func navigateBack(to destination: Destination)

    /// Navigate to the root of the stack by emptying it.
    func navigateToRoot()

    /// Navigate to a specific destination by appending it to the stack.
    func navigate(to destination: Destination)

    /// Navigate to multiple destinations by appending them to the stack.
    func navigate(to destinations: [Destination])

    /// Replace the current stack with new destinations.
    func replace(with destinations: [Destination])

}

extension RoutableObject {

    /// Navigate back in the stack by a specified count
    /// If the count is greater than the stack count, the stack is emptied
    public func navigateBack(_ count: Int = 1) {
        guard count > 0 else { return }

        guard count <= self.stack.count else {
            self.stack = .init()
            return
        }

        self.stack.removeLast(count)
    }

    /// Navigate back to a specific destination in the stack
    /// If the destination exists in the stack, all destinations above it are removed
    public func navigateBack(to destination: Destination) {
        // Check if the destination exists in the stack
        if let index = self.stack.lastIndex(where: { $0 == destination }) {
            // Remove destinations above the specified destination
            self.stack.truncate(to: index)
        } else {
            navigateToRoot()
        }
    }

    /// Navigate to the root of the stack by emptying it
    public func navigateToRoot() {
        self.stack = []
    }

    /// Navigate to a specific destination by appending it to the stack
    public func navigate(to destination: Destination) {
        self.stack.append(destination)
    }

    /// Navigate to multiple destinations by appending them to the stack
    public func navigate(to destinations: [Destination]) {
        for destination in destinations {
            self.stack.append(destination)
        }
    }

    /// Replace the current stack with a new set of destinations
    public func replace(with destinations: [Destination]) {
        self.stack = destinations
    }

}

public protocol Routable: Identifiable, Hashable, Equatable {

    associatedtype Body: View

    var id: Self { get }

    @ViewBuilder @MainActor var body: Body { get }

}

extension Routable {

    public var id: Self { self }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}

public final class Router<Routes: Routable>: RoutableObject {

    public typealias Destination = Routes

    @Published public var stack: [Routes] = []

    public init() {}

}

extension Array {

    /// Truncates the array up to the specified index.
    ///
    /// This method mutates the original array, keeping the elements up to the given index.
    /// If the index is greater than the array's count, the array remains unchanged.
    ///
    /// - Parameter index: The index up to which the array should be truncated.
    ///
    /// Example Usage:
    /// ```
    /// var numbers = [1, 2, 3, 4, 5]
    /// numbers.truncate(to: 2)
    /// // numbers is now [1, 2, 3]
    /// ```
    mutating func truncate(to index: Int) {
        guard index < self.count else {
            return
        }
        self = Array(self[..<Swift.min(index + 1, self.count)])
    }

}
