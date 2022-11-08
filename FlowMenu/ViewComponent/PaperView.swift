//
//  PaperView.swift
//  FlowMenu
//
//  Created by Bing Bing on 2022/11/8.
//

import UIKit
import CollectionKit

class PaperView: DynamicView {
    
    let collectionView = CollectionView()
    let signLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        addSubview(signLabel)
        collectionView.isUserInteractionEnabled = false
        longPressAnimation = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = signLabel.frame.size
        signLabel.frame.origin = CGPoint(x: bounds.maxX - size.width - 8, y: bounds.maxY - size.height - 8)
        collectionView.frame = bounds
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
        layer.zPosition = isHighlighted ? 1 : 0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = isHighlighted ? 0.5 : 0.15
        layer.shadowRadius = isHighlighted ? 4 : 2
    }
    
    func populate(for mockData: MockData) {
        let titleProvider = LabelProvider(text: mockData.title, color: mockData.tintColor, font: .rounded(ofSize: 16, weight: .bold))
        let contentProvider = LabelProvider(text: mockData.content, font: .rounded(ofSize: 8))
        let contentProvider2 = LabelProvider(text: mockData.subtitle, color: mockData.tintColor, font: .rounded(ofSize: 10, weight: .medium))
        let timeProvider = LabelProvider(text: mockData.time, color: .systemGray, font: .rounded(ofSize: 14))
        
        collectionView.provider = ComposedProvider(
            layout: FlowLayout(spacing: 8).inset(by: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)),
            sections: [
                titleProvider,
                contentProvider2,
                timeProvider,
                SeperatorProvider(),
                contentProvider,
            ]
        )
        
        signLabel.text = mockData.body1
        signLabel.font = .rounded(ofSize: 8, weight: .medium)
        signLabel.textColor = .systemGray3
        let labelSize = (mockData.body1 ?? "").boundingRect(with: bounds.size, options: .usesLineFragmentOrigin,
                                                            attributes: [NSAttributedString.Key.font: UIFont.rounded(ofSize: 8, weight: .medium)], context: nil)
        signLabel.frame.size = labelSize.size
    }
}
