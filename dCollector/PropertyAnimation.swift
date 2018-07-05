
import UIKit

class PullToDismiss: NSObject {
    
    private var parentViewController: UIViewController?
    public var dismissAnimation: UIViewPropertyAnimator?
    private var moveDistance: CGFloat = 0.0
    
    override init() {
        super.init()
    }
    
    required init(in viewController: UIViewController) {
        super.init()
        
        parentViewController = viewController
        initSelf()
    }
    
    private func initSelf() {
        
        guard let listDetailViewController = parentViewController as? ListDetailViewController else { return }
        moveDistance = UIScreen.main.bounds.height - listDetailViewController.domainInfoViewTopMargin
        
        dismissAnimation = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1.0, animations: { () in
            
            if let modalPresentationController = listDetailViewController.presentationController as? ModalPresentationController {
                modalPresentationController.dimmingView.effect = nil
            }
            
            listDetailViewController.domainInfoViewTopConstraint.constant += self.moveDistance
            listDetailViewController.view.layoutIfNeeded()
        })
        
        dismissAnimation?.addCompletion({ (complete) in
            listDetailViewController.dismiss(animated: false, completion: nil)
//            self.dismissAnimation?.isReversed = false
        })
    }
    
    public func onFraction(_ value: CGFloat) {
        let val = value / moveDistance
        dismissAnimation?.fractionComplete = val
    }
    
    public func start() {
        dismissAnimation?.startAnimation()
    }
    
    public func end() {
        dismissAnimation?.isReversed = true
        dismissAnimation?.startAnimation()
    }
}
