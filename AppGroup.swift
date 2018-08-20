
import Foundation

struct AppGroup {
    
    static let suiteName: String = "group.KazukiSugita.dCollectorAppGroup"
    static let keyName: String = "shareData"
        
    static func tryGetData() {
        print("*** tryGetData ***")
        
        let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
        if let arrayObject = sharedDefaults.object(forKey: self.keyName) as? Array<String> {
            print("UserDefault: \(arrayObject)")
        } else {
            print("UserDefaults is nil")
        }
    }
    
    static func getUrlsFromUserDefaults() -> Array<String>? {
//        print("*** tryGetData ***")
        let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
        if let arrayObject = sharedDefaults.object(forKey: self.keyName) as? Array<String> {
            return arrayObject
        } else {
            return nil
        }
    }
    
    static func hasData() -> Bool {
        let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
        if let _ = sharedDefaults.object(forKey: self.keyName) as? Array<String> {
            return true
        } else {
            return false
        }
    }
    
    static func trySetDataToUserDefaults() {
        let sample: Array<String> = [
            "https://www.apple.com/ac/structured-data/images/open_graph_logo.png?201704300821",
            "http://www.lifehacker.jp/lifehacker_parts/img/common/logo_600x166px.png",
            "https://www.lifehacker.jp/assets/common/img/apple-touch-icon.png"
        ]
        let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
        sharedDefaults.set(sample, forKey: self.keyName)
    }
    
    static func setDataToUserDefaults(url url_str: String) {
        
        var objects: Array<String> = []
    
        let defaults = UserDefaults(suiteName: AppGroup.suiteName)!
        
        // KeyNameでの存在確認
        if let defaultsObjects = defaults.object(forKey: AppGroup.keyName) as? Array<String> {
            objects = defaultsObjects
            // 新規とUserDefaults内の重複を確認
            var found: Bool = false
            for object in objects {
                if object == url_str {
                    found = true
                }
            }
            if(!found) {
                objects.append(url_str)
                defaults.set(objects, forKey: AppGroup.keyName)
            }
            
        } else {
            objects.append(url_str)
            defaults.set(objects, forKey: AppGroup.keyName)
        }
    }
    
    static func deleteUserDefaultsData() {
        let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
        if let _ = sharedDefaults.object(forKey: self.keyName) as? Array<String> {
            sharedDefaults.removeObject(forKey: self.keyName)
            print(" --- deleteUserDefaultsData --- ")
        }
    }
    
    static func deleteUserDefaultsOneByOne(url: String) {
        var array: [String] = []
        let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
        
        if let defautls = sharedDefaults.object(forKey: self.keyName) as? Array<String> {
            array = defautls
            
            for value in 0..<array.count {
                if (array[value] == url) {
                    array.remove(at: value)
                    
                    sharedDefaults.removeObject(forKey: self.keyName)
                    sharedDefaults.set(array, forKey: self.keyName)
                    
                    break
                }
            }
        }
        
    }
    
}
