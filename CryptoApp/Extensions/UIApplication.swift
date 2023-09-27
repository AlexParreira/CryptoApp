//
//  UIApplication.swift
//  CryptoApp
//
//  Created by Alexander Parreira on 27/09/23.
//

import Foundation
import SwiftUI

extension UIApplication{
    
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
