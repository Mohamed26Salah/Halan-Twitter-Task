//
//  CountTweetCharactersUseCase.swift
//  HalanTwitterUseCases
//
//  Created by Mohamed Salah on 20/12/2025.
//

import Foundation

/// Protocol for counting characters in a tweet according to Twitter's rules
public protocol CountTweetCharactersUseCaseProtocol {
    /// Counts characters in a tweet text according to Twitter's character counting rules
    /// - Parameter text: The tweet text to count
    /// - Returns: The number of characters as counted by Twitter
    func execute(text: String) -> Int
}

/// Use case for counting characters in a tweet according to Twitter's rules
/// Twitter counts URLs as 23 characters regardless of actual length
/// Most emojis count as 2 characters due to their Unicode representation
/// Uses Unicode Normalization Form C (NFC) and counts code points
public class CountTweetCharactersUseCase: CountTweetCharactersUseCaseProtocol {
    
    private let urlCharacterCount = 23 // Twitter counts URLs as 23 characters via t.co
    
    public init() {}
    
    // MARK: - Public Methods
    
    public func execute(text: String) -> Int {
        guard !text.isEmpty else { return 0 }
        
        // Normalize text using Unicode Normalization Form C (NFC) as per Twitter's rules
        let normalizedText = text.precomposedStringWithCanonicalMapping
        
        // Replace URLs with placeholder to count them as 23 characters
        let textWithReplacedURLs = replaceURLs(in: normalizedText)
        
        // Count characters using UTF-16 code units (Twitter's counting method)
        var characterCount = 0
        
        var index = textWithReplacedURLs.startIndex
        while index < textWithReplacedURLs.endIndex {
            let char = textWithReplacedURLs[index]
            
            // Check if this is a URL placeholder
            if char == "🔗" {
                characterCount += urlCharacterCount
                index = textWithReplacedURLs.index(after: index)
                continue
            }
            
            // Count UTF-16 code units for this character
            // Twitter counts based on UTF-16, where:
            // - Characters in BMP (Basic Multilingual Plane): 1 code unit = 1 character
            // - Characters outside BMP: 2 code units = 2 characters
            let utf16Count = char.utf16.count
            
            if utf16Count > 1 {
                // Characters outside BMP (like some emojis) count as 2
                characterCount += 2
            } else {
                // Regular characters (letters, numbers, punctuation) count as 1
                characterCount += 1
            }
            
            index = textWithReplacedURLs.index(after: index)
        }
        
        return characterCount
    }
    
    // MARK: - Private Methods
    
    /// Replaces URLs in the text with a placeholder character
    /// - Parameter text: The original text
    /// - Returns: Text with URLs replaced by placeholder
    private func replaceURLs(in text: String) -> String {
        // Pattern to match URLs (http, https, www, or common TLDs)
        // Matches: http://..., https://..., www.example.com, example.com
        let urlPattern = #"(?i)\b(https?://[^\s]+|www\.[^\s]+|[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\.[a-zA-Z]{2,}(?:/[^\s]*)?)"#
        
        guard let regex = try? NSRegularExpression(pattern: urlPattern, options: []) else {
            return text
        }
        
        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        var modifiedText = text
        let matches = regex.matches(in: text, options: [], range: range)
        
        // Replace URLs in reverse order to maintain correct indices
        for match in matches.reversed() {
            if let swiftRange = Range(match.range, in: modifiedText) {
                modifiedText.replaceSubrange(swiftRange, with: "🔗")
            }
        }
        
        return modifiedText
    }
}

