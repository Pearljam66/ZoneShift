//
//  SidebarView.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/16/25.
//

import SwiftUI

struct SidebarView: View {
    @ObservedObject var contentViewModel: ContentViewModel

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
