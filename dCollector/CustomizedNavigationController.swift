
import UIKit

class CustomizedNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        self.navigationBar.tintColor = UIColor.black
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
    }
}
