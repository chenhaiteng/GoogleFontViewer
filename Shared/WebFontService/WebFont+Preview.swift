//
//  WebFont+Preview.swift
//  GoogleFontViewer
//
//  Created by Chen Hai Teng on 8/6/21.
//

import Foundation
import SwiftUI

let css2Api = "\"https://fonts.googleapis.com/css2?family="

extension String.StringInterpolation {
    mutating func appendInterpolation(_ webFont: WebFont) {
        let family = webFont.family.replacingOccurrences(of: " ", with: "+")
        let display = webFont.family.replacingOccurrences(of: " ", with: "%20")
        appendLiteral("<link href=\(css2Api)\(family)&text=\(display)\" rel=\"stylesheet\">")
    }
}

extension WebFont {
    func previewHtml(color: Color, background: Color) -> String {
        let div = div(self.family) {
            ("background-color", "\(background)")
            ("color", "\(color)")
            ("font-size", "10vw")
            ("font-family", "'\(self.family)', \(self.category)")
        }
        return "\(self)\(div)"
    }
    
    func div(_ content:String, @DictionaryBuilder<String, String> style: () -> Dictionary<String, String>) -> String {
        return "<div style=\"\(style().toStyle())\">\(content)</div>"
    }
}
