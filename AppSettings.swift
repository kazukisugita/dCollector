
import Foundation
import Reachability

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
    
    
    static func isWifiConnection() -> Bool {
        return Reachability()?.connection == .wifi
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
            switch num {
            case Browsers.dDefault.hashValue:
                return 0
            case Browsers.safari.hashValue:
                return 1
            case Browsers.chrome.hashValue:
                return 2
            default:
                return 0
            }
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
