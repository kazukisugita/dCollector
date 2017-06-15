//
//  BrowserViewController.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/05/04.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit
import WebKit

final class BrowserViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var urlToCollection: String?
    @IBOutlet weak var collectButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.webView = WKWebView(frame: CGRect(x: 0, y: statusBarHeight(), width: view.bounds.size.width, height: view.bounds.size.height - reduceViewHeight() ))
        self.webView.navigationDelegate = self
        self.webView.allowsBackForwardNavigationGestures = true
        
        self.webView.addSubview(collectButton)
        self.view.addSubview(webView)
        
        customization()

        let url = NSURL(string:"https://www.google.co.jp")
        let req = URLRequest(url: url! as URL)
        self.webView.load(req)
        
        self.view.backgroundColor = .gray
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func statusBarHeight() -> CGFloat {
        return  UIApplication.shared.statusBarFrame.height
    }
    
    func reduceViewHeight() -> CGFloat {
        return UITabBarController().tabBar.frame.size.height + statusBarHeight()
//        return tabBarController.tabBar.frame.size.height
    }
    
    @IBAction func collectAction(_ sender: Any) {
        
        var isSuccess: Bool = false
        
        if let url = self.webView.url as NSURL? {
            debugPrint(url.absoluteString!)
            
            isSuccess = true
            urlToCollection = url.absoluteString!
            
//            print(urlToCollection)
            
        }
        
        callAlert(isSuccess: isSuccess)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BrowserViewController {
    
    func customization() {

        self.collectButton.centerXAnchor.constraint(equalTo: self.webView.centerXAnchor).isActive = true
        let centerYConstraint = NSLayoutConstraint(item: self.collectButton, attribute: .centerY, relatedBy: .equal, toItem: self.webView, attribute: .centerY, multiplier: 1.88, constant: 0.0)
        
        self.webView.addConstraint(centerYConstraint)

//        self.innerViewBottomConstraint = NSLayoutConstraint.init(item: self.innerView, attribute: .bottom, relatedBy: .equal, toItem: self.viewattribute: .bottom, multiplier: 1, constant: 0)
    }
    
    func callAlert(isSuccess success: Bool) {
        
        var title :String
        var message: String
        
        if (success) {
            title = "Collect??"
            message = ""
        } else {
            title = "Error"
            message = "Couldn't get URL"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            print("OK")
            
            AppGroup.setDataToUserDefaults(url: self.urlToCollection!)
            
            AppGroup.tryGetData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("Cancel")
        }
        
        alert.addAction(okAction)
        if (success) { alert.addAction(cancelAction) }
        
        present(alert, animated: true, completion: nil)

    }
}
