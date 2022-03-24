//
//  NewCalculator.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 1/23/22.
//


import Foundation

typealias AdvancePayments = [Double: (oldPayment: Decimal, newPayment: Decimal, monthDiff: Int, interestDiff: Decimal)]
typealias TransformedPayments = [Int : [(dateDouble: Double, payment: Decimal, type: Bool)]]

class Calculator {
    
    private var calendar = Calendar(identifier: .gregorian)
    private(set) var creditModel: CreditModel
    let dataManager = DataManager()
    
    init(creditModel: CreditModel) {
        self.creditModel = creditModel
        
        self.title = creditModel.title
        self.zeroDate = creditModel.zeroDate.toDate
        self.amount = creditModel.amount
        self.period = creditModel.period
        self.rate = creditModel.rate
        self.advancePayments = creditModel.advancePayments
        self.endDateDouble = calendar.addingMonths(value: period, to: zeroDate)
        calendar.locale = .current
        initialSetup()
    }
    
    private(set) var title: String
    private(set) var zeroDate: Date // Дата выдачи кредита
    private(set) var amount: Decimal
    private(set) var period: Int // изначальное количество месяцев из модели, но оно может меняться, поэтому создана переменная currentPeriod
    private(set) var rate: Decimal
    private(set) var advancePayments: Payments
    private(set) var endDateDouble: Double
    
    private func initialSetup() {
        monthlyPayment = monthlyCalc(amount: amount, period: period, rate: rate)
        currentMonthlyPayment = monthlyPayment
        updateDictionary(path: .fromUserDefaults)
    }
    
    private(set) var monthlyPayment: Decimal = 0 /// !!! по задумке высчитывается единожды при инициализации и нигде не меняется больше, либо если пришла обновленная модель из замыкания из EditViewModel

    private(set) var currentMonthlyPayment: Decimal = 0 //variable value of the monthly payment

    private var isPassed: Bool = false
    private(set) var remainder: Decimal = 0
    private(set) var currentPeriod: Int = 0
    private(set) var totalAmount: Decimal = 0
    private(set) var interestAmount: Decimal = 0
    private(set) var principalAmount: Decimal = 0
    private(set) var interestDiff: Decimal = 0
    
    private(set) var interestAmountOldValue: Decimal = 0 {
        didSet {
            interestDiff = (oldValue - interestAmountOldValue).round()
        }
    }
    
    var zeroMonthNumber: Int { return calendar.component(.month, from: zeroDate) }
    var zeroYearNumber: Int { return calendar.component(.year, from: zeroDate) }
    var years: Int { return calcNumberOfYears(startDate: zeroDate.addMonth.toDate, period: numberOfMonths) }

    private var allRemainders: [Double: Decimal] = [:]
    
    func getRemainder(_ date: Date = Date()) -> Decimal {
        if zeroDate > date { return amount }
        
        let dateDouble = date.modify.toDouble
        let keyes = allRemainders.keys.sorted { $0 < $1 }
//        print(keyes)
//        print(dateDouble)
        guard let date = keyes.last(where: { dateDouble > $0 }), let amountByKey = allRemainders[date] else {
            print("Couldn't find date in dictionary, func getRemainder")
            return amount
        }
        return amountByKey
    }
    
    func updateModel(calcModel: CreditModel) { //update from closure
        self.creditModel = calcModel
        
        title = creditModel.title
        zeroDate = creditModel.zeroDate.toDate
        amount = creditModel.amount
        period = creditModel.period
        rate = creditModel.rate

        initialSetup()
    }

    func updateDictionary(path: FetchPath) {
        switch path {
        case .fromUserDefaults:
            let credits = dataManager.fetchCreditsUD()
            
            if !credits.isEmpty {
                let advancePayment = creditModel.advancePayments
                transformedPayments = transformDictionary(dictionary: advancePayment)
            } else { transformedPayments = [:] }
            
        case .temporary(let paymentStructTemp):
            ///необходимо чтобы текущий платеж всегда изначально был равен первоначальному пересчет ежемесячного платежа чтобы правильно пересчитало выгоду. Пересчет скоре всгео не нужен
            currentMonthlyPayment = monthlyPayment
            transformedPayments = transformDictionary(dictionary: paymentStructTemp)
        }
        populateArray()
    }

