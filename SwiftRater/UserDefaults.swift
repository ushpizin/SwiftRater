//
//  UserDefaults.swift
//  SwiftRater
//
//  Created by Liran on 16/09/2017.
//  Copyright © 2017 com.takecian. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let firstUseDate = DefaultsKey<Date?>("keySwiftRaterFirstUseDate")
    static let useCount = DefaultsKey<Int>("keySwiftRaterUseCount")
    static let significantEventCount = DefaultsKey<Int>("keySwiftRaterSignificantEventCount")
    static let isRateDone = DefaultsKey<Bool>("keySwiftRaterRateDone")
    static let trackingVersion = DefaultsKey<String>("keySwiftRaterTrackingVersion")
    static let reminderRequestDate = DefaultsKey<Date?>("keySwiftRaterReminderRequestDate")
}
