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
         inset: UIEdgeInsets = .zero,
         tapHandler: TapHandler? = nil) {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = font
        label.numberOfLines = 0
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
        collectionView.delaysContentTouches = false
        
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
        
        let colors = [
            UIColor.systemRed,
            UIColor.systemBlue,
            UIColor.systemCyan,
            UIColor.systemOrange,
            UIColor.systemPurple,
            UIColor.systemGray,
            UIColor.systemMint,
            UIColor.systemPink,
            UIColor.systemTeal,
            UIColor.systemBrown,
            UIColor.systemYellow,
            UIColor.systemGreen
        ]
        
        let colorProvider = BasicProvider(
            dataSource: colors,
            viewSource: { (view: PaperView, data: UIColor, at: Int) in
                view.styleColor(.white)
                view.populate(for: data)
                view.defaultShadow()
                view.onLongPress = { [weak self] in
                    let colorView = ColorViewController()
                    self?.showMenu(sourceView: view, viewController: colorView)
                }
            },
            sizeSource: { at, data, size -> CGSize in
                let width = (size.width - 12) / 2
                let hieght = width * 1.33
                return CGSize(width: width, height: hieght)
            },
            layout: FlowLayout(spacing: 12).inset(by: bodyInset)
        ) {  context in
            
            
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

class PaperView: UIView {
    
    let collectionView = CollectionView()
    let longPressGesture = UILongPressGestureRecognizer()
    let tapGesture = UITapGestureRecognizer()
    var onLongPress: (() -> Void)?
    var triggerLongPress: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.isUserInteractionEnabled = false
        longPressGesture.addTarget(self, action: #selector(didLongPress))
        longPressGesture.minimumPressDuration = 0
        addGestureRecognizer(tapGesture)
        addGestureRecognizer(longPressGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
    }
    
    func populate(for theme: UIColor) {
        let titleProvider = LabelProvider(text: "Welcome to Noto!✍️", color: theme, font: .rounded(ofSize: 16, weight: .bold))
        let timeProvider = LabelProvider(text: "Yesterday, 6:36 PM", color: .systemGray, font: .rounded(ofSize: 14))
        let contentProvider = LabelProvider(text: "Thank you for checking out Noto!, We crafted Noto to be clean and morden, yet powerful enough to replace your existing note app. Let us give you a walk through of what it can do.", font: .rounded(ofSize: 8))
        let contentProvider2 = LabelProvider(text: "Editing Tools 🛠", color: theme, font: .rounded(ofSize: 10, weight: .medium))
        let contentProvider3 = LabelProvider(text: "Text Format", color: theme, font: .rounded(ofSize: 8, weight: .medium))
        
        collectionView.provider = ComposedProvider(
            layout: FlowLayout(spacing: 8).inset(by: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)),
            sections: [
                titleProvider,
                timeProvider,
                SeperatorProvider(),
                contentProvider,
                SeperatorProvider(),
                contentProvider2,
                contentProvider3
            ]
        )
    }
    
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        let scaleDown = {
            self.transform = .identity.scaledBy(x: 0.96, y: 0.96)
        }
        let scaleUp = {
            print(sender.state.rawValue)
            self.transform = .identity.scaledBy(x: 1.1, y: 1.1)
            self.defaultShadow(radius: 4, opacity: 0.3, size: 4)
            self.triggerLongPress = true
        }
        let reset = {
            self.defaultShadow()
            self.transform = .identity
        }
        
        
        
        switch sender.state {
        case .began, .possible, .changed:
            let animator = UIViewPropertyAnimator(duration: 0.2, curve: .linear, animations: scaleDown)
            animator.startAnimation()
            animator.addAnimations(scaleUp, delayFactor: 0.3)
        default:
            
            let newAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .linear, animations: reset)
            newAnimator.startAnimation()
            
            if triggerLongPress {
                onLongPress?()
            }
        }
    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//
//        UIView.animate(withDuration: 0.2) {
//            self.transform = .identity.scaledBy(x: 0.96, y: 0.96)
//        }
//        UIView.animate(withDuration: 0.2, delay: 0.3) {
//            self.layer.zPosition = 10
//            self.defaultShadow(radius: 4, opacity: 0.3, size: 4)
//            self.transform = .identity.scaledBy(x: 1.1, y: 1.1)
//        }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//
//        UIView.animate(withDuration: 0.2) {
//            self.layer.zPosition = 0
//            self.defaultShadow()
//            self.transform = .identity
//        }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesCancelled(touches, with: event)
//
//        UIView.animate(withDuration: 0.2) {
//            self.layer.zPosition = 0
//            self.defaultShadow()
//            self.transform = .identity
//        }
//    }
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
