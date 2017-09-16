//
//  UsageDataManager.swift
//  SwiftRater
//
//  Created by Fujiki Takeshi on 2017/03/28.
//  Copyright © 2017年 com.takecian. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class UsageDataManager {

    var daysUntilPrompt: Int?
    var usesUntilPrompt: Int?
    var significantUsesUntilPrompt: Int?
    var daysBeforeReminding: Int?

    var showLaterButton: Bool = true
    var debugMode: Bool = false

    static var shared = UsageDataManager()

    var ratingConditionsHaveBeenMet: Bool {
        guard !debugMode else { // if debug mode, return always true
            printMessage(" In debug mode")
            return true
        }
        guard !Defaults[.isRateDone] else { // if already rated, return false
            printMessage(" Already rated")
            return false
        }

        if let reminderRequestDate = Defaults[.reminderRequestDate] {
            // if the user wanted to be reminded later, has enough time passed?
            if let daysBeforeReminding = daysBeforeReminding {
                printMessage(" will check daysBeforeReminding")
                let timeSinceReminderRequest = Date().timeIntervalSince(reminderRequestDate)
                let timeUntilRate = 60 * 60 * 24 * daysBeforeReminding
                guard Int(timeSinceReminderRequest) < timeUntilRate else { return true }
            }
        } else {
            // check if the app has been used enough days
            if let daysUntilPrompt = daysUntilPrompt {
                printMessage(" will check daysUntilPrompt")
                if let dateOfFirstLaunch = Defaults[.firstUseDate] {
                    let timeSinceFirstLaunch = Date().timeIntervalSince(dateOfFirstLaunch)
                    let timeUntilRate = 60 * 60 * 24 * daysUntilPrompt
                    guard Int(timeSinceFirstLaunch) < timeUntilRate else { return true }
                }
            }

            // check if the app has been used enough times
            if let usesUntilPrompt = usesUntilPrompt {
                printMessage(" will check usesUntilPrompt")
                guard Defaults[.useCount] < usesUntilPrompt else { return true }
            }

            // check if the user has done enough significant events
            if let significantUsesUntilPrompt = significantUsesUntilPrompt {
                printMessage(" will check significantUsesUntilPrompt")
                guard Defaults[.significantEventCount] < significantUsesUntilPrompt else { return true }
            }
        }

        return false
    }

    func reset() {
        Defaults[.firstUseDate] = nil
        Defaults[.useCount] = 0
        Defaults[.significantEventCount] = 0
        Defaults[.isRateDone] = false
        Defaults[.reminderRequestDate] = nil
    }

    func incrementUseCount() {
        Defaults[.useCount] += 1
    }

    func incrementSignificantUseCount() {
        Defaults[.useCount] += 1
    }

    func saveReminderRequestDate() {
        Defaults[.reminderRequestDate] = Date()
    }

    private func printMessage(_ message: String) {
        if SwiftRater.showLog {
            print("[SwiftRater] \(message)")
        }
    }
}
