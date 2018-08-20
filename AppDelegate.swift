
import UIKit
import SVProgressHUD
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var transactionFailUrls: String?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        SVProgressHUD.setDefaultMaskType(.clear)
        
        window = UIWindow()
        let navigationController = CustomizedNavigationController()
        navigationController.viewControllers = [ListsViewController()]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

