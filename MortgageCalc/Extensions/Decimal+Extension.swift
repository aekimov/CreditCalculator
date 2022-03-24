//
//  Decimal+Extension.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 2/15/22.
//

import Foundation

extension Decimal {
    
    func _round(_ scale: Int16 = 2, _ roundingMode: NSDecimalNumber.RoundingMode = .plain) -> NSDecimalNumber {
        let behavior = NSDecimalNumberHandler(roundingMode: roundingMode, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        return NSDecimalNumber(decimal: self).rounding(accordingToBehavior: behavior)
    }

    func round(_ scale: Int16 = 2, _ roundingMode: NSDecimalNumber.RoundingMode = .plain) -> Decimal {
        return _round(scale, roundingMode).decimalValue
    }
    
    var asDouble: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
    
    var asString: String {
        let nsNumber = NSDecimalNumber(decimal: self)
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        guard let string = formatter.string(from: nsNumber)  else  {
            print("Ошибка в преобразовании в asString расширение Decimal")
            return ""
        }
        return string.replacingOccurrences(of: ".", with: ",").applyMask()
    }

    var asStringLocale: String {
        return self._round(2).description(withLocale: Locale.current)
    }

    var zeroScaleStr: String {
        return String(describing: self).replacingOccurrences(of: ".", with: ",").applyMask()
    }

    var asInt: Int {
        return NSDecimalNumber(decimal: self).intValue
    }
}

@propertyWrapper
struct Capitalized {
    
    private var value: String
    var wrappedValue: String {
        get { value }
        set { value = newValue.capitalized }
    }
    
    init(wrappedValue: String) {
        value = wrappedValue.capitalized
    }
}
