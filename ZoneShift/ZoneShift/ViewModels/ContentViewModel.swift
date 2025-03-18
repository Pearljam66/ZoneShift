//
//  ContentViewModel.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/16/25.
//

import SwiftData
import SwiftUI

@Observable final class ContentViewModel {
    var sourceTimeZone: String = TimeZone.current.identifier
    var startTime: Date
    var endTime: Date
    var newTimeZone: String = ""
    var modelContext: ModelContext
    var savedTimeZones: [SavedTimeZone] = []

    let allTimeZones = TimeZone.knownTimeZoneIdentifiers.sorted()

    var savedTimeZoneList: [SavedTimeZone] {
        savedTimeZones
    }

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.startTime = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date()) ?? Date() // Default 5:00 PM
        self.endTime = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()) ?? Date() // Default 6:00 PM
        refreshSavedTimeZones()
    }

    func updateModelContext(_ newContext: ModelContext) {
        self.modelContext = newContext
        refreshSavedTimeZones()
    }

    func refreshSavedTimeZones() {
        let descriptor = FetchDescriptor<SavedTimeZone>(sortBy: [SortDescriptor(\.timeZoneName)])
        do {
            savedTimeZones = try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching saved time zones: \(error)")
            savedTimeZones = []
        }
    }

    var availableTimeZones: [String] {
        allTimeZones.filter { timezone in !savedTimeZones.contains { $0.timeZoneName == timezone } && timezone != sourceTimeZone }
    }

    func setSourceTimeZone(_ timeZone: String) {
        sourceTimeZone = timeZone
        refreshSavedTimeZones()
    }

    func addTimeZone() {
        if !newTimeZone.isEmpty && !savedTimeZones.contains(where: { $0.timeZoneName == newTimeZone }) {
            let newZone = SavedTimeZone(timeZoneName: newTimeZone)
            modelContext.insert(newZone)
            newTimeZone = ""
            refreshSavedTimeZones()
        }
    }

    func deleteTimeZone(_ timeZone: SavedTimeZone) {
        modelContext.delete(timeZone)
        refreshSavedTimeZones()
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

    func startHour(for timeZoneId: String) -> Int? {
        guard let (start, _) = timeRange(for: timeZoneId) else { return nil }
        return Calendar.current.component(.hour, from: start)
    }

    func endHour(for timeZoneId: String) -> Int? {
        guard let (_, end) = timeRange(for: timeZoneId) else { return nil }
        return Calendar.current.component(.hour, from: end)
    }

}
