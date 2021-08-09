//
//  DictionaryBuilder.swift
//  GoogleFontViewer
//
//  Created by Chen Hai Teng on 8/8/21.
//

import Foundation

@resultBuilder
enum DictionaryBuilder<Key: Hashable, Value> {
    typealias Dict = [Key: Value]
    static func buildBlock(_ components: [Dict]...) -> Dict {
        let temp = components.flatMap{ $0 }.flatMap{ $0 }
        let result = temp.reduce(Dict()) { (dict, item) in
            var nextDict = dict
            nextDict.updateValue(item.value, forKey: item.key)
            return nextDict
        }
        return result
    }
    
    static func buildBlock(_ component: Dict) -> Dict {
        return component
    }
    
    static func buildBlock(_ components: Dict?) -> Dict {
        return components ?? [:]
    }
}

extension DictionaryBuilder {
    static func buildExpression(_ dict: Dict) -> [DictionaryBuilder<Key, Value>.Dict] {
        return [dict]
    }
    static func buildExpression(_ tuple: (Key, Value)) -> [DictionaryBuilder<Key, Value>.Dict] {
        return [[tuple.0:tuple.1]]
    }
}

extension DictionaryBuilder {
    static func buildEither(first component: DictionaryBuilder<Key, Value>.Dict) -> [DictionaryBuilder<Key, Value>.Dict] {
        return [component]
    }
    static func buildEither(second component: DictionaryBuilder<Key, Value>.Dict) -> [DictionaryBuilder<Key, Value>.Dict] {
        return [component]
    }
    static func buildOptional(_ component: DictionaryBuilder<Key, Value>.Dict?) -> [DictionaryBuilder<Key, Value>.Dict] {
        guard let result = component else { return  [] }
        return [result]
    }
}

extension DictionaryBuilder {
    static func buildFinalResult(_ component: DictionaryBuilder<Key, Value>.Dict) -> Dict {
        return component
    }
}

extension Dictionary where Key == String, Value == String {
    func toQuery() -> String {
        var result = ""
        for (key, value) in self {
            result += "\(key)=\(value)&"
        }
        return String(result.dropLast())
    }
    
    func toStyle() -> String {
        var result = ""
        for (key, value) in self {
            result += "\(key):\(value);"
        }
        return result
    }
}
