//
//  CalculatorTests.swift
//  MortgageCalcTests
//
//  Created by Artem Ekimov on 2/19/22.
//

import XCTest
@testable import MortgageCalc

struct Result: Equatable {
    let monthlyPayment: Decimal
    let interestAmount: Decimal
}

class CalculatorTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
        
    let models: [CreditModel] = [
        .init(title: "Ипотека", amount: 1750000, period: 120, rate: 8.1, zeroDate: .init(2020, 9, 15)),
    ]
    
    
    let results: [Result] = [
        .init(monthlyPayment: 21324.91, interestAmount: 808399.80),
    ]
    
    func testCredits() {
        for index in 0..<models.count {
            let calculator = Calculator(creditModel: models[index])
            print("test calculator", calculator.interestAmount)
            let testModel = Result(monthlyPayment: calculator.monthlyPayment, interestAmount: calculator.interestAmount)
            XCTAssertEqual(testModel, results[index])
        }
    }

//    func testMonthlyPayment() {
//        let model = CreditModel(title: "Ипотека", amount: 1750000, period: 120, rate: 8.1, zeroDate: 1600160400)
//        let dataManager = DataManager()
//        let calculator = Calculator(creditModel: model, dataManager: dataManager)
//
//        XCTAssertEqual(calculator.monthlyPayment, 21324.91)
//    }
//
//    func testInterestAmount() {
//        let model = CreditModel(title: "Ипотека", amount: 3300000, period: 132, rate: 7.7, zeroDate: .init(2021, 8, 23))
//        let dataManager = DataManager()
//        let calculator = Calculator(creditModel: model, dataManager: dataManager)
//
//        XCTAssertEqual(calculator.interestAmount, 1602813.87)
//    }
//
//    func testOverallAmount() {
//        let model = CreditModel(title: "Ипотека", amount: 1750000, period: 120, rate: 8.1, zeroDate: 1600160400)
//        let dataManager = DataManager()
//        let calculator = Calculator(creditModel: model, dataManager: dataManager)
//
//        XCTAssertEqual(calculator.principalAmount + calculator.interestAmount, 2558399.80)
//    }
}
