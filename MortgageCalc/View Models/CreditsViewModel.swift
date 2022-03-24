//
//  CreditsViewModel.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 1/18/22.
//

import Foundation


class CreditsViewModel {

    private let dataManager = DataManager()
    private(set) var credits: [CreditModel] = []
    private(set) var cells: [CreditCellModel] = []

    var hasChanged: Bool {
        return credits != dataManager.fetchCreditsUD()
    }

    func fetchData() {
        credits = dataManager.fetchCreditsUD()
    }
    
    func getModelForCell(_ section: Int) -> CreditCellModel {
        let creditModel = credits[section]
        let calcultor = Calculator(creditModel: creditModel)

        let amoundDecimal = creditModel.amount
        let remainderDecimal: Decimal = calcultor.getRemainder()

        let title = creditModel.title
        let amount = amoundDecimal.asString
        let period = String(creditModel.period)
        let rate = creditModel.rate.zeroScaleStr
        let nextPaymentDate = creditModel.zeroDate.toDate.calcNextPaymentDate()
        let monthlyPayment: String = calcultor.currentMonthlyPayment.asString

        let remainder: String = remainderDecimal.round(0).zeroScaleStr
        let totalPaid: String = (amoundDecimal - remainderDecimal).round(0).zeroScaleStr
        let progressValue: Float = Float(1 - remainderDecimal.asDouble / amoundDecimal.asDouble)

        let cellModel = CreditCellModel(title: title, amount: amount, period: period, rate: rate, nextPaymentDate: nextPaymentDate, monthlyPayment: monthlyPayment, remainder: remainder, totalPaid: totalPaid, progressValue: progressValue)
        return cellModel
    }
}
