//
//  Sequence+Extension.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 1/16/22.
//

import Foundation

extension String {
    func applyMask() -> String {
        var str = self
        str.removeAll { !(("0"..."9" ~= $0) || ("." ~= $0) || ("," ~= $0)) }
        var text = str
        
        let indexOfDot = text.firstIndex (where: { ($0 == ",") || ($0 == ".") } )
        
        let customIndex = indexOfDot != nil ? index(str.endIndex, offsetBy: -3) : str.endIndex
        
        for index in text.indices.reversed() {
            if str.distance(from: customIndex, to: index).isMultiple(of: 3) && index != text.startIndex && index != customIndex {
                text.insert(" ", at: index)
            }
        }
        return text
    }
    
    var removeSpaces: String {
        var str = self
        str.removeAll { !(("0"..."9" ~= $0) || ("." ~= $0) || ("," ~= $0)) }
        return str
    }

    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func removePrefixes(_ prefixes: [String]) -> String {
        
        for prefix in prefixes {
            if self.hasPrefix(prefix) {
                return ""
            } else {
                return self
            }
        }
        return self
    }
    
    func hasPrefixes(_ prefixes: [String]) -> Bool {

        for prefix in prefixes {
            if self.hasPrefix(prefix) {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    var asDecimal: Decimal {
        return NSDecimalNumber(string: self).decimalValue
    }
    
    var asDecimalLocale: Decimal {
        return NSDecimalNumber(string: self, locale: Locale.current).decimalValue
    }
}
