//
//  UIColor+Extension.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 3/5/22.
//

import UIKit

extension UIColor {

    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static var myBlue: UIColor {
        return .rgb(red: 35, green: 129, blue: 203)
    }
    
    static var myPink: UIColor {
        return .rgb(red: 176, green: 164, blue: 231)
    }
    
    static var fillColor: UIColor {
        return .rgb(red: 242, green: 246, blue: 248)
    }
    
    static var myGreen: UIColor {
        return .rgb(red: 228, green: 240, blue: 219)
    }
    
    static var bgColor: UIColor {
        return .rgb(red: 241, green: 242, blue: 247)
    }
    
    static var dividerColor: UIColor {
        return .rgb(red: 247, green: 249, blue: 248) //.rgb(red: 236, green: 243, blue: 254) 
    }
    
}
