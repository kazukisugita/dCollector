
import Foundation

struct AppGroup {
    
    static let suiteName: String = "group.KazukiSugita.dCollectorAppGroup"
    static let keyName: String = "shareData"
            
    static func getUrlsFromUserDefaults() -> Array<String>? {
        let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
        if let arrayObject = sharedDefaults.object(forKey: self.keyName) as? Array<String> {
            return arrayObject
        } else {
            return nil
        }
    }
    
    static func deleteUserDefaultsData() {
        let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
        if let _ = sharedDefaults.object(forKey: self.keyName) as? Array<String> {
            sharedDefaults.removeObject(forKey: self.keyName)
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
