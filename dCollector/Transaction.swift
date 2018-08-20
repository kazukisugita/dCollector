//
//  Transaction.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/05/15.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Ji


public struct Transaction {
    
    //static var listsViewControllerDelegate: ListsViewControllerDelegate = ListsViewController()
    
    private static func getDataFromWebSite (_ url: String ,with completion: @escaping (_ success: Bool, _ failObj: String?)->() ) {
        
        guard let host = NSURL(string: url)?.host else {
            return completion(false, url)
        }
        
        var httpProtocol: String = "http"
        if url.hasPrefix("https") {
            httpProtocol = "https"
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let urlObj = Ji(htmlURL: URL(string: url)!)
            let domainObj = Ji(htmlURL: URL(string: "\(httpProtocol)://\(host)")!)
            
            if urlObj != nil && domainObj != nil {
                
                let realmUrl: Url = Url()
                realmUrl.url = url
                
                if let title = urlObj?.xPath("//head/title")?.first {
                    //realmUrl.title = title.content!
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
                
                //
                var iconPath: String = "/favicon.ico"
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
                    //print("rel=icon: \(iconUrl)")
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
                    //print("rel=shortcut icon: \(iconUrl)")
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
                    //print("rel=apple-touch-icon: \(iconUrl)")
                }
                realmDomain.iconPath = iconUrl.absoluteString
            
                
                DispatchQueue.main.async {
                    if let alreadyExsitingDomain = RealmManager.getDomainWithPrimaryKey(host) {
                        realmDomain = alreadyExsitingDomain
                        realmUrl.domain = alreadyExsitingDomain
                    } else {
                        realmUrl.domain = realmDomain
                    }
                    RealmManager.addToDomain(realmDomain, realmUrl)
                    RealmManager.addToUrl(realmUrl)
                    completion(true, url)
                }
                //print(realmUrl)
                //print(realmDomain)
                //completion(true)
            } else {
                completion(false, url)
            }
            
        }

        
    }
        
    
    public static func fromUserdefaultsToRealm (with completion: @escaping (_ success: Bool, _ successUrl: String?)->() ) {
        
        guard let userdefaults = AppGroup.getUrlsFromUserDefaults() else { return }
        
        print(userdefaults)
        
        for url in userdefaults {
            
            if let _ = RealmManager.getUrlWithPrimaryKey(url) {
                print("we already have: \(url)")
                completion(true, url)
                continue
            }
            
            Transaction.getDataFromWebSite(url) { (complete, url) in
                if complete {
                    print(" getDataFromWebSite complete")
                    completion(true, url)
                } else {
                    print(" --- Transaction FAILURE --- ")
                    print(" ---- which is \(url!)")
                    completion(true, nil)
                }
            }
        }
        //AppGroup.deleteUserDefaultsData()
    }
    
    
    public static func getIconImage (forCell cell: AnyObject, iconPath: String, hostName: String) {
        
        let session = URLSession(configuration: .default)
        let iconUrl: URL = URL(string: iconPath)!
        
        session.downloadTask(with: iconUrl, completionHandler: { (location, response, error) in
            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                if let data = try? Data(contentsOf: iconUrl){
                    DispatchQueue.main.async {
                        autoreleasepool {
                            //                            let iconObject = RealmManager.getDomainWithPrimaryKey(domain.name)
                            //                            RealmManager.rewriteSpecificDomain(iconObject!, image: data as NSData)
                            
                            if cell is ListsTableViewCell {
                                let cell = cell as! ListsTableViewCell
                                cell.domainIcon?.image = UIImage(data: data)
                                cell.domainIcon?.backgroundColor = .none
                                cell.layoutIfNeeded()
                            }
                        }
                    }
                }
            } else {
                Transaction.getIconImageInBackground(forCell: cell, url: iconPath, hostName: hostName)
            }
            session.invalidateAndCancel()
        }).resume()

    }
    
    
    private static func getIconImageInBackground (forCell cell: AnyObject, url iconUrl: String, hostName name: String) {
        
        let session = URLSession(configuration: .default)
        
        //let iconPath: String = "https://" + name + "/favicon.ico"
        //let iconUrl: URL = URL(string: iconPath)!
        
        var httpProtocol: String = "http"
        if iconUrl.hasPrefix("https") {
            httpProtocol = "https"
        }
        
        let retryUrl: URL =  URL(string: "\(httpProtocol)://" + name + "/favicon.ico")!
        
        DispatchQueue.global(qos: .background).async {
            session.downloadTask(with: retryUrl, completionHandler: { (location, response, error) in
                
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    print("\(name) -> response: 200...299")
                    
                    if let data = try? Data(contentsOf: retryUrl){
                        //print("data: \(data)")
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            let iconObject = RealmManager.getDomainWithPrimaryKey(name)
                            RealmManager.rewriteSpecificDomain(iconObject!, image: data as NSData)
                            
                            if cell is ListsTableViewCell {
                                let cell = cell as! ListsTableViewCell
                                cell.domainIcon?.image = UIImage(data: data)
                                cell.domainIcon?.backgroundColor = .none
                                cell.layoutIfNeeded()
                            }
                        })
                    }
                } else {
                    print("\(name) -> response: FAILURE")
                    //print(response as? HTTPURLResponse!)
                    DispatchQueue.main.async(execute: { () -> Void in
                        let i = #imageLiteral(resourceName: "no-image-icon")
                        
                        let iconObject = RealmManager.getDomainWithPrimaryKey(name)
                        RealmManager.rewriteSpecificDomain(iconObject!, image: UIImagePNGRepresentation(i)! as NSData)
                        
                        if cell is ListsTableViewCell {
                            let cell = cell as! ListsTableViewCell
                            //let i = #imageLiteral(resourceName: "no-image-icon")
                            cell.domainIcon?.image = i
                            cell.domainIcon?.backgroundColor = .none
                        }
                    })
                }
                
                session.invalidateAndCancel()
                
            }).resume()
        }
    }
    
    
}
