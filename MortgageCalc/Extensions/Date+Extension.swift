//
//  Date+Extension.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 1/31/22.
//

import Foundation

extension Date {
    
    func calcNextPaymentDate(_ format: String = "dd.MM.yyyy") -> String {
        let calendar = Calendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        
        var nextDate: Date
        
        let firstDay = calendar.component(.day, from: self)
        
        let now = Date()
        let nowYear = calendar.component(.year, from: now)
        let nowMonth = calendar.component(.month, from: now)
        let nowDay = calendar.component(.day, from: now)
                
        var nextPaymentDay: Int
        var nextPaymentMonth: Int

        if self > Date() { 
            nextDate = self
        } else {
            
            let currentMonth = Months(rawValue: nowMonth - 1)
            
            switch currentMonth {

            case .january: ///если число в текущем месяце еще не наступило, то брать это число, иначе брать дату в след месяц
                if firstDay >= nowDay {
                    nextPaymentDay = firstDay
                    nextPaymentMonth = nowMonth
                } else {
                    if firstDay == 29 || firstDay == 30 || firstDay == 31 {
                        nextPaymentDay = nowYear.isLeapYear ? 29 : 28
                        nextPaymentMonth = nowMonth + 1
                    } else {
                        nextPaymentDay = firstDay
                        nextPaymentMonth = nowMonth + 1
                    }
                }
            
            case .february:
                if firstDay >= nowDay {
                    
                    if firstDay == 29 || firstDay == 30 || firstDay == 31 {
                        nextPaymentDay = nowYear.isLeapYear ? 29 : 28
                        nextPaymentMonth = nowMonth
                    } else {
                        nextPaymentDay = firstDay
                        nextPaymentMonth = nowMonth
                    }
                } else {
                    nextPaymentDay = firstDay
                    nextPaymentMonth = nowMonth + 1
                }
            
            case .march, .may, .august, .october:
                if firstDay >= nowDay {
                    nextPaymentDay = firstDay
                    nextPaymentMonth = nowMonth

                } else {
                    nextPaymentDay = firstDay == 31 ? 30 : firstDay
                    nextPaymentMonth = nowMonth + 1
                }
                
            case .july, .december:
                if firstDay >= nowDay {
                    nextPaymentDay = firstDay
                    nextPaymentMonth = nowMonth
                } else {
                    nextPaymentDay = firstDay
                    nextPaymentMonth = nowMonth + 1
                }
                
            case .april, .june, .september, .november:
                if firstDay >= nowDay {
                    nextPaymentDay = firstDay == 31 ? 30 : firstDay
                    nextPaymentMonth = nowMonth

                } else {
                    nextPaymentDay = firstDay
                    nextPaymentMonth = nowMonth + 1
                }
                
            case .none:
                print("Месяц не в диапазоне")
                nextPaymentDay = firstDay
                nextPaymentMonth = nowMonth
            }
            
            let dateComponents = DateComponents(calendar: calendar, year: nowYear, month: nextPaymentMonth, day: nextPaymentDay, hour: 12)
            guard let nextDateModified = calendar.date(from: dateComponents) else { return "" }
            nextDate = nextDateModified
        }

        dateFormatter.dateFormat = format
        return dateFormatter.string(from: nextDate)
    }
    
    
    
    func calcNextDate() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        
        var nextDate: Date
        
        let firstDay = calendar.component(.day, from: self)
        
        let now = Date()
        let nowYear = calendar.component(.year, from: now)
        let nowMonth = calendar.component(.month, from: now)
        let nowDay = calendar.component(.day, from: now)
                
        var nextPaymentDay: Int
        var nextPaymentMonth: Int
        
