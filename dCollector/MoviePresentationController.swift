//
//  MoviePresentationController.swift
//  MovieSelectr
//
//  Created by Training on 10/10/2016.
//  Copyright © 2016 Training. All rights reserved.
//

import UIKit

class MoviePresentationController: UIPresentationController, UIAdaptivePresentationControllerDelegate{
    
    var dimmingView = UIVisualEffectView()
    
    override var shouldPresentInFullscreen: Bool {
        return true
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        //dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        //dimmingView.alpha = 0
    }
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = self.containerView!.bounds
        //dimmingView.alpha = 0
        containerView?.insertSubview(dimmingView, at: 0)
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (context:UIViewControllerTransitionCoordinatorContext) in
                //self.dimmingView.alpha = 1
                self.dimmingView.effect = UIBlurEffect(style: .dark)
            }, completion: nil)
        }else{
            //dimmingView.alpha = 1
        }
        
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (context:UIViewControllerTransitionCoordinatorContext) in
                //self.dimmingView.alpha = 0
                self.dimmingView.effect = nil
            }, completion: nil)
        }else{
            //dimmingView.alpha = 0
            dimmingView.removeFromSuperview()
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        if let containerBounds = containerView?.bounds {
            dimmingView.frame = containerBounds
            presentedView?.frame = containerBounds
        }
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overFullScreen
    }
    
}
