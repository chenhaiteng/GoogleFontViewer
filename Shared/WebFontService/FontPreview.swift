//
//  FontPreview.swift
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
        appendLiteral("<link href=\(css2Api)\(family)\" rel=\"stylesheet\">")
    }
}

extension WebFont {
    func previewHtml(color: Color, background: Color) -> String {
        let result = "\(self)<div style=\"background-color: \(background); color:\(color); font-size:10vw;font-family: '\(self.family)', \(self.category);\">\(self.family)</div>"
        return result
    }
}
