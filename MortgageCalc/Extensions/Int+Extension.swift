//
//  Int+Extension.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 1/31/22.
//

import Foundation

extension Int {
    
    var isLeapYear: Bool {
        if (self % 100 != 0 && self % 4 == 0) || self % 400 == 0 {
            return true
        } else { return false }
    }
    
    var asDecimal: Decimal {
        return NSDecimalNumber(integerLiteral: self).decimalValue
    }
}
