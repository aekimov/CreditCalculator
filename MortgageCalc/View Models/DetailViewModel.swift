//
//  DetailViewModel.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 1/20/22.
//

import Foundation

class DetailViewModel {
    
    let section: Int
    private(set) var calculator: Calculator
    private(set) var updatedCredit: CreditModel
    
    init(calculator: Calculator, section: Int) {
        self.section = section
        self.calculator = calculator
        self.updatedCredit = calculator.creditModel
    }
    
    private(set) var rateString: String = ""
    private(set) var titleString: String = ""
    private(set) var monthlyPaymentString: String = "0"
    private(set) var remainderString: String = "0"
    private(set) var progressBarValue: Float = 0
    private(set) var totalPaidString: String = "0"
    private(set) var amountString: String = "0"
    private(set) var totalString: String = "0"
    private(set) var interestString: String = "0"
    private(set) var endDateString: String = ""
    private(set) var firstPaymentMonthString: String = ""
    
    var earlyPayments: [EarlyPaymentModel] {
        var earlyPayments: [EarlyPaymentModel] = []
        let sortedPayments = updatedCredit.advancePayments.sorted { $0.key < $1.key }
        for index in 0..<sortedPayments.count {
            let date = sortedPayments[index].key
            let paymentsValues = sortedPayments[index].value
            let payment = Array(paymentsValues)[0].key
            let type = Array(paymentsValues)[0].value
            let earlyPayment = EarlyPaymentModel(amount: payment, date: date, type: type)
            earlyPayments.append(earlyPayment)
        }
        return earlyPayments
    }
    
    func deleteEarlyPayment(earlyPayment: EarlyPaymentModel) {
        updatedCredit.advancePayments.removeValue(forKey: earlyPayment.date)  // update early payments in the model
        calculator.dataManager.updateCredit(updatedCredit: updatedCredit, section: section)
        updateAndFetchData()
    }
    
    func modelWithoutSpecificPayment(dateDouble: Double) -> CreditModel { //model for calculating the benefit from early payment, transmitted and used only in mainCoordinator
        var reducedModel = updatedCredit
        reducedModel.advancePayments.removeValue(forKey: dateDouble)
        return reducedModel
    }

    func deleteCredit() {
        calculator.dataManager.deleteCredit(section: section)
    }
    
    func updateUI() {
        titleString = updatedCredit.title
        
        rateString = "\(Localized.rate) \(updatedCredit.rate.zeroScaleStr)%" // preciseRound
        monthlyPaymentString = calculator.currentMonthlyPayment.asString
        
        let remainder = calculator.getRemainder()
        remainderString = remainder.asString
        
        if remainder != 0 {
            progressBarValue = Float(1 - remainder.asDouble / calculator.amount.asDouble)
            totalPaidString = "\(Localized.paid): \((calculator.amount - remainder).asString)"
        } else {
            progressBarValue = 1
            totalPaidString = "\(Localized.paid): \(calculator.amount.asString)"
        }
        amountString = "\(Localized.outOf): \(calculator.amount.asString)"
        totalString = calculator.totalAmount.asString
        interestString = calculator.interestAmount.asString

        endDateString = calculator.endDateDouble.formatDate()
    }
    
    func callbackModel(creditModel: CreditModel) { // модель, которая приходит из EditViewModel, если ее обновили
        updatedCredit = creditModel
        calculator.updateModel(calcModel: creditModel)
        updateUI()
    }

    func updateAndFetchData() { // при каждом viewWillAppear обновлять данные
        let creditsArray = calculator.dataManager.fetchCreditsUD()
        updatedCredit = creditsArray[section]
        calculator.updateModel(calcModel: updatedCredit)
        updateUI()
    }
    
    func fetchData() {
        updateUI()
    }
    
    var numberOfRows: Int { return updatedCredit.advancePayments.count }
    
}
