//
//  Double.swift
//  CryptoApp
//
//  Created by Alexander Parreira on 23/09/23.
//

import Foundation

extension Double {
    
        ///Converte um Double em uma sequencia com 2 casas decimais
        ///```
        /// Converte 1234.56 para $1,234.56
        ///
        ///```
    private var currencyFormatter2: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        /*
         formatter.locale = .current
         formatter.currencyCode = "usd"
         formatter.currencySymbol = "$"
         */
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    func asCurrencyWith2Decimal() -> String{
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }
    
    
    ///Converte um Double em uma sequencia com 2-6 casas decimais
    ///```
    /// Converte 1234.56 para $1,234.56
    /// Converte 12.3456 para $12.3456
    /// Converte 0.123456 para $0.123456
    ///
    ///```
    private var currencyFormatter6: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        /*
        formatter.locale = .current
        formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        */
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    func asCurrencyWith6Decimal() -> String{
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    func AsNumberString() -> String{
        return String(format: "%.2f",self)
    }
    
    func asPercentString() -> String{
        return AsNumberString() + "%"
    }
}
