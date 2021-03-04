//
//  Hapitcs.swift
//  Telepole
//
//  Created by 丁涯 on 2021/3/4.
//

import Foundation
import UIKit

class Hapitcs {
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func simpleError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    func simpleWarning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
}
