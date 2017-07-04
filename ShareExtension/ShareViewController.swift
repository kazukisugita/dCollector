//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Kazuki Sugita on 2017/05/02.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit
//import Social
import MobileCoreServices

final class ShareViewController: UIViewController {
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet var innerView: UIView!
    
    let innerViewWidth = (initial: CGFloat(60.0), appeared: CGFloat(180.0))
    var innerViewBottomConstraint: NSLayoutConstraint!
    
    let messageWidth = (initial: CGFloat(0.0), appeared: CGFloat(116.0))
    
    var shareString: Array<String> = []
    
    override func viewDidLoad() {
        print("*** ShareViewController loaded ***")
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.view.isOpaque = false
        
        getExtensionContext()
        
        customization()
        
        appearAnimation()
    
        
    }
    
    private func appearAnimation() {
        
        self.view.setNeedsLayout()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.innerView.frame.size.width = self.innerViewWidth.appeared
            self.message.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.disappearAnimation()
        })
        
    }
    
    private func disappearAnimation() {
        
        UIView.animate(withDuration: 0.3, delay: 0.8, options: .curveEaseOut, animations: {
            self.innerView.frame.size.width = self.innerViewWidth.initial
            self.message.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.completeRequest()
        })
        
    }
    
    private func completeRequest() {
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    func getExtensionContext() {
        
        let extensionItem: NSExtensionItem = self.extensionContext?.inputItems.first as! NSExtensionItem
        let itemProviders = extensionItem.attachments as! [NSItemProvider]
        let puclicURL = String(kUTTypeURL)  // "public.url"
        
        for itemProvider in itemProviders {
            
            if itemProvider.hasItemConformingToTypeIdentifier(puclicURL) {
                
                itemProvider.loadItem(forTypeIdentifier: puclicURL, options: nil, completionHandler: { (item, error) in
                    
                    if let url: NSURL = item as? NSURL {
                        let url_str = url.absoluteString!
                        print("url_str: \(url_str)")
                        
                        let defaults = UserDefaults(suiteName: AppGroup.suiteName)!
                        
                        // 既存の確認
                        if let arrayObject = defaults.object(forKey: AppGroup.keyName) as? Array<String> {
                            self.shareString = arrayObject
                            
                            // 新規とUserDefaults内の重複を確認
                            for object in arrayObject {
                                if object == url_str {
                                    //self.shareString.append(url_str)
                                    //defaults.set(self.shareString, forKey: AppGroup.keyName)
                                    self.message.text = "Already Have"
                                    return
                                }
                            }
                            
                            self.shareString.append(url_str)
                            defaults.set(self.shareString, forKey: AppGroup.keyName)
                            
                            if url_str.hasPrefix("https") {
                                self.message.text = "   Success"
                            } else {
                                //self.message.text = "HTTP might fail"
                                self.message.text = "   Success"
                            }
                        } else {
                            // ひとつめの格納
                            self.shareString.append(url_str)
                            defaults.set(self.shareString, forKey: AppGroup.keyName)
                            if url_str.hasPrefix("https") {
                                self.message.text = "   Success"
                            } else {
                                //self.message.text = "HTTP might fail"
                                self.message.text = "   Success"
                            }
                        }
                        
                        AppGroup.tryGetData()
                    } else {
                        self.message.text = "   Failure"
                    }
                })
            } else {
                self.message.text = "   Failure"
            }
            
        }
    }
    
    
}


extension ShareViewController {
    
    func customization() {
        self.view.addSubview(self.innerView)
        
        self.innerView.center = self.view.center
        self.innerView.layer.cornerRadius = 8
        self.innerView.frame.size.width = self.innerViewWidth.initial
        
        self.message.alpha = 0.0
    }
    
}
