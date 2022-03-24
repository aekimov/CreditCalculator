//
//  UIStackView+Extension.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 2/4/22.
//

import UIKit

extension UIStackView {
    
    convenience init(type: NSLayoutConstraint.Axis, alignment: Alignment, distribution: Distribution, spacing: CGFloat = 0, paddings: UIEdgeInsets = .zero) {
        self.init()
        
        self.spacing = spacing
        self.isLayoutMarginsRelativeArrangement = true
        
        self.layoutMargins = paddings
        
        switch type {
        case .horizontal:
            self.axis = .horizontal
        case .vertical:
            self.axis = .vertical
        @unknown default:
            self.axis = .vertical
        }
        
        switch alignment {
        case .fill:
            self.alignment = .fill
        case .leading:
            self.alignment = .leading
        case .firstBaseline:
            self.alignment = .firstBaseline
        case .center:
            self.alignment = .center
        case .trailing:
            self.alignment = .trailing
        case .lastBaseline:
            self.alignment = .lastBaseline
        @unknown default:
            self.alignment = .fill
        }
        
        switch distribution {
        
        case .fill:
            self.distribution = .fill
        case .fillEqually:
            self.distribution = .fillEqually
        case .fillProportionally:
            self.distribution = .fillProportionally
        case .equalSpacing:
            self.distribution = .equalSpacing
        case .equalCentering:
            self.distribution = .equalCentering
        @unknown default:
            self.distribution = .fill
        }
    }
    
    @discardableResult
    func removeAllArrangedSubviews() -> [UIView] {
        return arrangedSubviews.reduce([UIView]()) { $0 + [removeArrangedSubViewProperly($1)] }
    }
    
    func removeArrangedSubViewProperly(_ view: UIView) -> UIView {
        removeArrangedSubview(view)
        NSLayoutConstraint.deactivate(view.constraints)
        view.removeFromSuperview()
        return view
    }
}

