//
//  TimeZoneRow.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/16/25.
//

import SwiftUI

struct TimeZoneRow: View {
    @ObservedObject var viewModel: TimeZoneRowViewModel

    init(sourceTimeZone: String, targetTimeZone: String, date: Date) {
        self.viewModel = TimeZoneRowViewModel(sourceTimeZone: sourceTimeZone, targetTimeZone: targetTimeZone, date: date)
    }

    var body: some View {
        if viewModel.isValid {
            HStack {
                Text(viewModel.targetTimeZone)
                    .frame(width: 300, alignment: .leading)
                Text(viewModel.convertedTimeString)
                Spacer()
            }
            .padding(.horizontal)
        } else {
            Text(viewModel.convertedTimeString)
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
