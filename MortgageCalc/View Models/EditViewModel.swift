//
//  EditViewModel.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 1/20/22.
//


import Foundation

class EditViewModel {
    
    private let dataManager: DataManager
    private let section: Int
    private let callback: (CreditModel) -> Void
    
    init(model: CreditModel, dataManager: DataManager, section: Int, callback: @escaping (CreditModel) -> Void) {
        self.callback = callback
        self.section = section
        self.dataManager = DataManager()
        self.title = model.title
        self.amount = model.amount
        self.period = model.period
        self.rate = model.rate
        self.zeroDateDouble = model.zeroDate
        self.advancePayments = model.advancePayments
        self.initialSetup()
    }

    private(set) var title: String
    private(set) var amount: Decimal
    private(set) var period: Int
    private(set) var rate: Decimal
    private(set) var zeroDateDouble: Double
    private(set) var advancePayments: Payments
    
    private(set) var isFormValid: Bool = false
    
    private func initialSetup() {
        titleString = title
        amountString = amount.zeroScaleStr
        rateString = rate.zeroScaleStr
        periodString = String(period)
        sliderValue = Float(amount.asDouble)
        date = zeroDateDouble.toDate
        validate()
    }

    private func validate()  {
        isFormValid = 1...100_000_000 ~= amount && period > 0 && rate >= 0 && !title.isEmpty
    }
    
    func updateModel() { // fires when the "Save" button is clicked
        var updatedModel = CreditModel(title: title, amount: amount, period: period, rate: rate, zeroDate: zeroDateDouble, advancePayments: advancePayments)
        

        let calculator = Calculator(creditModel: updatedModel)
        calculator.populateArray()
        
        updatedModel = CreditModel(title: title, amount: amount, period: period, rate: rate, zeroDate: zeroDateDouble, advancePayments: advancePayments)

        dataManager.updateCredit(updatedCredit: updatedModel, section: section)
        callback(updatedModel) // closure with updated model in DetailViewModel to update model in Calculator
    }

    //MARK:- Back To TextField's
    
    private(set) var amountString: String = ""
    private(set) var rateString: String = ""
    private(set) var periodString: String = ""
    private(set) var titleString: String = ""
    private(set) var zeroDateString: String = ""
    private(set) var sliderValue: Float = 0
    
    //MARK:- From EditViewController TextField's
    
    func verifyAmount(_ text: String) {
        let maxNumber: Decimal = 99_999_999
        amount = text.removeSpaces.asDecimalLocale
        amount = amount > maxNumber ? maxNumber : amount
        amountString = amount.zeroScaleStr
        sliderValue = Float(amount.asDouble)
        validate()
    }
    
    //a function to remove the last character if it is not a digit, or remove 0
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
        
        //if the first character of the input is not a digit or an empty string, then return an empty string
        if (text.hasPrefix(".") || text.hasPrefix(",")) || text == "" {
            rateString = ""
            rate = 0
            return
        }
        
        //if more than 2 characters are entered and the third character is not a number, or if more than 3 characters are entered and the character is not a number, then return
        if text.count > 2 {
            let lastChar = text[text.index(text.endIndex, offsetBy: -1)]
            let beforeLastChar = text[text.index(text.endIndex, offsetBy: -2)]
            if !lastChar.isNumber && (!beforeLastChar.isNumber || beforeLastChar.isNumber) {
                return
            }
        }
        
        //if the second character "." or "," then update only the rateString
        if (text.last == "." || text.last == ",") {
            rateString = text
            return
        }
        
        //if there are 3 characters and there is a character "." or "," and last character 0 then update only rateString
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
        validate()
    }

    func verifyPeriod(_ text: String) {
        let maxNumber: Int = 999
        period = Int(text) ?? 0
        period = period > maxNumber ? maxNumber : period
        periodString = String(period)
        validate()
    }
    
    func verifyTitle(_ text: String) {
        title = text
        titleString = title
        validate()
    }
    
    var date: Date = Date() {
        didSet {
            zeroDateDouble = date.modify.toDouble
            zeroDateString = zeroDateDouble.formatDate()
            validate()
        }
    }
}
