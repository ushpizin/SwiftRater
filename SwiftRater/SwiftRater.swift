//
//  SwiftRater.swift
//  SwiftRater
//
//  Created by Fujiki Takeshi on 2017/03/28.
//  Copyright © 2017年 com.takecian. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyUserDefaults

@objc public class SwiftRater: NSObject {

    // MARK: - Initializers

    private override init() { }

    // MARK: - UsageDataManager Accessors

    public static var daysUntilPrompt: Int? {
        get {
            return UsageDataManager.shared.daysUntilPrompt
        }
        set {
            UsageDataManager.shared.daysUntilPrompt = newValue
        }
    }
    public static var usesUntilPrompt: Int? {
        get {
            return UsageDataManager.shared.usesUntilPrompt
        }
        set {
            UsageDataManager.shared.usesUntilPrompt = newValue
        }
    }
    public static var significantUsesUntilPrompt: Int? {
        get {
            return UsageDataManager.shared.significantUsesUntilPrompt
        }
        set {
            UsageDataManager.shared.significantUsesUntilPrompt = newValue
        }
    }

    public static var daysBeforeReminding: Int? {
        get {
            return UsageDataManager.shared.daysBeforeReminding
        }
        set {
            UsageDataManager.shared.daysBeforeReminding = newValue
        }
    }
    public static var debugMode: Bool {
        get {
            return UsageDataManager.shared.debugMode
        }
        set {
            UsageDataManager.shared.debugMode = newValue
        }
    }

    // MARK: - Public Properties

    public static var useStoreKitIfAvailable: Bool = true

    public static var showLaterButton: Bool = true

    public static var alertTitle: String?
    public static var alertMessage: String?
    public static var alertCancelTitle: String?
    public static var alertRateTitle: String?
    public static var alertRateLaterTitle: String?
    public static var appName: String?

    public static var showLog: Bool = false
    public static var resetWhenAppUpdated: Bool = true

    public static var appId: String?

    // MARK - Private Computed Properties

    private static var appVersion: String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }

    private static var titleText: String {
        return SwiftRater.alertTitle ?? "Rate %@".localized(mainAppName)
    }

    private static var messageText: String {
        return SwiftRater.alertMessage ?? "Rater.title".localized(mainAppName)
    }

    private static var rateText: String {
        return SwiftRater.alertRateTitle ?? "Rate %@".localized(mainAppName)
    }

    private static var cancelText: String {
        return SwiftRater.alertCancelTitle ?? "No, Thanks".localized(mainAppName)
    }

    private static var laterText: String {
        return SwiftRater.alertRateLaterTitle ?? "Remind me later".localized(mainAppName)
    }

    private static var mainAppName: String {
        if let name = SwiftRater.appName {
            return name
        }else if let name = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            return name
        } else if let name = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return name
        } else {
            return "App"
        }
    }

    // MARK: - Public Functions

    public static func appLaunch() {
        if SwiftRater.resetWhenAppUpdated && SwiftRater.appVersion != Defaults[.trackedVersion] {
            UsageDataManager.reset()
            Defaults[.trackedVersion] = SwiftRater.appVersion
        }
        SwiftRater.incrementUsageCount()
    }

    public static func incrementSignificantUsageCount() {
        UsageDataManager.incrementSignificantUseCount()
    }

    public static func check() {
        if UsageDataManager.shared.ratingConditionsHaveBeenMet {
            SwiftRater.showRatingAlert()
        }
    }

    public static func rateApp() {
        SwiftRater.rateAppWithAppStore()
        Defaults[.isRateDone] = true
    }

    public static func reset() {
        UsageDataManager.reset()
    }

    // MARK: - Private Functions

    private static func incrementUsageCount() {
        UsageDataManager.incrementUseCount()
    }

    private static func incrementSignificantUseCount() {
        UsageDataManager.incrementSignificantUseCount()
    }

    private static func showRatingAlert() {
        print("[SwiftRater] Trying to show review request dialog.")
        if #available(iOS 10.3, *), SwiftRater.useStoreKitIfAvailable {
            SKStoreReviewController.requestReview()
            Defaults[.isRateDone] = true
        } else {
            let alertController = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)

            let rateAction = UIAlertAction(title: rateText, style: .default, handler: { action -> Void in
                SwiftRater.rateAppWithAppStore()
                Defaults[.isRateDone] = true
            })
            alertController.addAction(rateAction)

            if SwiftRater.showLaterButton {
                alertController.addAction(UIAlertAction(title: laterText, style: .default, handler: {
                    action -> Void in
                    UsageDataManager.saveReminderRequestDate()
                }))
            }

            alertController.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: {
                action -> Void in
                Defaults[.isRateDone] = true
            }))

            if #available(iOS 9.0, *) {
                alertController.preferredAction = rateAction
            }

            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }

    private static func rateAppWithAppStore() {
        #if arch(i386) || arch(x86_64)
            print("SWIFTRATER NOTE: iTunes App Store is not supported on the iOS simulator. Unable to open App Store page.")
        #else
            guard let appId = SwiftRater.appId,
                  let url = URL(string: "https://itunes.apple.com/app/id\(appId)?action=write-review") else {
                    return
            }

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        #endif
    }
}
