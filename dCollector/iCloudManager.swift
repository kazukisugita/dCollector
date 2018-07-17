
import UIKit

class iCloudManager: NSObject {
    
    static let instance = iCloudManager()
    
    public var documentsURLs = (
        domains: URL(string: ""),
        urls: URL(string: "")
    )
    
    override init() {
        super.init()
        
        let containerURL = FileManager.default.url(forUbiquityContainerIdentifier: "iCloud.com.KazukiSugita.dCollectorApp")
        let documentsURL = containerURL?.appendingPathComponent("Documents")
        let domains = documentsURL?.appendingPathComponent("domains.realm")
        
        guard let _domains = domains else { return }
        documentsURLs.domains = _domains
    }

}
