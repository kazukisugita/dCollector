
import UIKit

class PullToDismiss: NSObject {
    
    private var targetViewController: ListDetailViewController?
    private var initialMarginTop: CGFloat = 0.0
    public var dismissAnimation: UIViewPropertyAnimator?
    public var reverseAnimation: UIViewPropertyAnimator?
    private var moveDistance: CGFloat = 0.0
    private var toDismiss: Bool = true
    
    override init() {
        super.init()
    }
    
    required init(in viewController: UIViewController) {
        super.init()
        
        if let listDetailViewController = viewController as? ListDetailViewController {
            targetViewController = listDetailViewController
            initialMarginTop = listDetailViewController.domainInfoViewTopConstraint.constant
            moveDistance = UIScreen.main.bounds.height + listDetailViewController.domainInfoViewTopMargin
        }
    }
    
    public func ready() {
        
        guard targetViewController != nil else { return }
        
        dismissAnimation = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: { () in
            
            if let modalPresentationController = self.targetViewController?.presentationController as? ModalPresentationController {
                modalPresentationController.dimmingView.effect = nil
            }
            self.targetViewController?.domainInfoViewTopConstraint.constant += self.moveDistance
            self.targetViewController?.view.layoutIfNeeded()
        })
        dismissAnimation?.addCompletion { (complete) in
            if self.toDismiss {
                self.targetViewController?.dismiss(animated: false, completion: nil)
            } else {
                self.toDismiss = true
                self.targetViewController?.domainInfoViewTopConstraint.constant = self.initialMarginTop
            }
        }
        
        reverseAnimation = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: { () in
            
            if let modalPresentationController = self.targetViewController?.presentationController as? ModalPresentationController {
                modalPresentationController.dimmingView.effect = UIBlurEffect(style: .dark)
            }
            self.targetViewController?.domainInfoViewTopConstraint.constant = (self.targetViewController?.domainInfoViewTopMargin)!
            self.targetViewController?.view.layoutIfNeeded()
        })
    }
    
    public func onFraction(_ value: CGFloat) {
        let val = value / moveDistance
        dismissAnimation?.fractionComplete = val
    }
    
    public func start() {
        ready()
        dismissAnimation?.startAnimation()
    }
    
    public func reverse() {
//        dismissAnimation?.stopAnimation(true)
//        dismissAnimation?.finishAnimation(at: .current)
        toDismiss = false
        dismissAnimation?.isReversed = true
        dismissAnimation?.startAnimation()
    }
}
