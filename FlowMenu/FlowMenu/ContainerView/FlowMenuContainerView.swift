//
//  FlowMenuContainerView.swift
//  FlowMenu
//
//  Created by Bing Bing on 2022/10/25.
//

import UIKit
import CollectionKit


class FlowMenuContainerView: UIView {
    
    let bubble = CAShapeLayer()
    var sourceFrame: CGRect?
    var presentedView: UIView?
    
    init(presentedView: UIView) {
        super.init(frame: .zero)
        layer.addSublayer(bubble)
        addSubview(presentedView)
        bubble.fillColor = nil
        bubble.strokeEnd = 1
        bubble.fillColor = presentedView.backgroundColor?.cgColor ?? UIColor.white.cgColor
        bubble.strokeColor = presentedView.backgroundColor?.cgColor ?? UIColor.white.cgColor
        bubble.opacity = 1
        bubble.lineCap = .round
        bubble.lineJoin = .round
        defaultShadow()
        
        self.presentedView = presentedView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bubble.frame = bounds
        presentedView?.frame = bounds
        bubble.path = bubblePath().cgPath
    }
    
    
    private func bubblePath() -> UIBezierPath {
        guard let sourceFrame = sourceFrame else {
            return UIBezierPath(roundedRect: bounds, cornerRadius: 10)
        }
                
        let direction = BubbleDirection.direction(from: sourceFrame, in: bounds)
        let path = UIBezierPath()
        
        let anchorOffset = superview!.frame.midX - sourceFrame.midX
        let width = bounds.width
        let cornerRadius: CGFloat = 10
        let triangleWidth: CGFloat = 6
        let height = bounds.height
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let tr = CGPoint(x: width, y: 0)
        let br = CGPoint(x: width, y: height)
        let bl = CGPoint(x: 0, y: height)
        let tl = CGPoint(x: 0, y: 0)
        
        let startX = direction == .top ? center.x - anchorOffset : center.x
        let startY = direction == .top ? center.y - height / 2 - triangleWidth : center.y - height / 2
        
        path.move(to: CGPoint(x: startX, y: startY))
        
        switch direction {
        case .top:
            
            path.addLine(to: CGPoint(x: startX + triangleWidth, y: startY + triangleWidth))
            path.addLine(to: CGPoint(x: tr.x - cornerRadius, y: tr.y))
            path.addQuadCurve(to: CGPoint(x: tr.x, y: tr.y + cornerRadius), controlPoint: tr)
            path.addLine(to: CGPoint(x: br.x, y: br.y - cornerRadius))
            path.addQuadCurve(to: CGPoint(x: br.x - cornerRadius, y: br.y), controlPoint: br)
            path.addLine(to: CGPoint(x: bl.x + cornerRadius, y: bl.y))
            path.addQuadCurve(to: CGPoint(x: bl.x, y: bl.y - cornerRadius), controlPoint: bl)
            path.addLine(to: CGPoint(x: tl.x, y: tl.y + cornerRadius))
            path.addQuadCurve(to: CGPoint(x: tl.x + cornerRadius, y: tl.y), controlPoint: tl)
            path.addLine(to: CGPoint(x: startX - triangleWidth, y: startY + triangleWidth))
            path.addLine(to: CGPoint(x: startX, y: startY))
            
        case .bottom:
            
            let trianglePoint = CGPoint(x: center.x - anchorOffset, y: center.y + height / 2 + triangleWidth)
            
            path.addLine(to: CGPoint(x: tr.x - cornerRadius, y: tr.y))
            path.addQuadCurve(to: CGPoint(x: tr.x, y: tr.y + cornerRadius), controlPoint: tr)
            path.addLine(to: CGPoint(x: br.x, y: br.y - cornerRadius))
            path.addQuadCurve(to: CGPoint(x: br.x - cornerRadius, y: br.y), controlPoint: br)
            path.addLine(to: CGPoint(x: trianglePoint.x + triangleWidth, y: trianglePoint.y - triangleWidth))
            path.addLine(to: CGPoint(x: trianglePoint.x, y: trianglePoint.y))
            path.addLine(to: CGPoint(x: trianglePoint.x - triangleWidth, y: trianglePoint.y - triangleWidth))
            path.addLine(to: CGPoint(x: bl.x + cornerRadius, y: bl.y))
            path.addQuadCurve(to: CGPoint(x: bl.x, y: bl.y - cornerRadius), controlPoint: bl)
            path.addLine(to: CGPoint(x: tl.x, y: tl.y + cornerRadius))
            path.addQuadCurve(to: CGPoint(x: tl.x + cornerRadius, y: tl.y), controlPoint: tl)
            path.addLine(to: CGPoint(x: startX, y: startY))
        }
        return path
    }
    
}


extension UIView {
    
    var menuContainer: FlowMenuContainerView? {
        return subviews.first(where: { view -> Bool in
            view is FlowMenuContainerView
        }) as? FlowMenuContainerView
    }
}