    private var transformedPayments: TransformedPayments = [:]
    
    private func transformDictionary(dictionary: Payments) -> TransformedPayments {
        
        var dict: TransformedPayments = [:]
        
        for (dateDouble, value) in dictionary {
                        
            let periodInMonths = calcNumberOfMonths(startDate: zeroDate, finalDate: dateDouble.toDate)
            
            guard let payment = value.first?.key, let type = value.first?.value else {
                print("Ошибка в методе transformDictionary, не найдеты элементы в словаре")
                return [:]
            }
            let monthNumber = zeroMonthNumber == 12 ? 0 : zeroMonthNumber
            if dict.keys.contains(periodInMonths + monthNumber) {
                
                var values = dict[periodInMonths + monthNumber]
                values?.append((dateDouble: dateDouble, payment: payment, type: type))
                dict[periodInMonths + monthNumber] = values?.sorted(by: { $0.dateDouble < $1.dateDouble })
    
            } else {
                dict[periodInMonths + monthNumber] = [(dateDouble: dateDouble, payment: payment, type: type)]
            }
        }
//        print("dict", dict)
        return dict
    }
    
    private func calcNumberOfMonths(startDate: Date, finalDate: Date) -> Int {

        if finalDate < startDate {
            return 0
        } else {
            let monthRange = calendar.monthRange(from: startDate.modify, to: finalDate)
            return finalDate.toDouble == startDate.addMonths(value: monthRange) ? monthRange - 1 : monthRange
        }
    }

    private(set) var advancePaymentsDict: AdvancePayments = [:]

    private(set) var remainders: [Int: Decimal] = [:] //массив словарей с остатком основного долга

    private(set) var numberOfMonths: Int = 0 /// количество рядов(месяцев) для таблицы
    private(set) var resultsArray: [[[String]]] = []
    
