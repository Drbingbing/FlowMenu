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
        layer.shadowOffset = CGSize(width: size, height: size)
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
        collectionView.showsVerticalScrollIndicator = false
        
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
                view.onLongPressGesture = { [weak self] in
                    let colorView = ColorViewController()
                    self?.showMenu(sourceView: view, viewController: colorView)
                }
            },
            sizeSource: { at, data, size -> CGSize in
                let width = (size.width - 12) / 2
                let hieght = width * 1.33
                return CGSize(width: width, height: hieght)
            },
            layout: FlowLayout(spacing: 12).inset(by: bodyInset),
            tapHandler: { context in
//                let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
//                view.backgroundColor = context.data.tintColor
//                let popover = Popover()
//                popover.show(view, sourceView: context.view)
            }
        )

        collectionView.provider = ComposedProvider(sections: [titleProvider, bodyProvider, colorProvider])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
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
