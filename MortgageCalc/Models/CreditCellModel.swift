//
//  CreditCellModel.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 1/23/22.
//

import Foundation


struct CreditCellModel {
    
    let title: String
    let amount: String
    let period: String
    let rate: String
    let nextPaymentDate: String
    let monthlyPayment: String
    let totalPaid: String
    let remainder: String
    let progressValue: Float
    
    init(title: String, amount: String, period: String, rate: String, nextPaymentDate: String, monthlyPayment: String, remainder: String, totalPaid: String, progressValue: Float) {
        self.title = title
        self.amount = amount
        self.period = period
        self.rate = rate
        self.nextPaymentDate = nextPaymentDate
        self.monthlyPayment = monthlyPayment
        self.remainder = remainder
        self.totalPaid = totalPaid
        self.progressValue = progressValue
    }
}
