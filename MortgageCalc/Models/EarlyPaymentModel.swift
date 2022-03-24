//
//  EarlyPaymentModel.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 3/7/22.
//

import Foundation


struct EarlyPaymentModel: Codable {
    let amount: Decimal
    let date: Double
    let type: Bool

    init(amount: Decimal, date: Double, type: Bool) {
        self.amount = amount
        self.date = date
        self.type = type
    }
}