        if self > Date() { /// если дата первого платежа еще не настала, то дата след платежа будет датой первого платежа
            nextDate = self
        } else {
            
            let currentMonth = Months(rawValue: nowMonth - 1)
            
            switch currentMonth {

            case .january: ///если число в текущем месяце еще не наступило, то брать это число, иначе брать дату в след месяц
                if firstDay >= nowDay {
                    nextPaymentDay = firstDay
                    nextPaymentMonth = nowMonth
                } else {
                    if firstDay == 29 || firstDay == 30 || firstDay == 31 {
                        nextPaymentDay = nowYear.isLeapYear ? 29 : 28
                        nextPaymentMonth = nowMonth + 1
                    } else {
                        nextPaymentDay = firstDay
                        nextPaymentMonth = nowMonth + 1
                    }
                }
            
            case .february:
                if firstDay >= nowDay {
                    
                    if firstDay == 29 || firstDay == 30 || firstDay == 31 {
                        nextPaymentDay = nowYear.isLeapYear ? 29 : 28
                        nextPaymentMonth = nowMonth
                    } else {
                        nextPaymentDay = firstDay
                        nextPaymentMonth = nowMonth
                    }
                } else {
                    nextPaymentDay = firstDay
                    nextPaymentMonth = nowMonth + 1
                }
            
            case .march, .may, .august, .october:
                if firstDay >= nowDay {
                    nextPaymentDay = firstDay
                    nextPaymentMonth = nowMonth

                } else {
                    nextPaymentDay = firstDay == 31 ? 30 : firstDay
                    nextPaymentMonth = nowMonth + 1
                }
                
            case .july, .december:
                if firstDay >= nowDay {
                    nextPaymentDay = firstDay
                    nextPaymentMonth = nowMonth
                } else {
                    nextPaymentDay = firstDay
                    nextPaymentMonth = nowMonth + 1
                }
                
            case .april, .june, .september, .november:
                if firstDay >= nowDay {
                    nextPaymentDay = firstDay == 31 ? 30 : firstDay
                    nextPaymentMonth = nowMonth

                } else {
                    nextPaymentDay = firstDay
                    nextPaymentMonth = nowMonth + 1
                }
                
            case .none:
                print("Месяц не в диапазоне")
                nextPaymentDay = firstDay
                nextPaymentMonth = nowMonth
            }
            
            let dateComponents = DateComponents(calendar: calendar, year: nowYear, month: nextPaymentMonth, day: nextPaymentDay, hour: 12)
            guard let nextDateModified = calendar.date(from: dateComponents) else { return Date() }
            nextDate = nextDateModified
        }

        return nextDate
    }
    
    func calcNextDateDouble() -> Double {
        let calendar = Calendar(identifier: .gregorian)
                
        let firstDay = calendar.component(.day, from: self)
  
        var nowYear = calendar.component(.year, from: self)
        let nowMonth = calendar.component(.month, from: self)
        
        var nextPaymentDay: Int
        var nextPaymentMonth: Int
        
        let currentMonth = Months(rawValue: nowMonth - 1)
        
        switch currentMonth {
        
        case .january: ///если число в текущем месяце еще не наступило, то брать это число, иначе брать дату в след месяц

            if firstDay == 29 || firstDay == 30 || firstDay == 31 {
                nextPaymentDay = nowYear.isLeapYear ? 29 : 28
                nextPaymentMonth = nowMonth + 1
            } else {
                nextPaymentDay = firstDay
                nextPaymentMonth = nowMonth + 1
            }
            
        case .february, .june, .july, .april, .december:

            nextPaymentDay = firstDay
            
            if currentMonth == .december {
                nextPaymentMonth = 1
                nowYear += 1
            } else {
                nextPaymentMonth = nowMonth + 1
            }
  
        case .march, .may, .august, .october, .september, .november:
            
            nextPaymentDay = firstDay == 31 ? 30 : firstDay
            nextPaymentMonth = nowMonth + 1

        case .none:
            print("Месяц не в диапазоне")
            nextPaymentDay = firstDay
            nextPaymentMonth = nowMonth
        }
        
        let dateComponents = DateComponents(calendar: calendar, year: nowYear, month: nextPaymentMonth, day: nextPaymentDay, hour: 12)
        guard let nextDateModified = calendar.date(from: dateComponents) else {
            print("Проблема с созданием следующей даты")
            return 0
        }

        return nextDateModified.timeIntervalSince1970
    }
}

extension Date {
    
    var modify: Date {
        let calendar = Calendar(identifier: .gregorian)
        
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let hour = 12
        let components = DateComponents(calendar: calendar, year: year, month: month, day: day, hour: hour)
        guard let dateModified = calendar.date(from: components) else {
            print("Error in creating date from components and casting to base view")
            return Date()
        }
        return dateModified
    }
    
    var addMonth: Double {
        let calendar = Calendar(identifier: .gregorian)

        guard let nextDate = calendar.date(byAdding: .month, value: 1, to: self) else {
            print("Error calculating next month date")
            return 0
        }
        return nextDate.timeIntervalSince1970
    }
    
    func addMonths(value: Int) -> Double {
        let calendar = Calendar(identifier: .gregorian)

        guard let nextDate = calendar.date(byAdding: .month, value: value, to: self) else {
            print("Error calculating next month date")
            return 0
        }
        return nextDate.timeIntervalSince1970
    }
    
    var toDouble: Double { return self.timeIntervalSince1970 }
}


