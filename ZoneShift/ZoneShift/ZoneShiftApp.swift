//
//  ZoneShiftApp.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/16/25.
//

import SwiftUI
import SwiftData

@main
struct ZoneShiftApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: SavedTimeZone.self)
    }
}
