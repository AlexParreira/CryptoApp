//
//  HapticManager.swift
//  CryptoApp
//
//  Created by Alexander on 05/10/23.
//

import Foundation
import SwiftUI


class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification( type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    
}
