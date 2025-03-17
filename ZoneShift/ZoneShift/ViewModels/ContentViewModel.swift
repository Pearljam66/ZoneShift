//
//  ContentViewModel.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/16/25.
//

import SwiftUI
import SwiftData

class ContentViewModel: ObservableObject {
    @Published var sourceTimeZone: String
    @Published var startTime: Date
    @Published var endTime: Date
    @Published var newTimeZone: String = ""

    var modelContext: ModelContext {
        didSet {
            _savedTimeZones = Query()
        }
    }

    @Query private var savedTimeZones: [SavedTimeZone]
    let allTimeZones = TimeZone.knownTimeZoneIdentifiers.sorted()

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.sourceTimeZone = TimeZone.current.identifier
        self.startTime = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date()) ?? Date() // Default 5:00 PM
        self.endTime = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()) ?? Date() // Default 6:00 PM
        self._savedTimeZones = Query()
    }

    var availableTimeZones: [String] {
        allTimeZones.filter { tz in !savedTimeZones.contains { $0.timeZoneName == tz } }
    }

    var currentTimeZoneDisplay: String {
        let timeZone = TimeZone.current
        let offset = timeZone.secondsFromGMT() / 3600
        let sign = offset >= 0 ? "+" : "-"
        return "\(timeZone.identifier) (UTC\(sign)\(offset))"
    }

    var savedTimeZoneList: [SavedTimeZone] {
        savedTimeZones
    }

    func addTimeZone() {
        if !newTimeZone.isEmpty {
            let newZone = SavedTimeZone(timeZoneName: newTimeZone)
            modelContext.insert(newZone)
            newTimeZone = ""
        }
    }

    func timeRange(for timeZoneId: String) -> (start: Date, end: Date)? {
        guard let sourceTZ = TimeZone(identifier: sourceTimeZone),
              let targetTZ = TimeZone(identifier: timeZoneId) else { return nil }

        let offset = TimeInterval(targetTZ.secondsFromGMT(for: startTime) - sourceTZ.secondsFromGMT(for: startTime))
        let adjustedStart = startTime.addingTimeInterval(offset)
        let adjustedEnd = endTime.addingTimeInterval(offset)

        return (adjustedStart, adjustedEnd)
    }

    func formattedTimeRange(for timeZoneId: String) -> String {
        guard let (start, end) = timeRange(for: timeZoneId) else {
            return "Invalid time zone"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }

}
