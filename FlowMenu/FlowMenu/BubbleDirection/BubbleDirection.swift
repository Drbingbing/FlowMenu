//
//  BubbleDirection.swift
//  FlowMenu
//
//  Created by Bing Bing on 2022/10/25.
//

import Foundation

enum BubbleDirection {
    
    case top
    case bottom
    
    static func direction(from fromRect: CGRect, in container: CGRect) -> BubbleDirection {
        
        let y = fromRect.minY - 64
        if y - container.minY <= 80 {
            return .top
        }
        
        return .bottom
    }
}
