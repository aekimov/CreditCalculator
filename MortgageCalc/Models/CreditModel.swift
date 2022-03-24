//
//  EmptyModel.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 1/18/22.
//

import Foundation

typealias Payments = [Double: [Decimal: Bool]] //[Date: [Payment: Type]]

struct CreditModel: Codable, Equatable {
    let title: String
    let amount: Decimal
    let period: Int
    let rate: Decimal
    let zeroDate: Double

    var advancePayments: Payments
    
    init(title: String, amount: Decimal, period: Int, rate: Decimal, zeroDate: Double, advancePayments: Payments = [:]) {
        self.title = title
        self.amount = amount
        self.period = period
        self.rate = rate
        self.zeroDate = zeroDate
        
        self.advancePayments = advancePayments
    }
}
