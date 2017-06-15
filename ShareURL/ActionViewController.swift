//
//  ActionViewController.swift
//  ShareURL
//
//  Created by Kazuki Sugita on 2017/05/02.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    
    @IBOutlet weak var webview: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
//        let inputItem: NSExtensionItem = self.extensionContext?.inputItems[0] as! NSExtensionItem
//        let itemProvider = inputItem.attachments![0] as! NSItemProvider
//        
//        // Safari 経由での shareExtension では URL を取得
//        if (itemProvider.hasItemConformingToTypeIdentifier("public.url")) {
//            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: {
//                (item, error) in
//                
//                // item に url が入っている
//                let itemNSURL: NSURL = item as! NSURL
//                print(itemNSURL)
//                
//                // 行いたい処理を書く
//            })
//        }
//        
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
        
        dismiss(animated: true, completion: nil)
    }

}
