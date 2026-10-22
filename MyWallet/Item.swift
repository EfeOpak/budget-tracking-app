//
//  Item.swift
//  MyWallet
//
//  Created by Efe Opak on 20.10.2026.
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
