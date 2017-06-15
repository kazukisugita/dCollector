//
//  TabBarController.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/05/12.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        print(" **** TabBarController **** ")
        
        let items = self.tabBar.items!
        for item in items {
//            debugPrint(item)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        print(item.tag)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        debugPrint(" **** tabBarController didSelect **** ")
//        debugPrint(tabBarController.selectedIndex)
        
//        debugPrint(viewController)
    }

}
