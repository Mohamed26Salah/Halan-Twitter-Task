//
//  DIContainer.swift
//  TwitterManager
//
//  Created by Mohamed Salah on 18/12/2025.
//

import Factory
import UIKit

public extension Container {
    
    /// Twitter OAuth Manager factory
    var twitterOAuthManager: Factory<TwitterOAuthManager> {
        Factory(self) {
            TwitterOAuthManager(
                clientId: TwitterConfig.clientId,
                clientSecret: TwitterConfig.clientSecret,
                redirectURI: TwitterConfig.redirectURI
            )
        }
    }
    
    /// PKCE Generator factory
    var pkceGenerator: Factory<PKCEGeneratorProtocol> {
        Factory(self) {
            PKCEGenerator()
        }
    }
    
    /// OAuth URL Builder factory
    var oauthURLBuilder: Factory<TwitterOAuthURLBuilderProtocol> {
        Factory(self) {
            TwitterOAuthURLBuilder()
        }
    }
    
    /// Token Exchanger factory
    var tokenExchanger: Factory<TwitterTokenExchangerProtocol> {
        Factory(self) {
            TwitterTokenExchanger()
        }
    }
    
    /// Presentation Context Provider factory
    var presentationContextProvider: Factory<TwitterOAuthPresentationContextProviding> {
        Factory(self) {
            TwitterOAuthPresentationContextProvider()
        }
    }
}
