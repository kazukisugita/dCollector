//
//  NavigationController.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/06/29.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    let catchImageView = UIImageView(image: UIImage(named: "navigationBackImg"))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let navBar = self.navigationBar
        navBar.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationBar.barTintColor = UIColor.hexStr(type: .navHeader, alpha: 1.0)
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.tintColor = UIColor.black
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.insertSubview(catchImageView, at: 1)
        
        self.catchImageView.translatesAutoresizingMaskIntoConstraints = false
        self.navigationBar.addConstraint(NSLayoutConstraint(item: self.catchImageView, attribute: .centerY, relatedBy: .equal, toItem: self.navigationBar, attribute: .centerY, multiplier: 1.0, constant: -20.0))
        
        if #available(iOS 11.0, *) {
            self.navigationBar.largeTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            debugPrint(change!)
        }
    }
}

