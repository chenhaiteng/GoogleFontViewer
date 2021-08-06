//
//  WebFont.swift
//  GoogleFontViewer
//
//  Created by Chen Hai Teng on 8/6/21.
//

import Foundation

enum WebFontDate : String {
    case format = "yyyy-MM-dd"
}

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
    
    static func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = WebFontDate.format.rawValue
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }
}

extension WebFont : Identifiable {
    var id: String {
        get {
            "\(family)\(version)"
        }
    }
}
