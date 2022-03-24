//
//  NSAttributesString+Extension.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 3/4/22.
//

import UIKit

extension NSMutableAttributedString {

    func bold(_ value:String) {
        
        let attributes: [NSAttributedString.Key : Any] = [.font : UIFont.systemFont(ofSize: 16, weight: .bold)]
        append(NSAttributedString(string: value, attributes: attributes))
    }
}

extension NSMutableAttributedString {
    
    static func description(_ overpaymentType: PaymentType, oldPayment: Decimal, newPayment: Decimal, termDiff: Int, interestDiff: Decimal) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: Localized.description)
        attributedString.bold(interestDiff >= 0 ? "\(Localized.decreaseBy) \(abs(interestDiff).asString). "
                                                : "\(Localized.increaseBy) \(abs(interestDiff).asString). ")
        
        switch overpaymentType {
        
        case .decreasePeriod:
            
            attributedString.append(NSMutableAttributedString(string: Localized.termReduction))
            attributedString.bold(termDiff >= 0 ? "\(Localized.decreaseBy) \(abs(termDiff)) \(Localized.months)"
                                                : "\(Localized.increaseBy) \(abs(termDiff)) \(Localized.months)")
            return attributedString
            
        case .decreasePayment:
            
            attributedString.append(NSMutableAttributedString(string: Localized.paymentReduction))
            
            let diff = oldPayment - newPayment
            attributedString.bold(diff >= 0 ? "\(Localized.decreaseBy) \(diff.asString) "
                                            : "\(Localized.increaseBy) \(diff.asString) ")
            
            attributedString.append(NSMutableAttributedString(string: "(\(Localized.from) \(oldPayment.asString) \(Localized.to) \(newPayment.asString))."))
            return attributedString
        }
    }
}
