
import UIKit
import RealmSwift

class iCloudManager: NSObject {
    
    static let instance = iCloudManager()
    
    public var documentsURLs = (
        domains: URL(string: ""),
        urls: URL(string: "")
    )
    
    override init() {
        super.init()
        
        DispatchQueue.global().async {
            if let url = FileManager.default.url(forUbiquityContainerIdentifier: nil) {
                let documentsURL = url.appendingPathComponent("Documents")
                let collection = documentsURL.appendingPathComponent("collectionsCopy.realm")
                
                let text = "hogehogehoge"
                
                do {
                    let realm = try Realm(fileURL: collection)
                    print(realm)
                    print(realm.objects(Domain.self).sorted(byKeyPath: "title", ascending: true))
//                    try text.write(to: collection, atomically: false, encoding: String.Encoding.utf8)
                } catch {
                    print(error)
                }
            }
        }
        
        
        let containerURL = FileManager.default.url(forUbiquityContainerIdentifier: "iCloud.com.KazukiSugita.dCollectorApp")
        let documentsURL = containerURL?.appendingPathComponent("Documents")
        let domains = documentsURL?.appendingPathComponent("collectionsCopy.realm")
        
        guard let _domains = domains else { return }
        
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: domains!.absoluteString)
            for (key, val) in attributes {
                if key.rawValue == "NSFileModificationDate" {
                    print(val)
                }
            }
        } catch {
//            debugPrint(error)
        }
        
        documentsURLs.domains = _domains
    }

}
