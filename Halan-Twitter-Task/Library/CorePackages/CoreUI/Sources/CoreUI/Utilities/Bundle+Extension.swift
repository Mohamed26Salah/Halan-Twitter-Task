//
//  Bundle+Extension.swift
//  CoreUI
//
//  Created by Mohamed Salah on 20/12/2025.
//

import Foundation

extension Bundle {
    /// The bundle for the CoreUI module
    public static var coreUI: Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        // Fallback for non-SPM builds
        return Bundle.main
        #endif
    }
}

