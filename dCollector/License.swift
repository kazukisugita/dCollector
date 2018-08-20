
import Foundation

extension Collection where Indices.Iterator.Element == Index {
    
    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct License {
    
    var items: [[String : Any]] = []
    var titles: [String] = []
    
    init?() {
        guard let licenses: [[String : Any]] = parsePlist(FileName.licenses) else {
            return nil
        }
        items = licenses
        titles = items.flatMap { $0["title"] as? String }
    }
    
    
    func getLicenseText(index: Int) -> String? {
        guard let item = items[safe: index] else { return nil }
        return item["text"] as? String
    }
    
    func getGithubText(index: Int) -> String? {
        guard let item = items[safe: index] else { return nil }
        return item["github"] as? String
    }
    
    
    private func parsePlist(_ fileName: FileName) -> [[String: Any]]? {
        guard let filePath: URL = Bundle.main.url(forResource: fileName.rawValue, withExtension: "plist") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: filePath)
            return try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [[String: Any]]
        }
        catch {
            return nil
        }
    }
}
