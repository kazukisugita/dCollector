
import UIKit

class PullToDismissService: NSObject {
    
    private var targetViewController: ListDetailViewController?
    private var initialMarginTop: CGFloat = 0.0
    public var dismissAnimation: UIViewPropertyAnimator?
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
    }
    
    public func ready() {
        
        guard let _targetViewController = targetViewController else { return }
        
        dismissAnimation = UIViewPropertyAnimator(duration: 0.4, curve: .easeOut) {
            
            if let modalPresentationController = _targetViewController.presentationController as? ModalPresentationController {
                modalPresentationController.dimmingView.effect = nil
                _targetViewController.domainInfoView.layer.cornerRadius = 0.0
                _targetViewController.closeButton.transform = __CGAffineTransformMake(0.5, 0, 0, 0.5, 0, 0)
            }
            _targetViewController.domainInfoViewTopConstraint.constant += self.moveDistance
            _targetViewController.view.layoutIfNeeded()
        }
        dismissAnimation?.addCompletion { _ in
            if self.toDismiss {
                _targetViewController.dismiss(animated: false) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "listsViewReload"), object: nil)
                }
            } else {
                self.toDismiss = true // reset
                _targetViewController.domainInfoViewTopConstraint.constant = self.initialMarginTop
            }
        }
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
        dismissAnimation?.continueAnimation(withTimingParameters: nil, durationFactor: 0.4)
    }
    
    public func reverse() {
        toDismiss = false
        dismissAnimation?.isReversed = true
        dismissAnimation?.startAnimation()
    }
}
