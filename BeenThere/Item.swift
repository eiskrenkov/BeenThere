//
//  Item.swift
//  BeenThere
//
//  Created by Egor Iskrenkov on 30/3/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
