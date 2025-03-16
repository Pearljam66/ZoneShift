//
//  ContentView.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/16/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel
    @Environment(\.modelContext) private var modelContext

    init() {
        let context = try! ModelContext(ModelContainer(for: SavedTimeZone.self)) // Temporary context for initialization
        _viewModel = StateObject(wrappedValue: ContentViewModel(modelContext: context))
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Source Time Zone:")
                Picker("", selection: $viewModel.sourceTimeZone) {
                    ForEach(viewModel.allTimeZones, id: \.self) { tz in
                        Text(tz).tag(tz)
                    }
                }
                .frame(width: 300)

                DatePicker("Time:", selection: $viewModel.selectedDate, displayedComponents: [.date, .hourAndMinute])
            }
            .padding(.horizontal)

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.savedTimeZoneList, id: \.timeZoneName) { savedZone in
                        TimeZoneRow(
                            sourceTimeZone: viewModel.sourceTimeZone,
                            targetTimeZone: savedZone.timeZoneName,
                            date: viewModel.selectedDate
                        )
                    }
                }
            }
            .frame(minHeight: 100)

            HStack {
                Text("Add Time Zone:")
                Picker("", selection: $viewModel.newTimeZone) {
                    Text("Select a time zone").tag("")
                    ForEach(viewModel.availableTimeZones, id: \.self) { tz in
                        Text(tz).tag(tz)
                    }
                }
                .frame(width: 300)

                Button("Add") {
                    viewModel.addTimeZone()
                }
                .disabled(viewModel.newTimeZone.isEmpty)
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(width: 600, height: 400)
        .navigationTitle("ZoneShift")
        .onAppear {
            // Update viewModel with the actual environment context after init
            viewModel.modelContext = modelContext
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
