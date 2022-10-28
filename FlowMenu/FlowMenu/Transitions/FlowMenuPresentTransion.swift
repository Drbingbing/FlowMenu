//
//  FlowMenuPresentTransion.swift
//  FlowMenu
//
//  Created by Bing Bing on 2022/10/24.
//

import UIKit

final class FlowMenuPresentTransions: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        
        let menuContainerView = transitionContext.containerView.menuContainer
        menuContainerView?.sourceFrame = sourceFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        containerView.frame = calculateContainerFrame(for: fromViewController.view.bounds)
        
        let direction = BubbleDirection.direction(from: sourceFrame ?? .zero, in: fromViewController.view.bounds)
        containerView.anchorPoint = direction == .top ? CGPoint(x: 0.5, y: 0) : CGPoint(x: 0.5, y: 1)
        containerView.transform = .identity.scaledBy(x: 0.25, y: 0.2)
        containerView.alpha = 0
        
        let animations = {
            toViewController.view.layer.cornerRadius = 10
            containerView.transform = CGAffineTransform.identity
            containerView.alpha = 1
        }
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options:  [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState], animations: animations) { didComplete in
            transitionContext.completeTransition(didComplete)
        }
    }
    
    private func calculateContainerFrame(for bounds: CGRect) -> CGRect {
        guard let sourceFrame = sourceFrame else { return .zero }
        
        let direction = BubbleDirection.direction(from: sourceFrame, in: bounds)
        
        let height: CGFloat = 48
        let width = max(sourceFrame.width, 250)
        
        var rect: CGRect
        switch direction {
        case .top:
            rect = CGRect(x: sourceFrame.minX, y: sourceFrame.maxY - 12, width: width, height: height)
        case .bottom:
            rect = CGRect(x: sourceFrame.minX, y: sourceFrame.minY - height + 12, width: width, height: height)
        }
        
        if abs(rect.maxX - bounds.maxX) <= width - sourceFrame.width {
            rect = rect.offsetBy(dx: -(width - sourceFrame.width), dy: 0)
        }
        
        return rect
    }
}
