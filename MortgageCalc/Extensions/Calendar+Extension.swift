//
//  Calendar+Extension.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 2/12/22.
//

import Foundation

extension Calendar {
    func monthRange(from: Date, to: Date) -> Int {
        guard let range = self.dateComponents([.month], from: from, to: to).month else {
            print("Incorrect date conversion or month counting in the monthRange method of the Calendar extension")
            return 0
        }
        return range
    }
    
    func dayRange(from: Double, to: Double) -> Int {
        guard let range = self.dateComponents([.day], from: from.toDate, to: to.toDate).day else {
            print("Incorrect date conversion or month counting in the dayRange method of the Calendar extension")
            return 0
        }
        return range
    }
    
    func addingMonths(value: Int, to date: Date) -> Double {
        guard let date = self.date(byAdding: .month, value: value, to: date) else {
            print("Incorrect date conversion or month counting in the addingMonths method of the Calendar extension")
            return 0
        }
        return date.timeIntervalSince1970
    }
}
