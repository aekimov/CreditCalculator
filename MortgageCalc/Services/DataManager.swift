//
//  DataManager.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 11/27/21.
//

import Foundation

protocol CreditInfoProvider {
    
}

final class DataManager: CreditInfoProvider {
    
//    static let shared = DataManager()
    
    private let defaults = UserDefaults.standard
    
//    private init() { }
    
    ///чтение и запись словаря с досрочными платежами
//    func fetchAdvancePayments() -> [String: Double] {
//        let advancePaymentsDict = defaults.object(forKey: Keys.advancePayments) as? [String: Double] ?? [:]
//        return advancePaymentsDict
//    }
//    
//    func saveAdvancePayments(dictionary: [String: Double]) {
//        defaults.set(dictionary, forKey: Keys.advancePayments)
//    }

    ///надо подумать как со структурой быть
    
    init() {
        savedCredits = fetchCreditsUD()
//        print(savedCredits)
    }
    
    private var savedCredits: [CreditModel] = []
    
    func updateCredit(updatedCredit: CreditModel, section: Int) {
        savedCredits[section] = updatedCredit
        saveCreditsUD(credits: savedCredits)
    }
    
    func deleteCredit(section: Int) {
        savedCredits.remove(at: section)
        saveCreditsUD(credits: savedCredits)
    }
    
    func saveCreditsUD(credits: [CreditModel]) {
        let data = try? PropertyListEncoder().encode(credits)
        defaults.set(data, forKey: Keys.credits)
    }
    
    func fetchCreditsUD() -> [CreditModel] {
        guard let data = defaults.data(forKey: Keys.credits),
              let credits = try? PropertyListDecoder().decode([CreditModel].self, from: data) else { return [] }
        return credits
    }
    

    
    
    
    
    func saveAdvancePaymentStruct(paymentInfo: Payments) {
        let data = try? PropertyListEncoder().encode(paymentInfo)
        defaults.set(data, forKey: Keys.structAdvancePayments)
    }
    
    func fetchAdvancePaymentStruct() -> Payments? {
        guard let data = defaults.data(forKey: Keys.structAdvancePayments),
              let fetchedData = try? PropertyListDecoder().decode(Payments.self, from: data) else { return nil }
//        print(fetchedData)
        return fetchedData
    }
    
    func deleteAdvancePayments() {
        defaults.removeObject(forKey: Keys.structAdvancePayments)
    }

    
    private enum Keys {
        
//        static let initialData = "initialData"
        static let credits = "credits"
        
        static let creditAmount = "creditAmount"
        static let creditPeriod = "creditPeriod"
        static let percentage = "percentage"
        static let firstPaymentMonth = "firstPaymentMonth"
        static let advancePayments = "advancePayments"
        static let structAdvancePayments = "structAdvancePayments"
    }
    
    func fetchCreditAmount() -> Double {
        let creditAmount = defaults.double(forKey: Keys.creditAmount)
        return creditAmount
    }
    
    func fetchCreditPeriod() -> Double {
        let creditPeriod = defaults.double(forKey: Keys.creditPeriod)
        return creditPeriod
    }
    
    func fetchPercentage() -> Double {
        let percentage = defaults.double(forKey: Keys.percentage)
        return percentage
    }
    
    func fetchFirstPaymentMonth() -> Double {
        let firstPaymentMonth = defaults.double(forKey: Keys.firstPaymentMonth)
        return firstPaymentMonth
    }
    
    func saveCreditAmount(creditAmount: Double) {
        defaults.set(creditAmount, forKey: Keys.creditAmount)
    }
    
    func saveCreditPeriod(creditPeriod: Double) {
        defaults.set(creditPeriod, forKey: Keys.creditPeriod)
    }
    
    func savePercentage(percentage: Double) {
        defaults.set(percentage, forKey: Keys.percentage)
    }
    
