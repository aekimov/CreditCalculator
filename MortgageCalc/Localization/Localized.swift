//
//  Localized.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 3/12/22.
//

import Foundation

struct Localized {
    
    ///My Credit
    static var myCredit: String { return NSLocalizedString("My credit", comment: "") }
    
    ///Credits
    static var credits: String { return NSLocalizedString("Credits", comment: "") }
    
    ///Add Credit
    static var addCredit: String { return NSLocalizedString("Add Credit", comment: "") }
    
    ///Nothing Added
    static var nothingAdded: String { return NSLocalizedString("Nothing Added", comment: "") }
    
    ///Add your first credit
    static var addFirstCredit: String { return NSLocalizedString("Add your first credit", comment: "") }
    
    ///Payment on
    static var paymentOn: String { return NSLocalizedString("Payment on", comment: "") }
    
    ///Paid
    static var paid: String { return NSLocalizedString("Paid", comment: "") }
    
    ///Balance
    static var balance: String { return NSLocalizedString("Balance", comment: "") }
    
    ///Save
    static var save: String { return NSLocalizedString("Save", comment: "") }
    
    ///Calculation
    static var calculation: String { return NSLocalizedString("Calculation", comment: "") }
    
    ///Title
    static var titleLabel: String { return NSLocalizedString("Title", comment: "") }
    
    ///Enter a title
    static var titlePlaceholder: String { return NSLocalizedString("Enter a title", comment: "") }
    
    ///Amount
    static var amountLabel: String { return NSLocalizedString("Amount", comment: "") }
    
    ///Rate, %
    static var rateLabel: String { return NSLocalizedString("Rate, %", comment: "") }
    
    ///Term, month(s)
    static var periodLabel: String { return NSLocalizedString("Term, month(s)", comment: "") }
    
    ///Date of credit
    static var dateLabel: String { return NSLocalizedString("Date of credit", comment: "") }
    
    ///Monthly payment
    static var monthlyPayment: String { return NSLocalizedString("Monthly payment", comment: "") }
    
    ///Total
    static var totalLabel: String { return NSLocalizedString("Total", comment: "") }
    
    ///Interest
    static var interest: String { return NSLocalizedString("Interest", comment: "") }
    
    ///Show payment schedule
    static var showPaymentSchedule: String { return NSLocalizedString("Show payment schedule", comment: "") }
    
    ///Rate
    static var rate: String { return NSLocalizedString("Rate", comment: "") }

    ///out of
    static var outOf: String { return NSLocalizedString("out of", comment: "") }

    ///Until
    static var creditUntil: String { return NSLocalizedString("Until", comment: "") }

    ///Add advance payment
    static var addAdvancePayment: String { return NSLocalizedString("Add advance payment", comment: "") }

    ///Delete credit?
    static var alertDeleteCredit: String { return NSLocalizedString("Delete credit?", comment: "") }

    ///All information about this credit will be deleted.
    static var alertMessage: String { return NSLocalizedString("All information about this credit will be deleted.", comment: "") }

    ///Advance Payment
    static var advancePayment: String { return NSLocalizedString("Advance Payment", comment: "") }

    ///Term reduction
    static var reducePeriod: String { return NSLocalizedString("Term reduction", comment: "") }
    
    ///Payment reduction
    static var reducePayment: String { return NSLocalizedString("Payment reduction", comment: "") }
    
    ///Invalid date
    static var invalidDate: String { return NSLocalizedString("Invalid date", comment: "") }
    
    ///The selected date is outside the credit schedule.
    static var selectedDateSchedule: String { return NSLocalizedString("The selected date is outside the credit schedule.", comment: "") }
    
    ///Edit payment
    static var editPayment: String { return NSLocalizedString("Edit payment", comment: "") }
    
    ///Due to early repayments, the total cost of the loan will
    static var description: String { return NSLocalizedString("Due to early repayments, the total cost of the loan will ", comment: "") }
    
    ///Loan term will 
    static var termReduction: String { return NSLocalizedString("Loan term will ", comment: "") }
    
    ///month(s).
    static var months: String { return NSLocalizedString("month(s).", comment: "") }

    ///"Monthly payment will "
    static var paymentReduction: String { return NSLocalizedString("Monthly payment will ", comment: "") }
    
    ///decrease by
    static var decreaseBy: String { return NSLocalizedString("decrease by", comment: "") }
    
    ///increase by
    static var increaseBy: String { return NSLocalizedString("increase by", comment: "") }
    
    ///from
    static var from: String { return NSLocalizedString("from", comment: "") }
    
    ///to
    static var to: String { return NSLocalizedString("to", comment: "") }
    
    ///Payment schedule
    static var paymentSchedule: String { return NSLocalizedString("Payment schedule", comment: "") }
    
    ///Date
    static var date: String { return NSLocalizedString("Date", comment: "") }
    
    ///Payment
    static var payment: String { return NSLocalizedString("Payment", comment: "") }
    
    ///Principal
    static var principal: String { return NSLocalizedString("Principal", comment: "") }
    
    ///Incorrect payment amount or date outside the credit range
    static var outOfCreditRange: String { return NSLocalizedString("Incorrect payment amount or date outside the credit range", comment: "") }
    
    ///Settings
    static var settings: String { return NSLocalizedString("Settings", comment: "") }
    
    ///Support
    static var support: String { return NSLocalizedString("Support", comment: "") }

    ///Support
    static var reportText: String { return NSLocalizedString("We are constantly improving our app. So please, if you find any bugs or notice incorrect work, please contact us using the link below. We're also open to your suggestions on improvements.", comment: "") }
}
