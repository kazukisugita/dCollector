//
//  RealmManager.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/05/09.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmManager {
    
    static let realm: Realm = try! Realm()
    
    static func getRealmAbsoluteFilePath() {
        //debugPrint(realm.configuration.fileURL!.absoluteString)
    }
    
    static func getAllDomain() -> Results<Domain> {
        //return realm.objects(Domain.self)
        return realm.objects(Domain.self).sorted(byKeyPath: "title", ascending: true)
    }
    
    static func getDomainByName(_ name: String) -> Domain? {
        let predicate = NSPredicate(format: "name = %@", "\(name)")
        return realm.objects(Domain.self).filter(predicate).first
    }
    /*
    static func getDomainByDisplayOrder(_ order: Int) -> Domain? {
        let predicate = NSPredicate(format: "displayOrder = %@", "\(order)")
        return realm.objects(Domain.self).filter(predicate).first
    }
    
    static func getAllDomainSortedByDisplayOrder() -> Results<Domain> {
        return realm.objects(Domain.self).sorted(byKeyPath: "displayOrder")
    }
    */
    static func getAllUrl() -> Results<Url> {
        return realm.objects(Url.self)
    }
    
    // set Domain's displayOrder
    /*
    static func setDomainDisplayOrder(_ domain: Domain, _ num: Int) {
        do {
            try realm.write {
                domain.displayOrder = num
                realm.add(domain, update: true)
            }
        }
        catch _ {
            //TODO: error処理
            print("ERROR: setDomainDisplayOrder")
        }
    }
    */
    // Domain　に追加
    static func addToDomain(_ domain: Domain, _ url: Url) {
        do {
            try realm.write {
                
                domain.urls.append(url)
                
                //print("addToDomain: \(domain)")
                
                realm.add(domain, update: true)
            }
        }
        catch _ {
            //TODO: error処理
            print("ERROR: add To Domain")
        }
    }
    
    // 特定の Domainを更新
    static func rewriteSpecificDomain(_ object: Domain, image: NSData) {
        do {
            try realm.write {
                object.icon = image
            }
        }
        catch _ {
            //TODO: error処理
            print("ERROR: rewrite Specific Domain")
        }
        print(" *** rewriteSpecificDomain *** ")
    }
    
    static func rewriteSpecificDomainIconPath(_ object: Domain, str: String) {
        do {
            try realm.write {
                object.iconPath = str
            }
        }
        catch _ {
            //TODO: error処理
            print("ERROR: rewrite Specific Domain IconPath")
        }
        print(" *** rewriteSpecificDomainIconPath *** ")
    }
    
    static func rewriteSpecificDomainSiteDescription(_ object: Domain, str: String) {
        do {
            try realm.write {
                object.siteDescription = str
            }
        }
        catch _ {
            //TODO: error処理
            print("ERROR: rewrite Specific Domain SiteDescription")
        }
        print(" *** rewriteSpecificDomain SiteDescription *** ")
    }
    
    static func rewriteSpecificDomainTitle(_ object: Domain, str: String) {
        do {
            try realm.write {
                object.title = str
            }
        }
        catch _ {
            //TODO: error処理
            print("ERROR: rewrite Specific Domain Title")
        }
        print(" *** rewriteSpecificDomain Title *** ")
    }

    
    // Url　に追加
    static func addToUrl(_ url: Url) {
        do {
            try realm.write {
                realm.add(url, update: true)
            }
        }
        catch _ {
            //TODO: error処理
            print("ERROR: add To Url")
        }
    }
    
    // Domain　をPrimaryKeyで返す
    static func getDomainWithPrimaryKey(_ str: String) -> Domain? {
        if let domain = realm.object(ofType: Domain.self, forPrimaryKey: str) {
            return domain
        } else {
            return nil
        }
    }
    
    // Url　をPrimaryKeyで返す
    static func getUrlWithPrimaryKey(_ str: String) -> Url? {
        if let object = realm.object(ofType: Url.self, forPrimaryKey: str) {
            return object
        } else {
            return nil
        }
    }
    
    // ALL DELETE !!
    static func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    // Delete Domain and related urls
    static func deleteDomain(domain: Domain) {
        do {
            try realm.write {
                realm.delete(domain.urls)
                realm.delete(domain)
            }
        }
        catch {
        }
    }
    
    // Delete Url
    static func deleteUrl(url: Url) {
        do {
            try realm.write {
                realm.delete(url)
            }
        }
        catch {
        }
    }
    
}
