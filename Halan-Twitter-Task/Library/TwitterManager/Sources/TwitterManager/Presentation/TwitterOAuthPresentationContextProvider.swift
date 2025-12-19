//
//  TwitterOAuthPresentationContextProvider.swift
//  TwitterManager
//
//  Created by Mohamed Salah on 18/12/2025.
//

import Foundation
import AuthenticationServices
import UIKit

/// Protocol for providing presentation context for OAuth authentication
public protocol TwitterOAuthPresentationContextProviding {
    func presentationAnchor() -> ASPresentationAnchor
}

/// Provides the window/view controller to present OAuth authentication UI
public struct TwitterOAuthPresentationContextProvider: TwitterOAuthPresentationContextProviding {
    
    private let anchor: ASPresentationAnchor?
    
    public init(anchor: ASPresentationAnchor? = nil) {
        self.anchor = anchor
    }
    
    public func presentationAnchor() -> ASPresentationAnchor {
        // Use provided anchor if available
        if let anchor = anchor {
            return anchor
        }
        if let window = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) {
            return window
        }
        
        // Fallback: create a new window (shouldn't happen in normal usage)
        return UIWindow()
    }
}



