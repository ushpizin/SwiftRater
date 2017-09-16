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

    // MARK: - Initializers

    private init() { }

    // MARK: - Public Properties

    static let shared = UsageDataManager()

    var daysUntilPrompt: Int?
    var usesUntilPrompt: Int?
    var significantUsesUntilPrompt: Int?
    var daysBeforeReminding: Int?

    var showLaterButton: Bool = true
    var debugMode: Bool = false

    // MARK: - Public Computed Properties

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
                if Int(timeSinceReminderRequest) >= timeUntilRate {
                    return true
                }
            }
        } else {
            // check if the app has been used enough days
            if let daysUntilPrompt = daysUntilPrompt {
                printMessage(" will check daysUntilPrompt")
                if let dateOfFirstLaunch = Defaults[.firstUseDate] {
                    let timeSinceFirstLaunch = Date().timeIntervalSince(dateOfFirstLaunch)
                    let timeUntilRate = 60 * 60 * 24 * daysUntilPrompt
                    if Int(timeSinceFirstLaunch) >= timeUntilRate {
                        return true
                    }
                }
            }

            // check if the app has been used enough times
            if let usesUntilPrompt = usesUntilPrompt {
                printMessage(" will check usesUntilPrompt")
                if Defaults[.usesCount] >= usesUntilPrompt {
                    return true
                }
            }

            // check if the user has done enough significant events
            if let significantUsesUntilPrompt = significantUsesUntilPrompt {
                printMessage(" will check significantUsesUntilPrompt")
                if Defaults[.significantEventsCount] >= significantUsesUntilPrompt {
                    return true
                }
            }
        }

        return false
    }

    // MARK: - Public Class Methods

    static func reset() {
        Defaults[.firstUseDate] = nil
        Defaults[.usesCount] = 0
        Defaults[.significantEventsCount] = 0
        Defaults[.isRateDone] = false
        Defaults[.reminderRequestDate] = nil
    }

    static func incrementUseCount() {
        Defaults[.usesCount] += 1
    }

    static func incrementSignificantUseCount() {
        Defaults[.usesCount] += 1
    }

    static func saveReminderRequestDate() {
        Defaults[.reminderRequestDate] = Date()
    }

    // MARK: - Private Methods

    private func printMessage(_ message: String) {
        if SwiftRater.showLog {
            print("[SwiftRater] \(message)")
        }
    }
}
