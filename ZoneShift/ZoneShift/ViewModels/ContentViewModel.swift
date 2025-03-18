//
//  ContentViewModel.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/16/25.
//

import SwiftData
import SwiftUI

@Observable final class ContentViewModel {
    var sourceTimeZone: String
    var startTime: Date
    var endTime: Date
    var newTimeZone: String = ""

    var modelContext: ModelContext
    var savedTimeZones: [SavedTimeZone] = []

    let allTimeZones = TimeZone.knownTimeZoneIdentifiers.sorted()

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.sourceTimeZone = TimeZone.current.identifier
        self.startTime = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date()) ?? Date() // Default 5:00 PM
        self.endTime = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()) ?? Date() // Default 6:00 PM

        // Insert initial time zones: user's current and London
        let currentTimeZone = TimeZone.current.identifier
        let initialTimeZones = [currentTimeZone, "Europe/London"]

        // Check if these time zones are already in the saved list to avoid duplicates
        let descriptor = FetchDescriptor<SavedTimeZone>()
        let existingZones = (try? modelContext.fetch(descriptor)) ?? []
        let existingNames = existingZones.map { $0.timeZoneName }

        for timeZone in initialTimeZones {
            if !existingNames.contains(timeZone) {
                let newZone = SavedTimeZone(timeZoneName: timeZone)
                modelContext.insert(newZone)
            }
        }

        refreshSavedTimeZones() // Initial fetch
    }

    func updateModelContext(_ newContext: ModelContext) {
        self.modelContext = newContext
        refreshSavedTimeZones()
    }

    private func refreshSavedTimeZones() {
        let descriptor = FetchDescriptor<SavedTimeZone>(sortBy: [SortDescriptor(\.timeZoneName)])
        do {
            self.savedTimeZones = try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching saved time zones: \(error)")
            self.savedTimeZones = []
        }
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
            refreshSavedTimeZones()
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

    func deleteTimeZone(_ timeZone: SavedTimeZone) {
        do {
            modelContext.delete(timeZone)
            refreshSavedTimeZones()
        } catch {
            print("Error deleting time zone: \(error)")
        }
    }

    // For testing purposes
    func deleteAllSavedTimeZones() {
        do {
            let descriptor = FetchDescriptor<SavedTimeZone>(sortBy: [SortDescriptor(\.timeZoneName)])
            let allZones = try modelContext.fetch(descriptor)

            // Optionally, preserve initial time zones (e.g., current and London)
            let initialTimeZones = [TimeZone.current.identifier, "Europe/London"]
            let zonesToDelete = allZones.filter { !initialTimeZones.contains($0.timeZoneName) }

            for zone in zonesToDelete {
                modelContext.delete(zone)
            }

            refreshSavedTimeZones()
        } catch {
            print("Error deleting saved time zones: \(error)")
        }
    }

}
