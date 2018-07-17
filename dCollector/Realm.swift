//
//  collection.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/05/09.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import Foundation
import RealmSwift

final class Url: Object {
    @objc dynamic var url: String = ""
    @objc dynamic var path: String = ""
    @objc dynamic var title: String? = nil
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var domain: Domain?
    
    override static func primaryKey() -> String? {
        return "url"
    }
}

final class Domain: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var title: String? = nil
    @objc dynamic var icon: NSData? = nil
    @objc dynamic var iconPath: String? = nil
    @objc dynamic var siteDescription: String? = nil
    let urls = List<Url>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
