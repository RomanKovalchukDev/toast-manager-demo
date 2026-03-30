//
//  ToastManager.swift
//  CIRASharedUI
//
//  Created by Roman Kovalchuk on 12.01.2026.
//

import SwiftUI

@Observable
open class ToastManager {
    var toast: ToastData?
    
    open func showToast(_ toast: ToastData, autoDismissDelay: TimeInterval = 2.5) {
        self.toast = toast
        
        DispatchQueue.main.asyncAfter(deadline: .now() + autoDismissDelay) { [weak self] in
            self?.toast = nil
        }
    }
}
