//
//  DimmedView.swift
//  FlowMenu
//
//  Created by Bing Bing on 2022/10/26.
//

import UIKit

class MenuDimmedView: UIView {
    
    var didTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let didTap = didTap {
            didTap()
            self.didTap = nil
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if let didTap = didTap {
            didTap()
            self.didTap = nil
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        super.hitTest(point, with: event)
    }
}
