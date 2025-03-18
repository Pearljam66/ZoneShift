//
//  DetailView.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/16/25.
//

import SwiftData
import SwiftUI

struct DetailView: View {
    var contentViewModel: ContentViewModel
    @State private var isEditing = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Time Zone")
                    .frame(width: 200, alignment: .leading)
                Text("Range")
                    .frame(width: 150, alignment: .center)
                Text("Hours")
                    .frame(width: 300, alignment: .center) // Adjusted for grid
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(Color.gray.opacity(0.1))

            // Time Zone Rows
            List {
                // Source Timezone Row
                if let startHour = contentViewModel.startHour(for: contentViewModel.sourceTimeZone),
                   let endHour = contentViewModel.endHour(for: contentViewModel.sourceTimeZone) {
                    TimeZoneRow(timeZoneId: contentViewModel.sourceTimeZone,
                                timeRange: contentViewModel.formattedTimeRange(for: contentViewModel.sourceTimeZone),
                                startHour: startHour,
                                endHour: endHour,
                                isSource: true,
                                contentViewModel: contentViewModel)
                    .listRowInsets(EdgeInsets())
                }

                // Saved Timezone Rows
                ForEach(contentViewModel.savedTimeZoneList, id: \.timeZoneName) { savedZone in
                    if let startHour = contentViewModel.startHour(for: savedZone.timeZoneName),
                       let endHour = contentViewModel.endHour(for: savedZone.timeZoneName) {
                        TimeZoneRow(timeZoneId: savedZone.timeZoneName,
                                    timeRange: contentViewModel.formattedTimeRange(for: savedZone.timeZoneName),
                                    startHour: startHour,
                                    endHour: endHour,
                                    isSource: false,
                                    contentViewModel: contentViewModel)
                        .listRowInsets(EdgeInsets())
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SavedTimeZone.self, configurations: config)
    let context = ModelContext(container)

    let viewModel = ContentViewModel(modelContext: context)
    return DetailView(contentViewModel: viewModel)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SavedTimeZone.self, configurations: config)
    let context = ModelContext(container)

    let viewModel = ContentViewModel(modelContext: context)
    return DetailView(contentViewModel: viewModel)
        .preferredColorScheme(.dark)
}
