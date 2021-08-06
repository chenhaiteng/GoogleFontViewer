//
//  WebFont.swift
//  GoogleFontViewer
//
//  Created by Chen Hai Teng on 8/6/21.
//

import Foundation

struct WebFont: Codable {
    var kind: String
    var family: String
    var variants: [String]
    var subsets: [String]
    var version: String
    var lastModified: Date
    var files: [String:String]
    var category: String
}

struct WebFontList: Codable {
    var kind: String
    var items: [WebFont]
}
