//
//  ContentViewModel.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/16/25.
//

import SwiftUI
import SwiftData

final class ContentViewModel: ObservableObject {
    @Published var sourceTimeZone: String
    @Published var newTimeZone: String = ""
    @Published var selectedDate: Date

    var modelContext: ModelContext {
        didSet {
            _savedTimeZones = Query() // Re-initialize Query when context changes
        }
    }

    @Query private var savedTimeZones: [SavedTimeZone]
    let allTimeZones = TimeZone.knownTimeZoneIdentifiers.sorted()

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.sourceTimeZone = TimeZone.current.identifier
        self.selectedDate = Date()
        self._savedTimeZones = Query()
    }

    var availableTimeZones: [String] {
        allTimeZones.filter { tz in !savedTimeZones.contains { $0.timeZoneName == tz } }
    }

    func addTimeZone() {
        if !newTimeZone.isEmpty {
            let newZone = SavedTimeZone(timeZoneName: newTimeZone)
            modelContext.insert(newZone)
            newTimeZone = ""
        }
    }

    var savedTimeZoneList: [SavedTimeZone] {
        savedTimeZones
    }

}
