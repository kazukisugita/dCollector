//
//  NavigationController.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/06/29.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    let headerView = UIView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        self.navigationBar.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.tintColor = UIColor.black
        self.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
                
        if #available(iOS 11.0, *) {
            self.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.black]
        }
        
//        headerView.transform = __CGAffineTransformMake(1, -0.04, 0, 1, 0, 0)
//        headerView.layer.addSublayer(generateGradientHeader(self.navigationBar))
//        self.navigationBar.insertSubview(headerView, at: 1)
//        self.navigationBar.addSubview(headerView)
        
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        self.navigationBar.addConstraints([
//            NSLayoutConstraint(item: headerView, attribute: .centerY, relatedBy: .equal, toItem: self.navigationBar, attribute: .centerY, multiplier: 1.0, constant: 0)
//        ])
    }
        
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath != "frame" { return }
//        guard let rect = change![NSKeyValueChangeKey.newKey] as? CGRect else { return }
//
//        let heightMin = 44.0 as CGFloat
//        let heightMax = 96.0 as CGFloat
//        let heightDiff = heightMax - heightMin
//        var rate = 0.0 as CGFloat
//
//        if rect.height >= heightMin {
//            let currentDiff = rect.height - heightMin
//            rate = currentDiff / heightDiff
//        } else {
//            return
//        }
//
//        let ty = -75+((heightDiff/2)*rate) as CGFloat
//
//        UIView.performWithoutAnimation { () in
//            self.headerView.transform = __CGAffineTransformMake(1, -0.04*rate, 0, 1, 0, ty)
//        }
//    }
    
//    private func generateGradientHeader(_ view: UIView) -> CAGradientLayer {
//        
//        let gradientLayer = CAGradientLayer()
//        
//        gradientLayer.frame = view.bounds
//        gradientLayer.colors = [
//            UIColor.hexStrRaw(hex: "#21D4FD", alpha: 1.0).cgColor,
//            UIColor.hexStrRaw(hex: "#B721FF", alpha: 1.0).cgColor
//        ]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
//        gradientLayer.shouldRasterize = true
//    
//        return gradientLayer
//    }
}