    func populateArray() {
        numberOfMonths = 0
        currentPeriod = period
        
        if isPassed {
            totalAmount = 0
            interestAmount = 0
            principalAmount = 0
        } else { isPassed = true }
        
        allRemainders.removeAll()
        
        var rowArray: [String] = []
        var sectionArray: [[String]] = []
        var tableArray: [[[String]]] = []
        
        var interestArray: [String] = []

        var interestPayment: Decimal
        var daysInYear: Decimal
        var daysInMonth: Int = 0
        var overallMonthlyPayment: Decimal = 0
        var section: Int = 0
        var remainderOfLoan: Decimal = amount
        
        var monthNumber: Int = zeroMonthNumber == 12 ? 0 : zeroMonthNumber ///zeroMonthNumber значение месяца из календаря от 1...12, а monthNumber = 0...11
        var currentYear: Int
        
        var month: Months
        
        var intermediateInterest: Decimal = 0
        var intermediateRemainder: Decimal = 0
        
        var previousDate: Double = zeroDate.toDouble
        var nextDate: Double = previousDate.toDate.addMonth
        
        var isLastRow = false
        
        while remainderOfLoan > 0 {
            
            if monthNumber < 12 {
                section = 0
                month = Months(rawValue: monthNumber)! // value 0...11
            } else {
                if monthNumber % 12 == 0 {
                    section += 1
                    tableArray.append(sectionArray)
                    sectionArray.removeAll()
                }
                month = Months(rawValue: monthNumber % 12)!
            }
            
            currentYear = zeroMonthNumber == 12 ? zeroYearNumber + section + 1 : zeroYearNumber + section
            
            daysInYear = calcDaysInYear(currentYear: currentYear, month: month, zeroDate: zeroDate)
            
            rowArray.append(calendar.shortStandaloneMonthSymbols[month.rawValue])
            
            switchMonth(month: month, currentYear: currentYear, daysInMonth: &daysInMonth)
            
            interestPayment = calcInterestPayment(remainderOfLoan: remainderOfLoan, rate: rate, periodDays: daysInMonth, daysInYear: daysInYear)
//            print("interestPayment", interestPayment)
            
            var paymentsRow: String = currentMonthlyPayment.asString
            var interestRow: String = interestPayment.asString
            var principalRow: String = (currentMonthlyPayment - interestPayment).asString
            
            if let advancePayments = transformedPayments[monthNumber] { // если есть какое-то значение то учитваем его и тип досрочного платежа
                
                overallMonthlyPayment = 0
                intermediateRemainder = remainderOfLoan
                
                var passedDays: Int = 0
                var interestAccum: Decimal = 0
                var currentInterest: Decimal = 0
                
                paymentsRow = ""
                interestRow = ""
                principalRow = ""
                
                for payment in advancePayments {
                    let type = payment.type
                    let earlyPayment = payment.payment
                    let paymentDateDouble = payment.dateDouble
                    // print("Даты", previousDate.toDate, paymentDateDouble.toDate, nextDate.toDate)
                    
                    overallMonthlyPayment += earlyPayment
                    
                    if paymentDateDouble < zeroDate.toDouble || paymentDateDouble > endDateDouble {
                        print("Платеж за срокам. Если это произошло - это очень странно. Проверка идет при добавлении ДП.")
                        break
                    }
                                        
                    //1. Отсчитываем количество прошедших дней и высчитываем сколько % нужно уплатить за эти дни
                    let range = paymentDateDouble == zeroDate.addMonth ? 0 : calendar.dayRange(from: previousDate, to: paymentDateDouble)
                    
                    passedDays += range
                    
                    intermediateInterest = calcInterestPayment(remainderOfLoan: intermediateRemainder, rate: rate, periodDays: range, daysInYear: daysInYear)
                    
                    if earlyPayment - intermediateInterest >= intermediateRemainder {
                        
                        isLastRow = true
                        remainderOfLoan = 0
                        
                        let maxPayment = intermediateRemainder + intermediateInterest
                        paymentsRow += paymentsRow.isEmpty ? maxPayment.asString : "\n\(maxPayment.asString)"
                        interestRow += interestRow.isEmpty ? intermediateInterest.asString : "\n\(intermediateInterest.asString)"
                        principalRow += principalRow.isEmpty ? maxPayment.asString : "\n\(maxPayment.asString)"
                        
                        totalAmount += maxPayment
                        interestAmount += intermediateInterest
                        principalAmount += maxPayment
                        allRemainders[paymentDateDouble] = 0
                        break
                    }
                    
                    intermediateInterest += (currentInterest - interestAccum)
                    
                    currentInterest = intermediateInterest

                    if earlyPayment <= intermediateInterest { //если платеж меньше необъодимых процентов
                        intermediateInterest = earlyPayment
                    }
                    
                    paymentsRow += paymentsRow.isEmpty ? earlyPayment.asString : "\n\(earlyPayment.asString)"
                    interestRow += interestRow.isEmpty ? (intermediateInterest.asString) : "\n\(intermediateInterest.asString)"
                    var overallPayment = (earlyPayment - intermediateInterest).asString
                    principalRow += principalRow.isEmpty ? overallPayment : "\n\(overallPayment)"
                    
                    //2. Добавляем платеж как часть общих % платежа за месяц
                    interestAccum += intermediateInterest
                    
                    //3. Вычисляем часть платежа какая пойдет на погашение основного долга
                    intermediateRemainder -= (earlyPayment - intermediateInterest)
                    
                    allRemainders[paymentDateDouble] = intermediateRemainder
                    
                    //4.Вычисляем оставшуюся часть %
                    
                    if paymentDateDouble == zeroDate.addMonth {
                        intermediateInterest = calcInterestPayment(remainderOfLoan: remainderOfLoan, rate: rate, periodDays: daysInMonth - passedDays, daysInYear: daysInYear)
                    } else {
                        if earlyPayment <= currentInterest {
                            intermediateInterest = interestPayment - interestAccum // надо подумать
                        } else {
                            intermediateInterest = calcInterestPayment(remainderOfLoan: intermediateRemainder, rate: rate, periodDays: daysInMonth - passedDays, daysInYear: daysInYear)
                        }
                    }
                    
                    let oldPeriod = currentPeriod
                    let oldMonthlyPayment = currentMonthlyPayment
                    let actualMonthNumber = zeroMonthNumber == 12 ? 0 : zeroMonthNumber
                    
                    if type { // уменьшение периода
                        let localPeriod = periodRecalcule(creditAmountLeft: remainderOfLoan - (overallMonthlyPayment - interestAccum), monthlyPayment: currentMonthlyPayment, percentage: rate)
                        
                        currentPeriod = monthNumber - (actualMonthNumber) + localPeriod /// ничего или -1 (либо менять round.up подумать)
                                                
                    } else { // уменьшение платежа
                        
                        if earlyPayment > currentInterest  {
                            
                            let internalPeriod = currentPeriod - (monthNumber - actualMonthNumber)
                            
                            if paymentDateDouble == zeroDate.addMonth {
                                ///проверку на первый платеж добавил, чтобы если это быд первый платеж, то был правильный пересчет платежа
                                currentMonthlyPayment = monthlyCalc(amount: intermediateRemainder - (oldMonthlyPayment - intermediateInterest), period: internalPeriod - 1, rate: rate)
                            } else {
                                currentMonthlyPayment = monthlyCalc(amount: remainderOfLoan - (earlyPayment - interestAccum), period: internalPeriod, rate: rate)
                            }
                        }
                    }
                    
                    advancePaymentsDict[paymentDateDouble] = (oldPayment: oldMonthlyPayment, newPayment: currentMonthlyPayment, monthDiff: oldPeriod - currentPeriod, interestDiff: interestDiff)
                    
                    //проверка, если остаток от досрочного платежа, меньше ежемесячного платежа
                    if intermediateRemainder + intermediateInterest < currentMonthlyPayment {
                        isLastRow = true
                        totalAmount += remainderOfLoan
                        
                        let maxPayment = intermediateRemainder + intermediateInterest
                        paymentsRow += paymentsRow.isEmpty ? maxPayment.asString : "\n\(maxPayment.asString)"
                        interestRow += interestRow.isEmpty ? intermediateInterest.asString : "\n\(intermediateInterest.asString)"
                        principalRow += principalRow.isEmpty ? intermediateRemainder.asString : "\n\(intermediateRemainder.asString)"
                        
                        interestAmount += intermediateInterest
                        principalAmount += maxPayment
                        totalAmount += maxPayment
                        remainderOfLoan = 0
                        allRemainders[paymentDateDouble] = 0
                        break
                    }
                    
                    //5. Если платеж последний, тогда добавляем данный платеж как часть общих % платежа за месяц
                    if payment == advancePayments.last! {

                        paymentsRow += "\n\(oldMonthlyPayment.asString)"
                        
                        overallPayment = (oldMonthlyPayment - intermediateInterest).asString
                        principalRow += "\n\(overallPayment)"
                        
                        interestRow += "\n\(intermediateInterest.asString)"
                        interestAccum += intermediateInterest
                        
                        //6. Общая сумма % в месяц равна общей сумме частичных процентов от каждого досрочного платежа.
                        interestPayment = interestAccum
                        overallMonthlyPayment += oldMonthlyPayment
                        
                    } else {
                        //6. Общая сумма % в месяц равна общей сумме частичных процентов от каждого досрочного платежа.
                        interestPayment = intermediateInterest + interestAccum
                    }
                    //7. Если платежей несколько, то предыдущей датой отсчета дней будет текущая дата предварительных платежей.
                    previousDate = paymentDateDouble
                }
            } else { // если нет досрочных платежей
                overallMonthlyPayment = currentMonthlyPayment
            }
            if remainderOfLoan - interestPayment > currentMonthlyPayment {
                
                remainderOfLoan -= (overallMonthlyPayment - interestPayment)
                remainders[monthNumber] = remainderOfLoan
                allRemainders[nextDate] = remainderOfLoan
                
                rowArray.append(paymentsRow) // ежемесячный платеж
                rowArray.append(interestRow) // проценты за месяц
                rowArray.append(principalRow) // основная часть долга за месяц
                rowArray.append(remainderOfLoan.asString) // основная часть долга
                
                totalAmount += overallMonthlyPayment
                interestAmount += interestPayment
                principalAmount += overallMonthlyPayment - interestPayment
                
                interestArray.append(interestAmount.asString)
                
                sectionArray.append(rowArray)
                rowArray.removeAll()
                
            } else { // заполнение последнего месяца
                
                if isLastRow {
                    rowArray.append(paymentsRow) // ежемесячный платеж
                    rowArray.append(interestRow) // проценты за месяц
                    rowArray.append(principalRow) // основная часть долга за месяц
                    rowArray.append(remainderOfLoan.asString) // основная часть долга
                } else {
                    rowArray.append((remainderOfLoan + interestPayment).asString)
                    rowArray.append(interestPayment.asString)
                    rowArray.append(remainderOfLoan.asString)
                    rowArray.append((remainderOfLoan - remainderOfLoan).asString)
                    
                    totalAmount += remainderOfLoan + interestPayment
                    interestAmount += interestPayment
                    principalAmount += remainderOfLoan
                }
                
                interestArray.append(interestAmount.asString)
                remainderOfLoan = 0
                remainders[monthNumber] = 0
                allRemainders[nextDate] = 0

                sectionArray.append(rowArray)
                rowArray.removeAll()
                tableArray.append(sectionArray)
                sectionArray.removeAll()
            }
            monthNumber += 1
            numberOfMonths += 1
            previousDate = nextDate
            nextDate = previousDate.toDate.addMonth
        }
        interestAmountOldValue = interestAmount
        self.resultsArray = tableArray
        endDateDouble = calendar.addingMonths(value: numberOfMonths, to: zeroDate)
//        print("numberOfMonths", numberOfMonths)
//        print("years", years)
//        print(tableArray)
//        print(allRemainders.sorted(by: { $0.key < $1.key }), allRemainders.count)
    }
}

