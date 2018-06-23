//
//  NavigationController.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/06/29.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
//    let catchImageView = UIImageView(image: UIImage(named: "navigationBackImg"))
    
    let headerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.tintColor = UIColor.black
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
//        self.navigationBar.insertSubview(catchImageView, at: 1)
//
//        self.catchImageView.translatesAutoresizingMaskIntoConstraints = false
//        self.navigationBar.addConstraint(NSLayoutConstraint(item: self.catchImageView, attribute: .centerY, relatedBy: .equal, toItem: self.navigationBar, attribute: .centerY, multiplier: 1.0, constant: -20.0))
        
        let navigationBarRect = self.navigationBar.bounds
        let viewFrame = CGRect(x: 0, y: 0, width: navigationBarRect.width, height: navigationBarRect.height*0.8)
        let view = UIView(frame: viewFrame)
        view.transform = __CGAffineTransformMake(1, -0.04, 0, 1, 0, 0)
        
//        view.layer.addSublayer(generateGradientHeader(view))
//        self.navigationBar.insertSubview(view, at: 1)
        
//        view.translatesAutoresizingMaskIntoConstraints = false
//        self.navigationBar.addConstraint(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self.navigationBar, attribute: .centerY, multiplier: 1.0, constant: -45))
        
        if #available(iOS 11.0, *) {
            self.navigationBar.largeTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
        }
        
        headerView.transform = __CGAffineTransformMake(1, -0.04, 0, 1, 0, 0)
        headerView.layer.addSublayer(generateGradientHeader(self.navigationBar))
        self.navigationBar.insertSubview(headerView, at: 1)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.navigationBar.addConstraints([
//            NSLayoutConstraint(item: headerView, attribute: .top, relatedBy: .equal, toItem: self.navigationBar, attribute: .top, multiplier: 1.0, constant: 0),
//            NSLayoutConstraint(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: self.navigationBar, attribute: .trailing, multiplier: 1.0, constant: 0),
//            NSLayoutConstraint(item: headerView, attribute: .bottom, relatedBy: .equal, toItem: self.navigationBar, attribute: .bottom, multiplier: 1.0, constant: 0),
//            NSLayoutConstraint(item: headerView, attribute: .leading, relatedBy: .equal, toItem: self.navigationBar, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: headerView, attribute: .centerY, relatedBy: .equal, toItem: self.navigationBar, attribute: .centerY, multiplier: 1.0, constant: -(self.navigationBar.bounds.height / 2))
        ])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath != "frame" { return }
        guard let rect = change![NSKeyValueChangeKey.newKey] as? CGRect else { return }
        
        let heightMin = 44.0 as CGFloat
        let heightMax = 96.0 as CGFloat
        let heightDiff = heightMax - heightMin
        var rate = 0.0 as CGFloat
        
        if rect.height >= heightMin {
            let currentDiff = rect.height - heightMin
            rate = currentDiff / heightDiff
        } else {
            return
        }
        
        UIView.animate(withDuration: 0.1, animations: { () in
            self.headerView.transform = __CGAffineTransformMake(1, -0.04*rate, 0, 1, 0, 0)
        })
    }
    
    private func generateGradientHeader(_ view: UIView) -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.hexStrRaw(hex: "#4D98FF", alpha: 1.0).cgColor,
            UIColor.hexStrRaw(hex: "#844DFF", alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.shouldRasterize = true
    
        return gradientLayer
    }
}

