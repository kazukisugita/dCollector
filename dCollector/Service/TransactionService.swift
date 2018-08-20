
import Foundation
import UIKit
import RealmSwift
import Ji

struct TransactionService {
    
    private static func getDataFromWebSite (_ url: String ,with completion: @escaping (_ success: Bool, _ failObj: String?)->() ) {
        
        guard let host = NSURL(string: url)?.host else {
            return completion(false, url)
        }
        
        var httpProtocol: String = "http"
        if url.hasPrefix("https") {
            httpProtocol = "https"
        }
        
        let urlObj = Ji(htmlURL: URL(string: url)!)
        let domainObj = Ji(htmlURL: URL(string: "\(httpProtocol)://\(host)")!)
        
        if urlObj == nil && domainObj == nil {
            completion(false, url)
        }
        
        let realmUrl: Url = Url()
        realmUrl.url = url
        
        if let title = urlObj?.xPath("//head/title")?.first {
            if let _title = title.content {
                realmUrl.title = _title
            }
        }
        
        var realmDomain: Domain = Domain()
        
        realmDomain.name = host
        if let title = domainObj?.xPath("//head/title")?.first {
            realmDomain.title = title.content!
        } else {
            realmDomain.title = host
        }
        if let description = domainObj?.xPath("//head/meta[@name='description']")?.first {
            if let _desc = description["content"] {
                realmDomain.siteDescription = _desc
            }
        }
        
        let iconPath: String = "/favicon.ico"
        var iconUrl: URL = URL(string: "\(httpProtocol)://" + host + iconPath)!
        
        if let node = domainObj?.xPath("//head/link[@rel='icon']")?.first {
            guard let iconPath = node["href"] else {
                completion(false, url)
                return
            }
            iconUrl = URL(string: "\(httpProtocol)://" + host + iconPath)!
            
            if iconPath.contains(host) {
                iconUrl = URL(string: iconPath)!
            }
            if iconPath.hasPrefix("//") {
                iconUrl = URL(string: "\(httpProtocol):" + iconPath)!
            }
        }
        
        if let node = domainObj?.xPath("//head/link[@rel='shortcut icon']")?.first {
            guard let iconPath = node["href"] else {
                completion(false, url)
                return
            }
            iconUrl = URL(string: "\(httpProtocol)://" + host + iconPath)!
            if iconPath.contains(host) {
                iconUrl = URL(string: iconPath)!
            }
            if iconPath.hasPrefix("//") {
                iconUrl = URL(string: "\(httpProtocol):" + iconPath)!
            }
        }
        
        if let node = domainObj?.xPath("//head/link[@rel='apple-touch-icon']")?.first {
            guard let iconPath = node["href"] else {
                completion(false, url)
                return
            }
            iconUrl = URL(string: "\(httpProtocol)://" + host + iconPath)!
            if iconPath.contains(host) {
                iconUrl = URL(string: iconPath)!
            }
            if iconPath.hasPrefix("//") {
                iconUrl = URL(string: "\(httpProtocol):" + iconPath)!
            }
        }
        realmDomain.iconPath = iconUrl.absoluteString
        
        DispatchQueue.main.async {
            if let alreadyExsitingDomain = RealmService.getDomainWithPrimaryKey(host) {
                realmDomain = alreadyExsitingDomain
                realmUrl.domain = alreadyExsitingDomain
            } else {
                realmUrl.domain = realmDomain
            }
            RealmService.addToDomain(realmDomain, realmUrl)
            RealmService.addToUrl(realmUrl)
            completion(true, url)
        }
        
        
    }
        
    
    public static func fromUserdefaultsToRealm (with completion: @escaping (_ success: Bool, _ successUrl: String?)->() ) {
        
        guard let userdefaults = AppGroup.getUrlsFromUserDefaults() else { return }
        
        for url in userdefaults {
            if let _ = RealmService.getUrlWithPrimaryKey(url) {
                completion(true, url)
                continue
            }
            DispatchQueue.global(qos: .userInteractive).async {
                TransactionService.getDataFromWebSite(url) { complete, url in
                    if complete {
                        completion(true, url)
                    } else {
                        print(" --- Transaction FAILURE --- ")
                        print(" ---- which is \(url!)")
                        completion(true, nil)
                    }
                }
            }
        }

    }
    
    
    public static func getIconImage(forCell cell: ListsTableViewCell, iconPath: String, hostName: String) {
        
        let iconUrl: URL = URL(string: iconPath)!
        
        if let data = try? Data(contentsOf: iconUrl) {
            DispatchQueue.main.async {
                cell.domainIcon?.image = UIImage(data: data)
                cell.domainIcon?.backgroundColor = .none
                let iconObject = RealmService.getDomainWithPrimaryKey(hostName)
                RealmService.rewriteSpecificDomain(iconObject!, image: data as NSData)
            }
            return
        }
        
        retryGetIconImage(forCell: cell, url: iconPath, hostName: hostName)
    }
    
    
    private static func retryGetIconImage(forCell cell: ListsTableViewCell, url iconUrl: String, hostName name: String) {
        
        var httpProtocol: String = "http"
        if iconUrl.hasPrefix("https") {
            httpProtocol = "https"
        }
        let retryUrl: URL =  URL(string: "\(httpProtocol)://" + name + "/favicon.ico")!
        
        if let data = try? Data(contentsOf: retryUrl) {
            DispatchQueue.main.async {
                cell.domainIcon?.image = UIImage(data: data)
                cell.domainIcon?.backgroundColor = .none
                let iconObject = RealmService.getDomainWithPrimaryKey(name)
                RealmService.rewriteSpecificDomain(iconObject!, image: data as NSData)
            }
            return
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            let emptyImage = #imageLiteral(resourceName: "no-image-icon")
            cell.domainIcon?.image = emptyImage
            cell.domainIcon?.backgroundColor = .none
            let iconObject = RealmService.getDomainWithPrimaryKey(name)
            RealmService.rewriteSpecificDomain(iconObject!, image: UIImagePNGRepresentation(emptyImage)! as NSData)
        })
    }
    
    
}
