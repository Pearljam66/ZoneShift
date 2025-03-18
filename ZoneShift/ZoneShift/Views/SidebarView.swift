//
//  SidebarView.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/16/25.
//

import SwiftData
import SwiftUI

struct SidebarView: View {
    @Bindable var contentViewModel: ContentViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Add Time Zone")
                .font(.headline)
                .padding(.horizontal)

            Picker("Time Zone", selection: $contentViewModel.newTimeZone) {
                Text("Select a time zone").tag("")
                ForEach(contentViewModel.availableTimeZones, id: \.self) { timeZone in
                    Text(timeZone).tag(timeZone)
                }
            }
            .labelsHidden()
            .padding(.horizontal)

            Button(action: {
                contentViewModel.addTimeZone()
            }, label: {
                Text("Add")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            .disabled(contentViewModel.newTimeZone.isEmpty)
            .padding(.horizontal)

            Spacer()
        }
        .padding(.vertical)
        .frame(minWidth: 200)
        .navigationTitle("ZoneShift")
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SavedTimeZone.self, configurations: config)
    let context = ModelContext(container)

    let viewModel = ContentViewModel(modelContext: context)
    return SidebarView(contentViewModel: viewModel)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SavedTimeZone.self, configurations: config)
    let context = ModelContext(container)

    let viewModel = ContentViewModel(modelContext: context)
    return SidebarView(contentViewModel: viewModel)
        .preferredColorScheme(.dark)
}
