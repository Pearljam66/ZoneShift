//
//  SavedTimeZone.swift
//  ZoneShift
//
//  Created by Sarah Clark on 3/16/25.
//

import SwiftData

@Model
class SavedTimeZone {
    var timeZoneName: String

    init(timeZoneName: String) {
        self.timeZoneName = timeZoneName
    }

}
