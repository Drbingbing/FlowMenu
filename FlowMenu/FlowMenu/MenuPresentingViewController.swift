//
//  MenuPresentingViewController.swift
//  FlowMenu
//
//  Created by Bing Bing on 2022/10/26.
//

import UIKit

class MenuPresentingViewController: UIPresentationController {
    
    lazy var bubbleView = FlowMenuContainerView(presentedView: presentedViewController.view)
    let dimmedView = MenuDimmedView()
    weak var sourceView: UIView?
    
    var scrollObserver: NSKeyValueObservation?
    
    override func presentationTransitionWillBegin() {
        
        guard let containerView = containerView else { return }
        
        containerView.addSubview(bubbleView)
        observer(sourceView?.superview as? UIScrollView)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        guard let containerView = containerView else { return }
        
        bubbleView.frame = containerView.bounds
    }
    
    deinit {
        scrollObserver?.invalidate()
        scrollObserver = nil
    }
}

extension MenuPresentingViewController {
    
    private func observer(_ scrollView: UIScrollView?) {
        scrollObserver?.invalidate()
        scrollObserver = nil
        scrollObserver = scrollView?.observe(\.contentOffset) { [weak self] _, change in
            self?.presentedViewController.dismiss(animated: true)
        }
    }
}

