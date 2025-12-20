import Testing
@testable import HalanTwitterUseCases

@Suite("CountTweetCharactersUseCase")
struct CountTweetCharactersUseCaseTests {
    
    private let sut = CountTweetCharactersUseCase()
    
    // MARK: - Empty
    
    @Test("Empty text returns zero")
    func emptyTextReturnsZero() {
        let result = sut.execute(text: "")
        #expect(result == 0)
    }
    
    // MARK: - Plain text
    @Test("Plain ASCII text counts normally")
    func plainTextCountsNormally() {
        let text = "Hello Twitter"
        let result = sut.execute(text: text)
        #expect(result == text.count)
    }
    
    // MARK: - Emojis
    @Test("Single emoji outside BMP counts as 2 characters")
    func emojiCountsAsTwo() {
        let text = "😀" // UTF-16 surrogate pair
        let result = sut.execute(text: text)
        #expect(result == 2)
    }
    
    @Test("Text with emoji counts emoji as two")
    func textWithEmoji() {
        let text = "Hi 😀"
        // H(1) i(1) space(1) emoji(2)
        let result = sut.execute(text: text)
        #expect(result == 5)
    }
    
    // MARK: - URLs
    
    @Test("HTTP URL counts as 23 characters")
    func httpURLCountsAs23() {
        let text = "https://www.example.com"
        let result = sut.execute(text: text)
        #expect(result == 23)
    }
    
    @Test("WWW URL counts as 23 characters")
    func wwwURLCountsAs23() {
        let text = "Check this www.example.com"
        let result = sut.execute(text: text)
        
        // "Check this " = 11 chars
        // URL = 23 chars
        #expect(result == 34)
    }
    
    @Test("Multiple URLs are each counted as 23 characters")
    func multipleURLs() {
        let text = "One https://a.com Two https://b.com"
        
        // "One " = 4
        // URL = 23
        // " Two " = 5
        // URL = 23
        let result = sut.execute(text: text)
        #expect(result == 55)
    }
    
    // MARK: - Mixed content
    
    @Test("Text with emoji and URL is counted correctly")
    func mixedTextEmojiAndURL() {
        let text = "Hello 😀 https://example.com"
        
        // "Hello " = 6
        // emoji = 2
        // space = 1
        // URL = 23
        let result = sut.execute(text: text)
        #expect(result == 32)
    }
    
    // MARK: - Unicode normalization
    
    @Test("Unicode composed and decomposed forms produce same count")
    func unicodeNormalization() {
        let composed = "é"              // U+00E9
        let decomposed = "e\u{301}"     // e + ◌́
        
        let composedCount = sut.execute(text: composed)
        let decomposedCount = sut.execute(text: decomposed)
        
        #expect(composedCount == decomposedCount)
        #expect(composedCount == 1)
    }
}
