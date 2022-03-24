//
//  InputViewModel.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 1/18/22.
//

import Foundation

class InputViewModel {

    private let dataManager = DataManager()
    private var model: CreditModel
    private var creditsArray: [CreditModel] = []
    
    init(model: CreditModel) {
        self.model = model
        self.newCredit = model
        self.title = model.title
        self.amount = model.amount
        self.period = model.period
        self.rate = model.rate
        self.zeroDateDouble = model.zeroDate
        self.creditsArray = dataManager.fetchCreditsUD()
    }
    
    private(set) var title: String
    private(set) var amount: Decimal
    private(set) var period: Int
    private(set) var rate: Decimal
    private(set) var zeroDateDouble: Double
    
    private(set) var remainder: Decimal = 0 /// неизвестно при init, но в UD нужно сохранить, чтобы показывало на экране с кредитами прогресс бар
    private(set) var monthlyPayment: Decimal = 0 /// неизвестно при init, но в UD нужно сохранить, чтобы показывало на экране с кредитами прогресс бар
    
    private(set) var monthlyPaymentString: String = "0"
    private(set) var totalString: String = "0"
    private(set) var interestString: String = "0"

    private(set) var isFormValid: Bool = false
    
    func recalculate()  {
        isFormValid = amount > 0 && period > 0 && rate >= 0 && !title.isEmpty
        
        if isFormValid {
        
            newCredit = CreditModel(title: title, amount: amount, period: period, rate: rate, zeroDate: zeroDateDouble)
            let calculator = Calculator(creditModel: newCredit)

            monthlyPayment = calculator.monthlyPayment

            if monthlyPayment.isNaN || monthlyPayment == 0 {
                monthlyPaymentString = "0"
            } else {
                monthlyPaymentString = monthlyPayment.asString
            }

            totalString = calculator.totalAmount.asString
            interestString = calculator.interestAmount.asString
        }
    }
    
    private(set) var newCredit: CreditModel // модель в которую будут записываться новые измененные значения полей
 
    func saveCredit() {
        newCredit = CreditModel(title: title, amount: amount, period: period, rate: rate, zeroDate: zeroDateDouble)
        creditsArray.append(newCredit)
        dataManager.saveCreditsUD(credits: creditsArray)
    }
        
    //MARK:- Back To TextField's
    
    private(set) var amountString: String = ""
    private(set) var rateString: String = ""
    private(set) var periodString: String = ""
    private(set) var titleString: String = Localized.myCredit
    private(set) var zeroDateString: String = ""
    private(set) var sliderValue: Float = 0
    
    //MARK:- From EditViewController TextField's
    
    func verifyAmount(_ text: String) {
        let maxNumber: Decimal = 99_999_999
        amount = text.removeSpaces.asDecimalLocale
        amount = amount > maxNumber ? maxNumber : amount
        amountString = amount.zeroScaleStr.applyMask()
        sliderValue = Float(amount.asDouble)
        recalculate()
    }
    
    ///функция, чтобы убирать последний символ если он не является цифрой
    func verifyAfterResignResponder(_ text: String) {
        guard let lastChar = text.last else { return }
        
        if !lastChar.isNumber {
            rateString = String(text.dropLast())
            rate = 0
            return
        }
        
        if text.count == 3 && text.last == "0" && (text.contains(".") || text.contains(",")) {
            rate = text.asDecimalLocale
            rateString = rate.zeroScaleStr
            return
        }
    }
    
    func verifyRate(_ text: String) {
        
        ///если первый символ при вводе не цифра или пустая строка, то вернуть пустую строку
        if (text.hasPrefix(".") || text.hasPrefix(",")) || text == "" {
            rateString = ""
            rate = 0
            return
        }
        
        ///если введено больше 2-х символов, и третьим символом является не цифра, либо если введено больше 3-х символом и символом является не цифра, то return
        if text.count > 2 {
            let lastChar = text[text.index(text.endIndex, offsetBy: -1)]
            let beforeLastChar = text[text.index(text.endIndex, offsetBy: -2)]
            if !lastChar.isNumber && (!beforeLastChar.isNumber || beforeLastChar.isNumber) {
                return
            }
        }
        
        ///если введен второй символ "." или "," тогда обновить только rateString
        if (text.last == "." || text.last == ",") {
            rateString = text
            return
        }
        
        ///если 3 символа и есть символ "." или ","  и последний символ 0, тогда обновить только rateString
        if text.count == 3 && text.last == "0" && (text.contains(".") || text.contains(",")) {
            rateString = text
            return
        }

        let maxNumber: Decimal = 99
        
        rate = text.asDecimalLocale
        
        if rate.isInfinite || rate.isNaN {
            rate = 0
            rateString = ""
            return
        }
        
        rate = rate > maxNumber ? maxNumber : rate
        rateString = rate.asStringLocale
        recalculate()
    }
    
    func verifyPeriod(_ text: String) {
        let maxNumber: Int = 999
        period = Int(text) ?? 0
        period = period > maxNumber ? maxNumber : period
        periodString = String(period)
        recalculate()
    }
    
    func verifyTitle(_ text: String) {
        title = text
        titleString = title
        recalculate()
    }
    
    var date: Date = Date() { // из datePicker который в TextField
        didSet {
            zeroDateDouble = date.modify.toDouble
            zeroDateString = zeroDateDouble.formatDate() //"MMM d, yyyy"
            recalculate()
        }
    }
}
