//
//  ChangePaymentViewModel.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 3/6/22.
//

import Foundation

class ChangePaymentViewModel {
        
    let calculator: Calculator
    private let section: Int
    private let selectedEarlyPayment: EarlyPaymentModel
    
    init(calculator: Calculator, section: Int, selectedEarlyPayment: EarlyPaymentModel) {
        self.calculator = calculator
        self.section = section
        self.selectedEarlyPayment = selectedEarlyPayment
        
        self.amount = selectedEarlyPayment.amount
        self.dateDouble = selectedEarlyPayment.date
        self.paymentType = selectedEarlyPayment.type ? .decreasePeriod : .decreasePayment
            
        self.updatedCredit = calculator.creditModel
        
        advancePayments = calculator.creditModel.advancePayments
        advancePaymentsTemp = advancePayments

        self.interestAmountInitial = calculator.interestAmount
        
        initialSetup()
    }
    
    private(set) var amount: Decimal
    private(set) var dateDouble: Double
    private(set) var paymentType: PaymentType
    
    private(set) var amountString: String = ""
    private(set) var dateString: String = ""
    private(set) var description = NSMutableAttributedString(string: Localized.outOfCreditRange)
    
    private func initialSetup() {
        amountString = amount.zeroScaleStr
        dateString = dateDouble.formatDate()
        selectedSegment = paymentType == .decreasePeriod ? 0 : 1        
    }

    private(set) var updatedCredit: CreditModel
    
    private var interestAmountInitial: Decimal = 0
    private var beforeAmountInitial: Decimal = 0
    private var advancePayments: Payments
    private var advancePaymentsTemp: Payments
    
    var isFormValid: Bool { return 1...100_000_000 ~= amount }
    
    func isAllowableDate(date: Date) -> Bool {
        if date.modify.toDouble < calculator.zeroDate.toDouble || date.modify.toDouble > calculator.endDateDouble {
            return false
        } else { return true }
    }
    
    func recalculate(overpaymentGoal: OverpaymentGoal) {
        if isFormValid {
            addPayment(payment: amount, date: dateDouble, overpaymentType: paymentType, overpaymentGoal: overpaymentGoal)
        }
    }
    
    func verifyAmount(_ text: String) {
        if text == "" {
            amountString = "0"
            amount = 0
        } else {
            let maxNumber: Decimal = 100_000_000 // возможно пересчитать немного проценты надо
            amount = text.removeSpaces.asDecimalLocale
            amount = amount > maxNumber ? maxNumber : amount
            amountString = amount.zeroScaleStr
        }
        recalculate(overpaymentGoal: .preliminaryPayment)
    }
    
    func addPayment(payment: Decimal, date: Double, overpaymentType: PaymentType, overpaymentGoal: OverpaymentGoal) {

        let type = overpaymentType == .decreasePeriod ? true : false

        switch overpaymentGoal {
        
        case .completedPayment:
            advancePayments[dateDouble] = [payment: type]
                        
            updatedCredit.advancePayments = advancePayments
            
            calculator.dataManager.updateCredit(updatedCredit: updatedCredit, section: section)

            interestAmountInitial = calculator.interestAmount
            
        case .preliminaryPayment:
            
            if interestAmountInitial == calculator.interestAmount {
                beforeAmountInitial = interestAmountInitial
            }
            
            advancePaymentsTemp = advancePayments
            advancePaymentsTemp[dateDouble] = [payment: type]
            calculator.updateDictionary(path: .temporary(advancePaymentsTemp)) ///внутри populateArray вызывается
            
            let afterAmountInitial = calculator.interestAmount // значение после изменения типа платежа
            let interestDiff = beforeAmountInitial - afterAmountInitial
            let results = calculator.advancePaymentsDict
                        
            guard let oldPayment = results[dateDouble]?.oldPayment,
                  let newPayment = results[dateDouble]?.newPayment,
                  let monthDiff = results[dateDouble]?.monthDiff
            else {
                print("There is no value in the dictionary or something went wrong")
                self.description = .init(string: Localized.outOfCreditRange)
                return
            }

            self.description = .description(overpaymentType, oldPayment: oldPayment, newPayment: newPayment, termDiff: monthDiff, interestDiff: interestDiff)
        }
    }
    
    var date: Date = Date() {
        didSet {
            dateDouble = date.modify.toDouble
            dateString = dateDouble.formatDate()
            recalculate(overpaymentGoal: .preliminaryPayment)
        }
    }
    
    var selectedSegment: Int = 0 {
        didSet {
            paymentType = selectedSegment == 0 ? .decreasePeriod : .decreasePayment
            recalculate(overpaymentGoal: .preliminaryPayment)
        }
    }
}
