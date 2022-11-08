//
//  FlowMenuTransitionDelegate.swift
//  FlowMenu
//
//  Created by Bing Bing on 2022/10/26.
//

import UIKit

class FlowMenuTransitionDelegate: NSObject {
    
    weak var sourceView: UIView?
    var sourceFrame: CGRect?
    
    static let shared = FlowMenuTransitionDelegate()
}

extension FlowMenuTransitionDelegate: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = MenuPresentingViewController(presentedViewController: presented, presenting: presenting)
        if let sourceView = sourceView {
            sourceFrame = sourceView.superview?.convert(sourceView.frame, to: nil)
            controller.sourceView = sourceView
        }
        
        return controller
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FlowMenuDismissTransitions(sourceFrame: sourceFrame)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FlowMenuPresentTransions(sourceFrame: sourceFrame)
    }
}


extension UIViewController {
    
    func showMenu(sourceView: UIView?, viewController: UIViewController) {
        
        dismiss(animated: false)
        
        FlowMenuTransitionDelegate.shared.sourceView = sourceView
        viewController.modalPresentationStyle = .custom
        viewController.modalPresentationCapturesStatusBarAppearance = true
        viewController.transitioningDelegate = FlowMenuTransitionDelegate.shared
        
        present(viewController, animated: true)
    }
    
}


