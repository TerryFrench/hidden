//
//  Util.swift
//  vanillaClone
//
//  Created by Thanh Nguyen on 1/29/19.
//  Copyright © 2019 Dwarves Foundation. All rights reserved.
//

import AppKit
import Foundation
import ServiceManagement
import OSLog

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like a view that appeared.
    static let mainLog = Logger(subsystem: subsystem, category: Constant.category)
}

class Util {
    static func setUpAutoStart(isAutoStart:Bool) {
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == Constant.launcherAppId }.isEmpty

        
        let appService = SMAppService.loginItem(identifier: Constant.launcherAppId)
        if isAutoStart {
            do {
                try appService.register()
            }
            catch {
                Logger.mainLog.warning("Unable to register")

            }
        } else {
            appService.unregister(completionHandler: { error in
                if let error = error {
                    Logger.mainLog.warning("Unable to unregister \(error)")
                }
            }
                                  )
        }
        
//        SMLoginItemSetEnabled(Constant.launcherAppId as CFString, isAutoStart)
        
        if isRunning {
            DistributedNotificationCenter.default().post(name: Notification.Name("killLauncher"),
                                                         object: Bundle.main.bundleIdentifier!)
        }
    }
    
    static func showPrefWindow() {
        let prefWindow = PreferencesWindowController.shared.window
        prefWindow?.bringToFront()
    }
   
}
