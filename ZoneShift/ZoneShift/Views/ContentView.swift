//
//  ContentView.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/16/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var contentViewModel: ContentViewModel
    @Environment(\.modelContext) private var modelContext

    init() {
        let context = try! ModelContext(ModelContainer(for: SavedTimeZone.self)) // Temporary context for initialization
        _contentViewModel = StateObject(wrappedValue: ContentViewModel(modelContext: context))
    }

    var body: some View {
        NavigationSplitView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Add Time Zone")
                    .font(.headline)
                    .padding(.horizontal)

                Picker("Time Zone", selection: $contentViewModel.newTimeZone) {
                    Text("Select a time zone").tag("")
                    ForEach(contentViewModel.availableTimeZones, id: \.self) { timeRange in
                        Text(timeRange).tag(timeRange)
                    }
                }
                .labelsHidden()
                .padding(.horizontal)

                Button(action: {
                    contentViewModel.addTimeZone()
                }, label:{
                    Text("Add")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.borderedProminent)
                .disabled(contentViewModel.newTimeZone.isEmpty)
                .padding(.horizontal)
            }
        } detail : {
            VStack {
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

                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(contentViewModel.currentTimeZoneDisplay)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    HStack {
                        Text("London time Zone")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }

                // Time Zone Rows
                List {
                    ForEach(contentViewModel.savedTimeZoneList, id: \.timeZoneName) { savedZone in
                        TimeZoneGridRow(timeZoneId: savedZone.timeZoneName, viewModel: contentViewModel)
                            .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(.plain)
            }
            .onAppear {
                contentViewModel.modelContext = modelContext
            }
        }
    }

}

#Preview("Light Mode") {
    ContentView()
        .modelContainer(for: SavedTimeZone.self, inMemory: true)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView()
        .modelContainer(for: SavedTimeZone.self, inMemory: true)
        .preferredColorScheme(.dark)
}
