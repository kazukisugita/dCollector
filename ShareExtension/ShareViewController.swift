
import UIKit
import MobileCoreServices

final class ShareViewController: UIViewController {
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet var innerView: UIView!
    
    let innerViewWidth = (initial: CGFloat(60.0), appeared: CGFloat(180.0))
    var innerViewBottomConstraint: NSLayoutConstraint!
    
    let messageWidth = (initial: CGFloat(0.0), appeared: CGFloat(116.0))
    
    var shareString: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.view.isOpaque = false
        
        getExtensionContext()
        customization()
        animate()
    }
    
    private func animate() {
        UIView.animate(withDuration: 0.4, delay: 1.0, options: .curveEaseOut, animations: {
            self.innerView.transform = __CGAffineTransformMake(0.2, 0.0, 0.0, 0.2, 0.0, 20.0)
            self.innerView.alpha = 0.0
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
                
                itemProvider.loadItem(forTypeIdentifier: puclicURL, options: nil, completionHandler: { item, error in
                    
                    if let url = item as? NSURL {
                        let url_str = url.absoluteString!
                        print("url_str: \(url_str)")
                        let defaults = UserDefaults(suiteName: AppGroup.suiteName)!
                        
                        // 既存の確認
                        if let arrayObject = defaults.object(forKey: AppGroup.keyName) as? Array<String> {
                            self.shareString = arrayObject
                            
                            // 新規とUserDefaults内の重複を確認
                            for object in arrayObject {
                                if object == url_str {
                                    DispatchQueue.main.async {
                                        self.message.text = "Already Have"
                                        self.innerView.layoutIfNeeded()
                                    }
                                    return
                                }
                            }
                            
                            self.shareString.append(url_str)
                            defaults.set(self.shareString, forKey: AppGroup.keyName)
                            
                            DispatchQueue.main.async { self.message.text = "Success" }
                            
                        } else {
                            // ひとつめの格納
                            self.shareString.append(url_str)
                            defaults.set(self.shareString, forKey: AppGroup.keyName)
                            
                            DispatchQueue.main.async { self.message.text = "Success" }
                        }
                        
                    } else { DispatchQueue.main.async {
                        self.message.text = "Failure"
                    }}
                })
            }
            
        }
    }
    
}


extension ShareViewController {
    
    func customization() {
        self.view.addSubview(self.innerView)
        
        self.innerView.center = self.view.center
        self.innerView.layer.cornerRadius = 8
        self.innerView.frame.size.width = self.innerViewWidth.appeared
    
        self.view.layoutIfNeeded()
    }
    
}
