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
    
    static let settings: UserDefaults = UserDefaults(suiteName: userSettings)!
    
    static func onlyDownloadWithWifi() -> Bool {
        
        if let bool = settings.object(forKey: self.userSettings_onlyDownloadViaWifi) as? Bool {
            //print("userSettings_onlyDownloadViaWifi: \(bool)")
            return bool
        } else {
            settings.set(false, forKey: self.userSettings_onlyDownloadViaWifi)
            return false
        }
    }
    
    
    static func changeBool_onlyDownloadWithWifi(_ bool: Bool) {
        if let _ = settings.object(forKey: self.userSettings_onlyDownloadViaWifi) as? Bool {
            settings.set(bool, forKey: self.userSettings_onlyDownloadViaWifi)
            print(settings.object(forKey: self.userSettings_onlyDownloadViaWifi) as! Bool)
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