//MARK:- Calculations

private extension Calculator {
    
    func switchMonth(month: Months, currentYear: Int, daysInMonth: inout Int) {
        
        switch month {
        case .january, .february, .april, .june, .august, .september, .november:
            daysInMonth = 31
        case .march:
            daysInMonth = currentYear.isLeapYear ? 29 : 28
        case .may, .july, .october, .december:
            daysInMonth = 30
        }
    }
    
    func logC(val: Decimal, forBase base: Decimal) -> Decimal {
        return (log(val.asDouble)/log(base.asDouble)).asDecimal
    }
    
    func periodRecalcule(creditAmountLeft: Decimal, monthlyPayment: Decimal, percentage: Decimal) -> Int {
        let monthlyPercent = percentage / 12 / 100
        let overallPercent = monthlyPayment / (monthlyPayment - creditAmountLeft * monthlyPercent)
        let period = logC(val: overallPercent, forBase: 1 + monthlyPercent)
        return period.round(0, .up).asInt
    }
    
    func monthlyCalc(amount: Decimal, period: Int, rate: Decimal) -> Decimal {
        if amount == 0 || period == 0 { return 0 }
        if rate == 0 { return amount / period.asDecimal }
        let monthlyPercent = rate / 12 / 100
        let overallPercent = pow(1 + monthlyPercent, period)
        let monthlyPayment = amount * monthlyPercent * overallPercent / (overallPercent - 1)
        return monthlyPayment.round()
    }
    
