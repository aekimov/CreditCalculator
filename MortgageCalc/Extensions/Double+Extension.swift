//
//  String+Extension.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 12/8/21.
//

import Foundation

extension Double {
    
    func round(to characters: Int) -> String {
        return String(format: "%.\(characters)f", self).replacingOccurrences(of: ".", with: ",").applyMask()
    }

    var asDecimal: Decimal {
        return NSNumber(floatLiteral: self).decimalValue
    }
    
    var toDate: Date {
        return Date(timeIntervalSince1970: self)
    }
    
    func dateDouble(_ year: Int, _ month: Int, _ day: Int, _ hour: Int = 12) -> Double {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(calendar: calendar, year: year, month: month, day: day, hour: hour)
        guard let date = calendar.date(from: components) else {
            print("Error converting dateDouble method")
            return 0
        }
        return date.timeIntervalSince1970
    }
    
    func formatDate(_ format: String = "dd.MM.yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self.toDate)
    }
}
