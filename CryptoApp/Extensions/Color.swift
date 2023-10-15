//
//  Color.swift
//  CryptoApp
//
//  Created by Alexander Parreira on 22/09/23.
//

import Foundation
import SwiftUI
extension Color {
    
    static let theme = ColorTheme()
    static let launch = LaunchTheme()
    
}


struct ColorTheme{
    
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryTextColor = Color("SecondaryTextColor")
    
    
}

struct LaunchTheme {
    
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
    
}