    func calcInterestPayment(remainderOfLoan: Decimal, rate: Decimal, periodDays: Int, daysInYear: Decimal) -> Decimal {
        return (remainderOfLoan * rate * periodDays.asDecimal / daysInYear / 100).round()
    }
    
    func calcDaysInYear(currentYear: Int, month: Months, zeroDate: Date) -> Decimal {
        let paymentDay = (calendar.component(.day, from: zeroDate)).asDecimal
        
        if (currentYear - 1).isLeapYear && month == .january { return (365 * 366) / (365 + paymentDay / 31) }

        if currentYear.isLeapYear && month == .january { return (365 * 366) / (366 - paymentDay / 31) }
    
        return currentYear.isLeapYear ? 366 : 365
    }
    
    func calcNumberOfYears(startDate: Date, period: Int) -> Int {
        let startYear = calendar.component(.year, from: startDate)
        let startMonth = calendar.component(.month, from: startDate)
        let components = DateComponents(calendar: calendar, year: startYear, month: startMonth, day: 15, hour: 12)
        guard let startDateModified = calendar.date(from: components),
              let finalDate = calendar.date(byAdding: .month, value: period - 1, to: startDateModified) else { return 1 }
        
        let finalDateYear = calendar.component(.year, from: finalDate)
        let years = finalDateYear - startYear + 1
        return startMonth == 12 ? years - 1 : years
    }
}

enum FetchPath {
    case fromUserDefaults
    case temporary(Payments)
}

enum Months: Int, CaseIterable {
    case january = 0
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
}



