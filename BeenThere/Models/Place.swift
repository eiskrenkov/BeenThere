//
//  Place.swift
//  BeenThere
//
//  Created by Egor Iskrenkov on 30/3/24.
//

import Foundation
import SwiftData

@Model
final class Place {

    @Attribute var name: String
    var createdAt: Date

    init(name: String, createdAt: Date) {
        self.name = name
        self.createdAt = createdAt
    }

}
