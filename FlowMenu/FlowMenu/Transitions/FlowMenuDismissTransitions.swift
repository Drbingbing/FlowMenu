//
//  FlowMenuDismissTransitions.swift
//  FlowMenu
//
//  Created by Bing Bing on 2022/10/24.
//

import UIKit

class FlowMenuDismissTransitions: NSObject, UIViewControllerAnimatedTransitioning {
    
    let sourceFrame: CGRect?
    
    init(sourceFrame: CGRect?) {
        self.sourceFrame = sourceFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        let animationDuration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        
        let direction = BubbleDirection.direction(from: sourceFrame ?? .zero, in: toViewController.view.bounds)
        containerView.anchorPoint = direction == .top ? CGPoint(x: 0.5, y: 0) : CGPoint(x: 0.5, y: 1)
        
        let transform = CGAffineTransform.identity.scaledBy(x: 0.25, y: 0.2)
        containerView.transform = .identity
        containerView.alpha = 1
        
        let animations = {
            containerView.transform = transform
            containerView.alpha = 0
        }
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options:  [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState], animations: animations) { didComplete in
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(didComplete)
        }
    }
}