//    func remainderAtDate(date: Date) -> Decimal {
//
//        if zeroDate > date {
//            return amount
//        } else {
//            ///--если дата первого платежа раньше, чем текущая дата,  так как даже если 0 то это значит один платеж был совершен, например дата первого платежа = 10.01.2022, то если сегодня 4 февраля, то один платеж был совершен, hasPassedMonths возвращает 0
//            ///-- из zeroMonthNumber в свою очередь нужно вычесть 1, чтобы привести к виду от 0...11, поэтому остается hasPassedMonths + firstMonthNumber - 1
//            ///--словарь remainders ведется с номера месяца первого платежа
//            let hasPassedMonths = calendar.monthRange(from: zeroDate, to: date)
//
//            if hasPassedMonths == 0 {
//                return amount
//            } else {
//                let monthNumber = zeroMonthNumber == 12 ? 0 : zeroMonthNumber
//                guard let remainder = remainders[hasPassedMonths + monthNumber - 1] else { // надо подумать
//                    print("Либо неправильная конвертация даты и подсчет месяцев, либо не найдет элемент в словаре досрочных платежей, метод remainderAtDate")
//                    return 0
//                }
//                return remainder
//            }
//        }
//    }





//    numberOfDaysInYear = currentYear.isLeapYear ? 366 : 365
//
//    if (currentYear - 1).isLeapYear && month == .january {
//        numberOfDaysInYear = (365 * 366) / (365 + paymentDay / 31)
//    }
//
//    if currentYear.isLeapYear && month == .january {
//        numberOfDaysInYear = (365 * 366) / (366 - paymentDay / 31)
//    }
    






//            if let advancePayment = dictModified[monthNumber] { // если есть какое-то значение то учитваем его и тип досрочного платежа
//                guard let type: Bool = advancePayment.values.first else { return }
//
//                let earlyPayment = (dictModified[monthNumber]?.keys.first)!
//                overallMonthlyPayment = currentMonthlyPayment + earlyPayment
//                let oldPeriod = period
//                let oldMonthlyPayment = currentMonthlyPayment
////                let monthString = convertIntDoStringDateDict(monthNumber: monthNumber)
//
//                if type { // уменьшение периода
//                    let localPeriod = periodRecalcule(creditAmountLeft: remainderOfLoan - (overallMonthlyPayment - interestPayment), monthlyPayment: currentMonthlyPayment, percentage: rate)
//
//                    //чтото период считает криво надо подумать, криво считает currentperiod
//                    currentPeriod = Double(monthNumber) - Double(firstMonthNumber - 1) + localPeriod + 1 // ничего или -1
//                    print("==calculator currentPeriod", currentPeriod)
////                    results[monthString] = (oldPayment: oldMonthlyPayment, newPayment: currentMonthlyPayment, monthDiff: Int(oldPeriod - currentPeriod), interestDiff: interestDiff)
//
//
//
//
//                    results[monthNumber] = (oldPayment: oldMonthlyPayment, newPayment: currentMonthlyPayment, monthDiff: Int(oldPeriod - currentPeriod), interestDiff: interestDiff)
//
//                } else { // уменьшение платежа
//
//                    currentMonthlyPayment = monthlyCalc(creditAmount: remainderOfLoan - (overallMonthlyPayment - interestPayment), creditPeriod: currentPeriod - Double((monthNumber - firstMonthNumber + 2)), percentage: rate)
//
////                    let monthString = convertIntDoStringDateDict(monthNumber: monthNumber)
//
////                    results[monthString] = (oldPayment: oldMonthlyPayment, newPayment: currentMonthlyPayment, monthDiff: Int(oldPeriod - currentPeriod), interestDiff: interestDiff)
//                    results[monthNumber] = (oldPayment: oldMonthlyPayment, newPayment: currentMonthlyPayment, monthDiff: Int(oldPeriod - currentPeriod), interestDiff: interestDiff)
//                }
//            } else { // если нет досрочных платежей
//                overallMonthlyPayment = currentMonthlyPayment
//            }



