//
//  UIView+Extensions.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 10/23/21.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func deactivateConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        self.removeConstraints(self.constraints)
    }
    
    func centerAnchors(x: NSLayoutXAxisAnchor?, y: NSLayoutYAxisAnchor?) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let x = x {
            centerXAnchor.constraint(equalTo: x).isActive = true
        }
        if let y = y {
            centerYAnchor.constraint(equalTo: y).isActive = true
        }
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
    
    func centerAnchors(x: NSLayoutXAxisAnchor?, offsetX: CGFloat = 0, y: NSLayoutYAxisAnchor?, offsetY: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let x = x {
            centerXAnchor.constraint(equalTo: x, constant: offsetX).isActive = true
        }
        if let y = y {
            centerYAnchor.constraint(equalTo: y, constant: offsetY).isActive = true
        }
    }
    
    func addLabelTextField(label: UIView, textField: UIView) {
        self.insertSubview(label, at: 0)
        self.insertSubview(textField, at: 1)
        
        label.anchor(top: label.superview?.topAnchor, left: label.superview?.leftAnchor, bottom: nil, right: label.superview?.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)

        textField.anchor(top: textField.superview?.topAnchor, left: textField.superview?.leftAnchor, bottom: textField.superview?.bottomAnchor, right: textField.superview?.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 56)
    }
    
    func setSizeConstraints(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }

    }
}
