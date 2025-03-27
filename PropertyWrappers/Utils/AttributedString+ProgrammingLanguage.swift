//
//  AttributedString+ProgrammingLanguage.swift
//  PropertyWrappers
//
//  Created by Mihaela MJ on 27.03.2025..
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import SwiftUI

// Color extension for platform-specific conversion
extension Color {
    #if os(macOS)
    var nsColor: NSColor {
        NSColor(self)
    }
    #else
    var uiColor: UIColor {
        UIColor(self)
    }
    #endif
}

enum ProgrammingLanguage {
    case swift
    case python
    case javascript
    
    var keywords: [String] {
        switch self {
        case .swift:
            return ["struct", "let", "var", "func", "private", "View", "some", "init", "if", "else", "return", "class", "protocol"]
        case .python:
            return ["def", "class", "if", "else", "elif", "for", "while", "import", "from", "as", "return", "True", "False", "None"]
        case .javascript:
            return ["function", "let", "const", "var", "if", "else", "for", "while", "return", "class", "new", "this"]
        }
    }
    
    var singleLineComment: String {
        switch self {
        case .swift, .javascript:
            return #"//.*$"#
        case .python:
            return #"#.*$"#
        }
    }
    
    var multiLineCommentStart: String {
        switch self {
        case .swift, .javascript:
            return #"/\*"#
        case .python:
            return #""""#
        }
    }
    
    var multiLineCommentEnd: String {
        switch self {
        case .swift, .javascript:
            return #"\*/"#
        case .python:
            return #""""#
        }
    }
}

extension AttributedString {
    init(code: String, language: ProgrammingLanguage) {
        self.init(code)
        
        // Common patterns
        let stringPattern = #""[^"]*"|'[^']*'"#  // Double or single quoted strings
        let numberPattern = #"\b\d+\.?\d*\b"#     // Basic number matching
        
        // Define colors using SwiftUI Color with system colors
        let purple = Color.purple
        let red = Color.red
        let blue = Color.blue
        let green = Color.green
        
        // Helper function to apply highlighting with platform-specific colors
        func applyHighlighting(pattern: String, color: Color) {
            let regex = try? NSRegularExpression(pattern: pattern, options: [.anchorsMatchLines])
            let nsRange = NSRange(code.startIndex..<code.endIndex, in: code)
            regex?.enumerateMatches(in: code, range: nsRange) { match, _, _ in
                if let matchRange = match?.range,
                   let stringRange = Range(matchRange, in: code),
                   let attrRange = Range(stringRange, in: self) {
                    #if os(macOS)
                    self[attrRange].foregroundColor = Color(nsColor: color.nsColor)
                    #else
                    self[attrRange].foregroundColor = Color(uiColor: color.uiColor)
                    #endif
                }
            }
        }
        
        // Apply keyword highlighting
        for keyword in language.keywords {
            applyHighlighting(pattern: "\\b\(keyword)\\b", color: purple)
        }
        
        // Apply string highlighting
        applyHighlighting(pattern: stringPattern, color: red)
        
        // Apply number highlighting
        applyHighlighting(pattern: numberPattern, color: blue)
        
        // Apply single-line comment highlighting
        applyHighlighting(pattern: language.singleLineComment, color: green)
        
        // Apply multi-line comment highlighting
        let fullCode = code as NSString
        var searchStart = 0
        while searchStart < fullCode.length {
            let startRange = fullCode.range(of: language.multiLineCommentStart,
                                          options: .regularExpression,
                                          range: NSRange(location: searchStart, length: fullCode.length - searchStart))
            
            if startRange.location == NSNotFound {
                break
            }
            
            let endRange = fullCode.range(of: language.multiLineCommentEnd,
                                        options: .regularExpression,
                                        range: NSRange(location: startRange.location + startRange.length,
                                                     length: fullCode.length - (startRange.location + startRange.length)))
            
            if endRange.location == NSNotFound {
                break
            }
            
            let fullRange = NSRange(location: startRange.location,
                                  length: endRange.location + endRange.length - startRange.location)
            if let stringRange = Range(fullRange, in: code),
               let attrRange = Range(stringRange, in: self) {
                #if os(macOS)
                self[attrRange].foregroundColor = Color(nsColor: green.nsColor)
                #else
                self[attrRange].foregroundColor = Color(uiColor: green.uiColor)
                #endif
            }
            searchStart = endRange.location + endRange.length
        }
    }
}
