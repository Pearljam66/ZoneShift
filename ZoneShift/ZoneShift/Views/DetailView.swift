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
                    .frame(width: 100, alignment: .trailing)
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(Color.gray.opacity(0.1))

            // Time Zone Rows
            List {
                ForEach(contentViewModel.savedTimeZoneList, id: \.timeZoneName) { savedZone in
                    TimeZoneGridRow(timeZoneId: savedZone.timeZoneName, contentViewModel: contentViewModel)
                        .listRowInsets(EdgeInsets())
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
