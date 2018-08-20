
import Foundation
import RealmSwift

class RealmService {
    
    static let realm: Realm = try! Realm()
    
    static func getAllDomain() -> Results<Domain> {
        return realm.objects(Domain.self).sorted(byKeyPath: "title", ascending: true)
    }
    
    static func getDomainByName(_ name: String) -> Domain? {
        let predicate = NSPredicate(format: "name = %@", "\(name)")
        return realm.objects(Domain.self).filter(predicate).first
    }

    static func getAllUrl() -> Results<Url> {
        return realm.objects(Url.self)
    }
    
    static func addToDomain(_ domain: Domain, _ url: Url) {
        do {
            try realm.write {
                domain.urls.append(url)
                realm.add(domain, update: true)
            }
        } catch {
            print(error)
        }
    }
    
    static func rewriteSpecificDomain(_ object: Domain, image: NSData) {
        do {
            try realm.write {
                object.icon = image
            }
        } catch {
            print(error)
        }
    }
    
    static func rewriteSpecificDomainIconPath(_ object: Domain, str: String) {
        do {
            try realm.write {
                object.iconPath = str
            }
        } catch {
            print(error)
        }
    }
    
    static func rewriteSpecificDomainSiteDescription(_ object: Domain, str: String) {
        do {
            try realm.write {
                object.siteDescription = str
            }
        } catch {
            print(error)
        }
    }
    
    static func rewriteSpecificDomainTitle(_ object: Domain, str: String) {
        do {
            try realm.write {
                object.title = str
            }
        } catch {
            print(error)
        }
    }

    static func addToUrl(_ url: Url) {
        do {
            try realm.write {
                realm.add(url, update: true)
            }
        } catch {
            print(error)
        }
    }
    
    static func getDomainWithPrimaryKey(_ str: String) -> Domain? {
        let domain = realm.object(ofType: Domain.self, forPrimaryKey: str)
        return domain
    }
    
    static func getUrlWithPrimaryKey(_ str: String) -> Url? {
        let object = realm.object(ofType: Url.self, forPrimaryKey: str)
        return object
    }
    
    static func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    static func deleteDomain(domain: Domain) {
        do {
            try realm.write {
                realm.delete(domain.urls)
                realm.delete(domain)
            }
        } catch {
            print(error)
        }
    }
    
    static func deleteUrl(url: Url) {
        do {
            try realm.write {
                realm.delete(url)
            }
        } catch {
            print(error)
        }
    }
    
}
