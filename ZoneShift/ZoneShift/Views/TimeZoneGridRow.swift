//
//  TimeZoneGridRow.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/16/25.
//

import SwiftData
import SwiftUI

struct TimeZoneGridRow: View {
    let timeZoneId: String
    var contentViewModel: ContentViewModel

    var body: some View {
        if let (start, end) = contentViewModel.timeRange(for: timeZoneId) {
            let calendar = Calendar.current
            let startHour = calendar.component(.hour, from: start)
            let endHour = calendar.component(.hour, from: end)

            HStack {
                // Time Zone Name
                Text(timeZoneId)
                    .frame(width: 200, alignment: .leading)

                // Time Range
                Text(contentViewModel.formattedTimeRange(for: timeZoneId))
                    .frame(width: 150, alignment: .center)

                // 24-Hour Grid
                ZStack {
                    HStack(spacing: 0) {
                        ForEach(0..<24, id: \.self) { _ in
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 30, height: 30)
                        }
                    }
                    .overlay(
                        GeometryReader { _ in
                            HStack(spacing: 0) {
                                let startX = CGFloat(startHour) * 30
                                let endX = CGFloat(endHour) * 30
                                Rectangle()
                                    .fill(Color.blue.opacity(0.3))
                                    .frame(width: endX - startX, height: 30)
                                    .position(x: startX + (endX - startX) / 2, y: 15)
                            }
                        }
                    )
                }
                .frame(maxWidth: .infinity)

                Button(action: {
                    if let timeZoneToDelete = contentViewModel.savedTimeZoneList.first(where: { $0.timeZoneName == timeZoneId }) {
                        contentViewModel.deleteTimeZone(timeZoneToDelete)
                    }
                }, label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .frame(width: 30, height: 30)
                })
                .buttonStyle(.plain)
                .padding(.trailing, 10)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
        } else {
            Text("Invalid time zone: \(timeZoneId)")
                .padding(.horizontal)
                .onAppear {
                    print("Invalid time zone: \(timeZoneId)")
                }
        }
    }

    private func isInitialTimeZone(_ timeZoneName: String) -> Bool {
        let initialTimeZones = [TimeZone.current.identifier, "Europe/London"]
        return initialTimeZones.contains(timeZoneName)
    }

}

// MARK: - Previews
#Preview("Light Mode") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SavedTimeZone.self, configurations: config)
    let context = ModelContext(container)

    let viewModel = ContentViewModel(modelContext: context)
    return TimeZoneGridRow(timeZoneId: "America/New_York", contentViewModel: viewModel)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SavedTimeZone.self, configurations: config)
    let context = ModelContext(container)

    let viewModel = ContentViewModel(modelContext: context)
    return TimeZoneGridRow(timeZoneId: "America/New_York", contentViewModel: viewModel)
        .preferredColorScheme(.dark)
}
