//
//  Item.swift
//  pacemaker
//
//  Created by Lanakee on 3/20/26.
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
