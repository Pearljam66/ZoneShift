//
//  TimeZoneGridRow.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/16/25.
//

import SwiftUI

struct TimeZoneGridRow: View {
    let timeZoneId: String
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        if let (start, end) = viewModel.timeRange(for: timeZoneId) {
            let calendar = Calendar.current
            let startHour = calendar.component(.hour, from: start)
            let endHour = calendar.component(.hour, from: end)

            HStack {
                Text(timeZoneId)
                    .frame(width: 200, alignment: .leading)
                Text(viewModel.formattedTimeRange(for: timeZoneId))
                    .frame(width: 150, alignment: .center)
                ZStack {
                    HStack(spacing: 0) {
                        ForEach(0..<24, id: \.self) { hour in
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 30, height: 30)
                        }
                    }
                    .overlay(
                        GeometryReader { geometry in
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
            }
            .padding(.horizontal)
        } else {
            Text("Invalid time zone: \(timeZoneId)")
                .padding(.horizontal)
        }
    }

}
