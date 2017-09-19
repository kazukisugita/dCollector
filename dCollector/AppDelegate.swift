//
//  AppDelegate.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/05/02.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var transactionFailUrls: String?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /*
        let realmConfig = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                }
        })
        Realm.Configuration.defaultConfiguration = realmConfig
        */
        RealmManager.getRealmAbsoluteFilePath()
        
        FIRApp.configure()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //print(" *** applicationDidEnterBackground *** ")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        //print(" *** applicationDidBecomeActive ***")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "listsViewReload"), object: nil)

        //Transaction.fromUserdefaultsfToRealm()
        
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "applicationDidBecomeActiveNotification"), object: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        //print(" *** applicationWillTerminate *** ")
    }

}

