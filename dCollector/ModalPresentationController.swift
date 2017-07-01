//
//  MoviePresentationController.swift
//  MovieSelectr
//
//  Created by Training on 10/10/2016.
//  Copyright © 2016 Training. All rights reserved.
//

import UIKit

class ModalPresentationController: UIPresentationController, UIAdaptivePresentationControllerDelegate{
    
    var dimmingView = UIVisualEffectView()
    
    override var shouldPresentInFullscreen: Bool {
        return true
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {
        
        super.presentationTransitionWillBegin()
        dimmingView.setNeedsLayout()
        
        dimmingView.frame = self.containerView!.bounds
        containerView?.insertSubview(dimmingView, at: 0)
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (context:UIViewControllerTransitionCoordinatorContext) in
                self.dimmingView.effect = UIBlurEffect(style: .dark)
            }, completion: nil)
        }else{
        }
    }
    
    override func dismissalTransitionWillBegin() {
    
        super.dismissalTransitionWillBegin()
        dimmingView.setNeedsLayout()
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (context:UIViewControllerTransitionCoordinatorContext) in
                self.dimmingView.effect = nil
            }, completion: { _ in
                self.dimmingView.removeFromSuperview()
            })
        }else{
            dimmingView.removeFromSuperview()
        }
    }
    
    override func containerViewWillLayoutSubviews() {
       
        super.containerViewWillLayoutSubviews()
        
        if let containerBounds = containerView?.bounds {
            //dimmingView.frame = containerBounds
            //presentedView?.frame = containerBounds
        }
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overFullScreen
    }
    
}