//            switch month {
//
//            case .january:
//                daysInMonth = 31
//                rowArray.append("Январь")
//            case .february:
//                daysInMonth = 31
//                rowArray.append("Февраль")
//            case .march:
//                daysInMonth = currentYear.isLeapYear() ? 29 : 28
//                rowArray.append("Март")
//            case .april:
//                daysInMonth = 31
//                rowArray.append("Апрель")
//            case .may:
//                daysInMonth = 30
//                rowArray.append("Май")
//            case .june:
//                daysInMonth = 31
//                rowArray.append("Июнь")
//            case .july:
//                daysInMonth = 30
//                rowArray.append("Июль")
//            case .august:
//                daysInMonth = 31
//                rowArray.append("Август")
//            case .september:
//                daysInMonth = 31
//                rowArray.append("Сентябрь")
//            case .october:
//                daysInMonth = 30
//                rowArray.append("Октябрь")
//            case .november:
//                daysInMonth = 31
//                rowArray.append("Ноябрь")
//            case .december:
//                daysInMonth = 30
//                rowArray.append("Декабрь")
//            }

//        case .january, .march, .may, .july, .august, .october, .december:
//            daysInMonth = 31
//        case .april, .june, .september, .november:
//            daysInMonth = 30
//        case .february:
//            daysInMonth = isLeapYear(year: nowYear) ? 29 : 28
//        }
        


//    func calcNextPaymentDate() -> String {
//
//        let nextDate: Date
//
//        let firstDay = calendar.component(.day, from: firstPaymentDate)
//
//        let now = Date()
//        let nowYear = calendar.component(.year, from: now)
//        let nowMonth = calendar.component(.month, from: now)
//
//        var nextPaymentDay: Int
//
//        let currentMonth = Months(rawValue: nowMonth - 1)!
//
//        switch currentMonth {
//
//        case .january:
//            if firstDay == 29 || firstDay == 30 || firstDay == 31 {
//                nextPaymentDay = nowYear.isLeapYear() ? 29 : 28
//            } else {
//                nextPaymentDay = firstDay
//            }
//        case .february, .april, .june, .july, .september, .november, .december:
//            nextPaymentDay = firstDay
//        case .march, .may, .august, .october:
//            nextPaymentDay = firstDay == 31 ? 30 : firstDay
//        }
//
//        if firstPaymentDate > Date() { /// если дата первого платежа еще не настала, то дата след платежа будет датой первого платежа
//            nextDate = firstPaymentDate
//        } else {
//            let dateComponents = DateComponents(calendar: calendar, year: nowYear, month: nowMonth + 1, day: nextPaymentDay, hour: 12)
//            guard let nextDateModified = calendar.date(from: dateComponents) else { return "" }
//            nextDate = nextDateModified
//        }
//
//        dateFormatter.dateFormat = "dd.MM.yy"
//        return dateFormatter.string(from: nextDate)
//    }




//СКОРЕЕ ВСЕГО ШЛЯПА КАКАЯ-ТО НИЖЕ

//    func convertIntDoStringDateDict(monthNumber: Int) -> String {
//        dateFormatter.dateFormat = "MM/yyyy"
//        let value = monthNumber + 1 - firstMonthNumber
//        guard let startMonth = calendar.date(byAdding: .month, value: value, to: firstPaymentDate) else { return "" }
//
//        let monthString = dateFormatter.string(from: startMonth)
//        return monthString
//    }

//    func convertIntToDateInDouble(monthNumber: Int) -> String {
//        let value = monthNumber + 1 - firstMonthNumber
//        guard let startMonth = calendar.date(byAdding: .month, value: value, to: firstPaymentDate) else { return "" }
//
//        return monthString
//    }

//    private var dictModified: [Int : [Double : Bool]] = [:]
    
    
//    func transformDictionary(dictionary: Payments) -> [Int : [Double : Bool]] {
//        var mutatedDict: [Int : [Double : Bool]] = [:]
//
//        for (date, value) in dictionary {
//            let finalDate = Date(timeIntervalSince1970: date)
//            let periodInMonths = calcNumberOfMonths(startDate: firstPaymentDate, finalDate: finalDate)
//            mutatedDict[periodInMonths + firstMonthNumber - 1] = value
//
//            results[periodInMonths + firstMonthNumber - 1] = (oldPayment: 0, newPayment: 0, monthDiff: 0, interestDiff: 0)
//            resultDateDict[date] = periodInMonths + firstMonthNumber - 1
//        }
//
//
////        print("resultDateDict", resultDateDict)
//        print("arrayDict", arrayDict)
////        print("==Calculator, mutatedDict", mutatedDict)
//        return mutatedDict
//    }
