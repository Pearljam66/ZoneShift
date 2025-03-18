//
//  TimeZoneRow.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/17/25.
//

import SwiftData
import SwiftUI

struct TimeZoneRow: View {
    let timeZoneId: String
    let timeRange: String
    let startHour: Int
    let endHour: Int
    let isSource: Bool
    var contentViewModel: ContentViewModel

    // Helper function to convert 24-hour format to 12-hour format
    private func formatHour(_ hour: Int) -> String {
        let adjustedHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        let period = hour < 12 ? "am" : "pm"
        return "\(adjustedHour)\(period)"
    }

    var body: some View {
        HStack(spacing: 0) {
            // Time Zone Name
            Text(timeZoneId)
                .frame(width: 200, alignment: .leading)
                .padding(.leading, 5)

            // Time Range
            Text(timeRange)
                .frame(width: 150, alignment: .center)

            // 12-Hour Grid (converted from 24-hour)
            ZStack {
                HStack(spacing: 0) {
                    ForEach(0..<24, id: \.self) { hour in
                        Text(formatHour(hour))
                            .frame(width: 30, height: 30)
                            .background(Color.gray.opacity(0.1))
                            .foregroundColor(.secondary)
                    }
                }
                .overlay(
                    GeometryReader { geometry in
                        HStack(spacing: 0) {
                            let startX = CGFloat(startHour) * 30
                            let endX = CGFloat(endHour) * 30
                            Rectangle()
                                .fill(Color.blue.opacity(isSource ? 0.5 : 0.3))
                                .frame(width: endX - startX, height: 30)
                                .position(x: startX + (endX - startX) / 2, y: 15)
                        }
                    }
                )
            }
            .frame(width: 300)

            // Delete Button (for non-source timezones)
            if !isSource {
                Button(action: {
                    if let timeZoneToDelete = contentViewModel.savedTimeZoneList.first(where: { $0.timeZoneName == timeZoneId }) {
                        contentViewModel.deleteTimeZone(timeZoneToDelete)
                    }
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 10)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isSource ? Color.gray.opacity(0.05) : Color.clear)
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SavedTimeZone.self, configurations: config)
    let context = ModelContext(container)

    let viewModel = ContentViewModel(modelContext: context)
    let mockTimeZone = SavedTimeZone(timeZoneName: "Europe/London")
    context.insert(mockTimeZone)
    viewModel.refreshSavedTimeZones()

    return TimeZoneRow(
        timeZoneId: "Europe/London",
        timeRange: "Tue, Mar 18, 5:00p - 6:00p",
        startHour: 17, // 5:00 PM
        endHour: 18,   // 6:00 PM
        isSource: true,
        contentViewModel: viewModel
    )
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SavedTimeZone.self, configurations: config)
    let context = ModelContext(container)

    let viewModel = ContentViewModel(modelContext: context)
    let mockTimeZone = SavedTimeZone(timeZoneName: "America/New_York")
    context.insert(mockTimeZone)
    viewModel.refreshSavedTimeZones()

    return TimeZoneRow(
        timeZoneId: "America/New_York",
        timeRange: "Tue, Mar 18, 12:00p - 1:00p",
        startHour: 12, // 12:00 PM
        endHour: 13,   // 1:00 PM
        isSource: false,
        contentViewModel: viewModel
    )
    .preferredColorScheme(.dark)
}
