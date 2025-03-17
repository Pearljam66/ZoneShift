//
//  ContentView.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/16/25.
//


import SwiftData
import SwiftUI

struct ContentView: View {
    @StateObject private var contentViewModel: ContentViewModel
    @Environment(\.modelContext) private var modelContext

    init() {
        let context = try! ModelContext(ModelContainer(for: SavedTimeZone.self))
        _contentViewModel = StateObject(wrappedValue: ContentViewModel(modelContext: context))
    }

    // MARK: Body
    var body: some View {
        NavigationSplitView {
            SidebarView(contentViewModel: contentViewModel)
        } detail: {
            DetailView(contentViewModel: contentViewModel)
                .onAppear {
                    contentViewModel.modelContext = modelContext
                }
        }
    }

}

// MARK: Previews
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
