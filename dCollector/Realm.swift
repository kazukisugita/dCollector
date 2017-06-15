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
    dynamic var url: String = ""
    dynamic var path: String = ""
    dynamic var title: String? = nil
    dynamic var createdAt: Date = Date()
    dynamic var domain: Domain?
    
    override static func primaryKey() -> String? {
        return "url"
    }
}

final class Domain: Object {
    dynamic var name: String = ""
    dynamic var title: String? = nil
    dynamic var icon: NSData? = nil
    dynamic var iconPath: String? = nil
    dynamic var siteDescription: String? = nil
    let urls = List<Url>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
