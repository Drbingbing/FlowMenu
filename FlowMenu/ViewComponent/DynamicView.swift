//
//  DynamicView.swift
//  FlowMenu
//
//  Created by Bing Bing on 2022/11/8.
//

import UIKit

class DynamicView: UIView {
    
    var tapAnimation: Bool = true
    var longPressAnimation: Bool = false
    var onLongPressGesture: (() -> Void)?
    private var didLongPressed = false
    
    var isHighlighted: Bool = false {
        didSet {
            guard isHighlighted != oldValue else { return }
            animated()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isHighlighted = true
        
        if longPressAnimation, tapAnimation {
            UIView.animate(withDuration: 0.2) {
                self.layer.zPosition = 0
                self.transform = .identity.scaledBy(x: 0.96, y: 0.96)
            }
            
            perform(#selector(delayAnimation), with: touches, afterDelay: 0.3)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isHighlighted = false
        
        if longPressAnimation, tapAnimation {
            let animation = {
                self.layer.zPosition = 0
                self.transform = .identity
            }
            UIView.animate(withDuration: 0.2, animations: animation) { _ in
                if self.didLongPressed {
                    self.onLongPressGesture?()
                    self.didLongPressed = false
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isHighlighted = false
        
        if longPressAnimation, tapAnimation {
            let animation = {
                self.layer.zPosition = 0
                self.transform = .identity
            }
            UIView.animate(withDuration: 0.2, animations: animation) { _ in
                if self.didLongPressed {
                    self.onLongPressGesture?()
                    self.didLongPressed = false
                }
            }
        }
    }
    
    private func animated() {
        if tapAnimation, !longPressAnimation {
            var transform = CGAffineTransform.identity
            if isHighlighted { transform = transform.scaledBy(x: 0.96, y: 0.96) }
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                self.transform = transform
            }, completion: nil)
        }
    }
    
    @objc
    private func delayAnimation() {
        if isHighlighted {
            self.transform = .identity
            let animations = {
                self.layer.zPosition = 1
                self.transform = .identity.scaledBy(x: 1.1, y: 1.1)
            }
            UIView.animate(withDuration: 0.2, animations: animations) { didComplete in
                self.didLongPressed = didComplete
            }
        }
    }
}
