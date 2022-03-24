//
//  AdvancePaymentsViewModel.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 12/18/21.
//

import Foundation

class AddPaymentViewModel {
        
    let calculator: Calculator
    private let section: Int
    
    init(calculator: Calculator, section: Int) {
        self.calculator = calculator
        self.section = section
        self.updatedCredit = calculator.creditModel
        
        paymentStruct = calculator.creditModel.advancePayments
        paymentStructTemp = paymentStruct
        self.dateDouble = Date().modify.toDouble
        self.dateString = dateDouble.formatDate()

        self.interestAmountInitial = calculator.interestAmount
        self.beforeAmountInitial = interestAmountInitial

        self.paymentType = .decreasePeriod
        recalculate(overpaymentGoal: .preliminaryPayment)
    }
    
    private(set) var amount: Decimal = 0
    private(set) var dateDouble: Double
    private(set) var paymentType: PaymentType
    
    private(set) var amountString: String = ""
    private(set) var dateString: String
    private(set) var description = NSMutableAttributedString(string: Localized.outOfCreditRange)

    private(set) var updatedCredit: CreditModel
    
    private var interestAmountInitial: Decimal
    private var beforeAmountInitial: Decimal
    
    private var paymentStruct: Payments
    private var paymentStructTemp: Payments
    
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
            paymentStruct[dateDouble] = [payment: type]
                        
            updatedCredit.advancePayments = paymentStruct //update early payments in the model
            
            calculator.dataManager.updateCredit(updatedCredit: updatedCredit, section: section) //write to UD

            interestAmountInitial = calculator.interestAmount //updating the initial value so that it is not the same as while init
            
        case .preliminaryPayment:

            // if the payment was not added to the table, then we make sure that the initial value is what it was during initialization.
            // If it was added, then it changes in case .completedPayment.
            
            if interestAmountInitial == calculator.totalAmount {
                beforeAmountInitial = interestAmountInitial
            }
            
            paymentStructTemp = paymentStruct
            paymentStructTemp[dateDouble] = [payment: type]
            calculator.updateDictionary(path: .temporary(paymentStructTemp)) ///внутри populateArray вызывается
            
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

    var date: Date = Date() { // из datePicker который в TextField
        didSet {
            dateDouble = date.modify.toDouble
            dateString = dateDouble.formatDate()
            recalculate(overpaymentGoal: .preliminaryPayment)
        }
    }
    
    var selectedSegment: Int = 0 { // из selectedSegment
        didSet {
            paymentType = selectedSegment == 0 ? .decreasePeriod : .decreasePayment
            recalculate(overpaymentGoal: .preliminaryPayment)
        }
    }
}
