//
//  DetailView.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/16/25.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var contentViewModel: ContentViewModel

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

            // Toolbar-like area
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(contentViewModel.currentTimeZoneDisplay)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                HStack {
                    Text("London Time Zone")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
            .padding(.horizontal)

            // Time Zone Rows
            List {
                ForEach(contentViewModel.savedTimeZoneList, id: \.timeZoneName) { savedZone in
                    TimeZoneGridRow(timeZoneId: savedZone.timeZoneName, viewModel: contentViewModel)
                        .listRowInsets(EdgeInsets())
                }
            }
            .listStyle(.plain)
        }
    }

}
