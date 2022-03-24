//
//  PaymentsViewModel.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 11/29/21.
//

import Foundation


class PaymentsViewModel {
    
    let calculator: Calculator
    
    init(calculator: Calculator) {
        self.calculator = calculator
    }
    
    private var maxNumberOfMonthsInFirstSection: Int {
        return calculator.zeroMonthNumber == 12 ? 12 : 12 - calculator.zeroMonthNumber
    }
    
    private var numberOfItems: Int = 0
    private var remainingMonths: Int = 0

    let firstColumnSequence = Array(stride(from: 0, through: 55, by: 5))
    private let secondColumnSequence = Array(stride(from: 1, through: 56, by: 5))
    private let thirdColumnSequence = Array(stride(from: 2, through: 57, by: 5))
    private let forthColumnSequence = Array(stride(from: 3, through: 58, by: 5))
    private let fifthColumnSequence = Array(stride(from: 4, through: 59, by: 5))
    
    private var dataArray: [[[String]]] = []
    
    var totalAmount: String { return calculator.totalAmount.asString }
    var interestAmount: String { return calculator.interestAmount.asString }
    var principalAmount: String { return calculator.principalAmount.asString }
    
    //updated every viewWillAppear
    func fetchData() {
        self.dataArray = calculator.resultsArray
    }

    
    //MARK: - Data for populating CollectionView
    
    var numberOfSections: Int { return calculator.years }
    
    var yearsForHeader: [String] {
        var arrayOfYears: [String] = []

        var currentYear = calculator.zeroMonthNumber == 12 ? calculator.zeroYearNumber + 1 : calculator.zeroYearNumber

        for _ in 1...calculator.years {
            arrayOfYears.append(String(currentYear))
            currentYear += 1
        }
        return arrayOfYears
    }
    
    func numberOfItemsInSection(for section: Int) -> Int {
        
        if section == 0 {
            
            if Int(calculator.numberOfMonths) > maxNumberOfMonthsInFirstSection {
                
                remainingMonths = Int(calculator.numberOfMonths) - maxNumberOfMonthsInFirstSection
                numberOfItems = maxNumberOfMonthsInFirstSection * 5
                
            } else if Int(calculator.numberOfMonths) <= maxNumberOfMonthsInFirstSection {
                remainingMonths = 0
                numberOfItems = Int(calculator.numberOfMonths) * 5
            }
            return numberOfItems
            
        } else {
            
            if remainingMonths >= 12 { //if divisible by a multiple, then 12 rows of 5 elements
                remainingMonths -= 12
                numberOfItems = 12 * 5
                
                return numberOfItems
                
            } else {
                numberOfItems = remainingMonths * 5
                remainingMonths = 0
                
                return numberOfItems
            }
        }
    }
    
    func fetchText(for item: Int, in section: Int) -> String {
            
        if firstColumnSequence.contains(item) { //[0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]

            return dataArray[section][item/5][0]
            
        } else if secondColumnSequence.contains(item) {
     
            return dataArray[section][item/5][1]

        } else if thirdColumnSequence.contains(item) {
            
            return dataArray[section][item/5][2]
            
        } else if forthColumnSequence.contains(item) {

            return dataArray[section][item/5][3]
            
        } else if fifthColumnSequence.contains(item) {
            
            return dataArray[section][item/5][4]
        }
        return ""
    }
}
