//
//  Date+Extensions.swift
//  MortgageCalcTests
//
//  Created by Artem Ekimov on 2/19/22.
//

import Foundation

//extension Double {
//    func dateDouble(_ year: Int, _ month: Int, _ day: Int, _ hour: Int = 12) -> Double {
//        let calendar = Calendar(identifier: .gregorian)
//        let components = DateComponents(calendar: calendar, year: year, month: month, day: day, hour: hour)
//        guard let date = calendar.date(from: components) else {
//            print("Ошибка конвертации метод dateDouble")
//            return 0
//        }
//        return date.timeIntervalSince1970
//    }
//}

extension Double {
    public init(_ year: Int, _ month: Int, _ day: Int, _ hour: Int = 12) {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(calendar: calendar, year: year, month: month, day: day, hour: hour)
        let date = calendar.date(from: components)
        self.init(date!.timeIntervalSince1970)
    }
}
