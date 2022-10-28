//
//  ViewController.swift
//  FlowMenu
//
//  Created by Bing Bing on 2022/10/24.
//

import UIKit
import CollectionKit

extension UIView {
    func styleColor(_ tintColor: UIColor) {
        self.layer.borderWidth = 2
        self.layer.borderColor = tintColor.withAlphaComponent(0.5).cgColor
        self.layer.cornerRadius = 8
        
        self.backgroundColor = .white
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.isOpaque = true
    }
    
    func defaultShadow(radius: CGFloat = 2, opacity: Float = 0.15, size: CGFloat = 2) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}

extension UIFont {
    class func rounded(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        if let des = font.fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: des, size: size)
        }
        return font
    }
}

class LabelProvider: SimpleViewProvider {
    
    init(text: String,
         color: UIColor = .label,
         font: UIFont = .rounded(ofSize: 16),
         numverOfLines: Int = 0,
         inset: UIEdgeInsets = .zero,
         tapHandler: TapHandler? = nil) {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = font
        label.numberOfLines = numverOfLines
        super.init(views: [label],
                   sizeSource: SimpleViewSizeSource(sizeStrategy: (.fill, .fit)),
                   layout: inset == .zero ? FlowLayout() : FlowLayout().inset(by: inset),
                   tapHandler: tapHandler)
    }
}

class SeperatorProvider: SimpleViewProvider {
    
    init(color: UIColor = .systemGroupedBackground, inset: UIEdgeInsets = .zero) {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 0.5
        super.init(views: [view],
                   sizeSource: SimpleViewSizeSource(sizeStrategy: (.fill, .absolute(1))),
                   layout: inset == .zero ? FlowLayout() : FlowLayout().inset(by: inset))
    }
}

func space(_ height: CGFloat) -> SpaceProvider {
    return SpaceProvider(sizeStrategy: (.fill, .absolute(height)))
}

class ViewController: UIViewController {
    
    let collectionView = CollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9411764706, blue: 0.9490196078, alpha: 1)
        
        let headerInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let titleProvider = LabelProvider(
            text: "Flow Menu",
            color: .systemOrange,
            font: .rounded(ofSize: 32, weight: .bold),
            inset: headerInset
        ) { context in
            print("show")
        }
        let bodyInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let bodyProvider = LabelProvider(
            text: "Flow Menu is a library for building iOS popup menus. It provides a declarative menu on top of the touch view.",
            color: .systemIndigo,
            inset: bodyInset
        ) { context in
            print("touch")
        }
        
        let mocks = MockData.mocks
        
        let colorProvider = BasicProvider(
            dataSource: mocks,
            viewSource: { (view: PaperView, data: MockData, at: Int) in
                view.styleColor(.white)
                view.populate(for: data)
                view.defaultShadow()
            },
            sizeSource: { at, data, size -> CGSize in
                let width = (size.width - 12) / 2
                let hieght = width * 1.33
                return CGSize(width: width, height: hieght)
            },
            layout: FlowLayout(spacing: 12).inset(by: bodyInset)
        ) { [weak self] context in
            let colorView = ColorViewController()
            self?.showMenu(sourceView: context.view, viewController: colorView)
        }
        
        collectionView.provider = ComposedProvider(sections: [titleProvider, bodyProvider, colorProvider])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
}

class DynamicView: UIView {
    
    var tapAnimation: Bool = true
    
    var isHighlighted: Bool = false {
        didSet {
            guard isHighlighted != oldValue else { return }
            if tapAnimation {
                var transform = CGAffineTransform.identity
                if isHighlighted { transform = transform.scaledBy(x: 0.96, y: 0.96) }
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                    self.transform = transform
                }, completion: nil)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isHighlighted = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isHighlighted = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isHighlighted = false
    }
}


class ColorViewController: UIViewController {
    
    let collectionView = CollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        let dataSource = ["Select", "Move", "Export", "Delete"]
        
        let provider = BasicProvider(
            dataSource: dataSource,
            viewSource: { (view: Button, data: String, at: Int) in
                view.label.text = data
                view.label.textColor = .black
                view.label.font = .rounded(ofSize: 16)
                view.label.textColor = at == 3 ? .red : .black
            },
            sizeSource: { at, data, size -> CGSize in
                let maxWidth = size.width - CGFloat(dataSource.count - 1) * 4
                let width = maxWidth / CGFloat(dataSource.count)
                return CGSize(width: width, height: 40)
            },
            layout: RowLayout(spacing: 4).inset(by: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)),
            tapHandler: { [weak self] context in
                self?.dismiss(animated: true)
            }
        )
        collectionView.provider = provider
        collectionView.delaysContentTouches = false
        collectionView.showsHorizontalScrollIndicator = false
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
}

class PaperView: DynamicView {
    
    let collectionView = CollectionView()
    let signLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        addSubview(signLabel)
        collectionView.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = signLabel.frame.size
        signLabel.frame.origin = CGPoint(x: bounds.maxX - size.width - 8, y: bounds.maxY - size.height - 8)
        collectionView.frame = bounds
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
    
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        let scaleDown = {
            self.layer.zPosition = 0
            self.transform = .identity.scaledBy(x: 0.96, y: 0.96)
        }
        let scaleUp = {
            self.layer.zPosition = 1
            self.transform = .identity.scaledBy(x: 1.1, y: 1.1)
            self.defaultShadow(radius: 4, opacity: 0.3, size: 4)
        }
        let reset = {
            self.layer.zPosition = 0
            self.defaultShadow()
            self.transform = .identity
        }
        
    }
    
}

class Button: DynamicView {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = bounds
    }
}
