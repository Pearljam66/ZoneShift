//
//  TimeZoneRowViewModel.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/16/25.
//

import Foundation

@Observable final class TimeZoneRowViewModel {
    let sourceTimeZone: String
    let targetTimeZone: String
    let date: Date

    init(sourceTimeZone: String, targetTimeZone: String, date: Date) {
        self.sourceTimeZone = sourceTimeZone
        self.targetTimeZone = targetTimeZone
        self.date = date
    }

    var convertedTimeString: String {
        guard let sourceTZ = TimeZone(identifier: sourceTimeZone),
              let targetTZ = TimeZone(identifier: targetTimeZone) else {
            return "Invalid time zone: \(targetTimeZone)"
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.timeZone = targetTZ

        let offset = TimeInterval(targetTZ.secondsFromGMT(for: date) - sourceTZ.secondsFromGMT(for: date))
        let convertedDate = date.addingTimeInterval(offset)

        return formatter.string(from: convertedDate)
    }

    var isValid: Bool {
        TimeZone(identifier: sourceTimeZone) != nil && TimeZone(identifier: targetTimeZone) != nil
    }

}
