
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
    
    deinit {
        targetViewController = nil
        dismissAnimation = nil
        reverseAnimation = nil
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
        dismissAnimation?.addCompletion { (_) in
            if self.toDismiss {
                self.targetViewController?.dismiss(animated: false, completion: { _ in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "listsViewReload"), object: nil)
                })
            } else {
                self.toDismiss = true // reset
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
    
    public func continueAnimation() {
        dismissAnimation?.continueAnimation(withTimingParameters: nil, durationFactor: 0.3)
    }
    
    public func reverse() {
        toDismiss = false
        dismissAnimation?.isReversed = true
        dismissAnimation?.startAnimation()
    }
}
