//
//  TwitterTweetPoster.swift
//  TwitterManager
//
//  Created by Mohamed Salah on 20/12/2025.
//

import Foundation

public protocol TwitterTweetPosterProtocol {
    func postTweet(text: String, accessToken: String) async throws -> TweetResponse
}

public struct TwitterTweetPoster: TwitterTweetPosterProtocol {
    
    private let tweetsEndpoint = "https://api.twitter.com/2/tweets"
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    /// - Parameters:
    ///   - text: The text content of the tweet
    ///   - accessToken: OAuth 2.0 access token
    /// - Returns: TweetResponse containing the posted tweet ID
    /// - Throws: TwitterOAuthError if posting fails
    public func postTweet(text: String, accessToken: String) async throws -> TweetResponse {
        guard let url = URL(string: tweetsEndpoint) else {
            throw TwitterOAuthError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // Build JSON body
        let requestBody: [String: Any] = [
            "text": text
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            throw TwitterOAuthError.invalidResponse
        }
        
        request.httpBody = jsonData
        
        return try await performTweetRequest(request: request)
    }
    
    // MARK: - Private Methods
    
    private func performTweetRequest(request: URLRequest) async throws -> TweetResponse {
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw TwitterOAuthError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = extractErrorMessage(from: data)
                throw TwitterOAuthError.tokenExchangeFailed(errorMessage)
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let dataDict = json["data"] as? [String: Any],
                  let tweetId = dataDict["id"] as? String else {
                throw TwitterOAuthError.invalidResponse
            }
            
            return TweetResponse(tweetId: tweetId)
        } catch let error as TwitterOAuthError {
            throw error
        } catch {
            throw TwitterOAuthError.tokenExchangeFailed(error.localizedDescription)
        }
    }
    
    private func extractErrorMessage(from data: Data?) -> String {
        guard let data = data,
              let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return "Unknown error"
        }
        
        // Try to extract error message from Twitter API response
        if let errors = errorData["errors"] as? [[String: Any]],
           let firstError = errors.first,
           let message = firstError["message"] as? String {
            return message
        }
        
        if let detail = errorData["detail"] as? String {
            return detail
        }
        
        return "Unknown error"
    }
}

