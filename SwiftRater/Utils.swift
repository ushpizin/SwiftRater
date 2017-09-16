//
//  Utils.swift
//  SwiftRater
//
//  Created by Liran on 16/09/2017.
//

import Foundation
import SwiftyUserDefaults

// MARK: - UserDefaults Keys

extension DefaultsKeys {
    static let firstUseDate = DefaultsKey<Date?>("keySwiftRaterFirstUseDate")
    static let usesCount = DefaultsKey<Int>("keySwiftRaterUseCount")
    static let significantEventsCount = DefaultsKey<Int>("keySwiftRaterSignificantEventCount")
    static let isRateDone = DefaultsKey<Bool>("keySwiftRaterRateDone")
    static let trackedVersion = DefaultsKey<String>("keySwiftRaterTrackingVersion")
    static let reminderRequestDate = DefaultsKey<Date?>("keySwiftRaterReminderRequestDate")
}

// MARK: - Error Codes

enum SwiftRaterErrorCode: Int {
    case malformedURL = 1000
    case appStoreDataRetrievalFailure
    case appStoreJSONParsingFailure
    case appStoreAppIDFailure
}

enum SwiftRaterError: Error {
    case malformedURL
    case missingBundleIdOrAppId
}

// MARK: - Extension

internal extension String {
    func localized(_ args: CVarArg...) -> String {
        let localizedString = NSLocalizedString(self,
                                                tableName: "SwiftRaterLocalization",
                                                bundle: Bundle(for: SwiftRater.self),
                                                comment: "")
        return String(format: localizedString, arguments: args)
    }
}

internal extension Bundle {
    class func bundleID() -> String? {
        return Bundle.main.bundleIdentifier
    }
}
