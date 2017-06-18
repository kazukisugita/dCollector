//
//  MovieTransitioner.swift
//  MovieSelectr
//
//  Created by Training on 10/10/2016.
//  Copyright © 2016 Training. All rights reserved.
//

import UIKit

class ModalAnimatedTransitoning: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresentation = false
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from)
        let fromView = fromVC!.view
        
        let toVC = transitionContext.viewController(forKey: .to)
        let toView = toVC!.view
        
        let containerView = transitionContext.containerView
        
        if isPresentation {
            containerView.addSubview(toView!)
        }
        
        let animatingVC = isPresentation ? toVC : fromVC
        
        let animatingView = animatingVC!.view
        
        let appearedFrame = transitionContext.finalFrame(for: animatingVC!)
        var dismissedFrame = appearedFrame
        
        dismissedFrame.origin.y += dismissedFrame.size.height
        
        let initialFrame = isPresentation ? dismissedFrame : appearedFrame
        let finalFrame = isPresentation ? appearedFrame : dismissedFrame
        
        animatingView?.frame = initialFrame
        
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseOut], animations: {
            animatingView?.frame = finalFrame
            
            if !self.isPresentation {
                //animatingView?.alpha = 0
            }
            
        }) { (success:Bool) in
            if !self.isPresentation {
                fromView?.removeFromSuperview()
            }
            
            transitionContext.completeTransition(true)
        }
        
    }
    
}


class ModalTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentationController = ModalPresentationController(presentedViewController: presented, presenting: presenting)
        
        return presentationController
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = ModalAnimatedTransitoning()
        animationController.isPresentation = true
        
        return animationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = ModalAnimatedTransitoning()
        animationController.isPresentation = false
        
        return animationController
    }
    
    
}



