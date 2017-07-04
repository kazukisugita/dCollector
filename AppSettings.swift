//
//  AppSettings.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/05/26.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork


struct AppSettings {
    
    static let userSettings: String = "group.KazukiSugita.dCollectorAppGroup.userSettings"
    static let userSettings_onlyDownloadViaWifi: String = "onlyDownloadViaWifi"
    static let userSettings_browser: String = "browser"
    
    static let settings: UserDefaults = UserDefaults(suiteName: userSettings)!
}


// onlyDownloadViaWifi
extension AppSettings {
    
    static func onlyDownloadWithWifi() -> Bool {
        
        if let bool = settings.object(forKey: self.userSettings_onlyDownloadViaWifi) as? Bool {
            return bool
        } else {
            settings.set(false, forKey: self.userSettings_onlyDownloadViaWifi)
            return false
        }
    }
    
    
    static func changeBool_onlyDownloadWithWifi(_ bool: Bool) {
        if let _ = settings.object(forKey: self.userSettings_onlyDownloadViaWifi) as? Bool {
            settings.set(bool, forKey: self.userSettings_onlyDownloadViaWifi)
        }
    }
    
    
    static func wifiSsidNameExisting() -> Bool {
        var ssidExisting: Bool = false
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let _ = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssidExisting = true
                    break
                }
            }
        }
        return ssidExisting
    }
    
}


enum Browsers: String {
    case dDefault = "Default"
    case safari = "Safari"
    case chrome = "Chrome"
}


// browser
extension AppSettings {
 
    static func broswerIs() -> Int {
        if let num = settings.object(forKey: self.userSettings_browser) as? Int {
            return num
        } else {
            let _num = Browsers.dDefault.hashValue
            settings.set(_num, forKey: self.userSettings_browser)
            return _num
        }
    }
    
    
    static func changeBrowserIs(index: Int) {
        if let _ = settings.object(forKey: self.userSettings_browser) as? Int {
            settings.set(index, forKey: self.userSettings_browser)
        }
    }
    
}