    func saveFirstPaymentMonth(firstPaymentMonth: Double) {
        defaults.set(firstPaymentMonth, forKey: Keys.firstPaymentMonth)
    }
    

    

//    func saveData(creditAmount: String) {
//        let creditInfoDto: CreditInfoDTO
//
//        if let savedCreditInfoDto = fetchData() {
//            creditInfoDto = CreditInfoDTO(creditAmount: creditAmount, creditPeriod: savedCreditInfoDto.creditPeriod, percentage: savedCreditInfoDto.percentage, firstPaymentMonth: savedCreditInfoDto.firstPaymentMonth)
//        } else {
//            creditInfoDto = CreditInfoDTO(creditAmount: creditAmount, creditPeriod: nil, percentage: nil, firstPaymentMonth: nil)
//        }
//        do {
//            let data = try JSONEncoder().encode(creditInfoDto)
//            defaults.set(data, forKey: Keys.initialData)
//        } catch {
//            print("Failed to encode", error)
//        }
//    }
//
    
//
//    func saveData(creditPeriod: String) {
//        let creditInfoDto: CreditInfoDTO
//
//        if let savedCreditInfoDto = fetchData() {
//            creditInfoDto = CreditInfoDTO(creditAmount: savedCreditInfoDto.creditAmount, creditPeriod: creditPeriod, percentage: savedCreditInfoDto.percentage, firstPaymentMonth: savedCreditInfoDto.firstPaymentMonth)
//        } else {
//            creditInfoDto = CreditInfoDTO(creditAmount: nil, creditPeriod: creditPeriod, percentage: nil, firstPaymentMonth: nil)
//        }
//        do {
//            let data = try JSONEncoder().encode(creditInfoDto)
//            defaults.set(data, forKey: Keys.creditPeriod)
//        } catch {
//            print("Failed to encode", error)
//        }
//    }
//
//    func saveData(percentage: String) {
//        let creditInfoDto: CreditInfoDTO
//
//        if let savedCreditInfoDto = fetchData() {
//            creditInfoDto = CreditInfoDTO(creditAmount: savedCreditInfoDto.creditAmount, creditPeriod: savedCreditInfoDto.creditPeriod, percentage: percentage, firstPaymentMonth: savedCreditInfoDto.firstPaymentMonth)
//        } else {
//            creditInfoDto = CreditInfoDTO(creditAmount: nil, creditPeriod: nil, percentage: percentage, firstPaymentMonth: nil)
//        }
//        do {
//            let data = try JSONEncoder().encode(creditInfoDto)
//            defaults.set(data, forKey: Keys.percentage)
//        } catch {
//            print("Failed to encode", error)
//        }
//    }
//
//    func saveData(firstPaymentMonth: Date) {
//        let creditInfoDto: CreditInfoDTO
//
//        if let savedCreditInfoDto = fetchData() {
//            creditInfoDto = CreditInfoDTO(creditAmount: savedCreditInfoDto.creditAmount, creditPeriod: savedCreditInfoDto.creditPeriod, percentage: savedCreditInfoDto.percentage, firstPaymentMonth: firstPaymentMonth)
//        } else {
//            creditInfoDto = CreditInfoDTO(creditAmount: nil, creditPeriod: nil, percentage: nil, firstPaymentMonth: firstPaymentMonth)
//        }
//        do {
//            let data = try JSONEncoder().encode(creditInfoDto)
//            defaults.set(data, forKey: Keys.firstPaymentMonth)
//        } catch {
//            print("Failed to encode", error)
//        }
//    }
}


struct CreditInfoDTO: Codable {
    let creditAmount: String?
    let creditPeriod: String?
    let percentage: String?
    let firstPaymentMonth: Date?
}

//extension DataManager {
//
////    static var creditAmount: String {
////        get {
////            let storedValue = defaults.string(forKey: Keys.creditAmount)
////            return storedValue ?? "55"
////        }
////        set {
////            defaults.set(newValue, forKey: Keys.creditAmount)
////        }
////    }
//
//
//    private var userStateKey: String { return "FirstTimeUser" }
//
//    /// Mocks an asynchronous call to check if this is the first time the user has loaded the app.
//
//    func fetchUserState(isFirstTimeUser: @escaping (Bool) -> Void) {
//        isFirstTimeUser(defaults.string(forKey: userStateKey) == nil)
//    }
//
//    /// Saves the user status to the data service.
//
//    func set(isFirstTimeUser: Bool) {
//        isFirstTimeUser ? defaults.removeObject(forKey: userStateKey) : defaults.set(userStateKey, forKey: userStateKey)
//    }
//
//}
