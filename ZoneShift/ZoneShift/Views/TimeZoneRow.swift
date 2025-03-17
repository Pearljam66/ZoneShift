//
//  TimeZoneRow.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/16/25.
//

import SwiftUI

struct TimeZoneRow: View {
    var timeZoneRowViewModel: TimeZoneRowViewModel

    init(sourceTimeZone: String, targetTimeZone: String, date: Date) {
        self.timeZoneRowViewModel = TimeZoneRowViewModel(sourceTimeZone: sourceTimeZone, targetTimeZone: targetTimeZone, date: date)
    }

    var body: some View {
        if timeZoneRowViewModel.isValid {
            HStack {
                Text(timeZoneRowViewModel.targetTimeZone)
                    .frame(width: 300, alignment: .leading)
                Text(timeZoneRowViewModel.convertedTimeString)
                Spacer()
            }
            .padding(.horizontal)
        } else {
            Text(timeZoneRowViewModel.convertedTimeString)
        }
    }
}

#Preview("Light Mode"){
    TimeZoneRow(
        sourceTimeZone: "America/New_York",
        targetTimeZone: "Europe/London",
        date: Date()
    )
    .preferredColorScheme(.light)
}

#Preview("Dark Mode"){
    TimeZoneRow(
        sourceTimeZone: "America/New_York",
        targetTimeZone: "Europe/London",
        date: Date()
    )
    .preferredColorScheme(.dark)
}
