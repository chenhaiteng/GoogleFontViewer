//
//  FontService.swift
//  GoogleFontViewer
//
//  Created by Chen Hai Teng on 8/6/21.
//

import Foundation
import Combine

enum FontSorting: String {
    case Alpha = "alpha"
    case Date = "date"
    case Popularity = "popularity"
    case Style = "style"
    case Trending = "trending"
}

extension FontSorting : CaseIterable {
    
}

enum FontService : String {
    case key = "AIzaSyCTkCGwdsNyEXZw9oH1LvS-Lqzjk0_YRmI"
    case scheme = "https"
    case host = "www.googleapis.com"
    case path = "/webfonts/v1/webfonts"
    
    private subscript() -> String {
        return self.rawValue
    }
    
    static var requestUrl: URL? {
        get {
            return requestUrl()
        }
    }
    
    static func requestUrl(@DictionaryBuilder<String, String> _ builder: ()->Dictionary<String, String>) -> URL? {
        var components = URLComponents()
        components.scheme = scheme[]
        components.host = host[]
        components.path = path[]
        components.query = builder().toQuery()
        return components.url
    }
    
    static func requestUrl(_ sortBy:FontSorting? = nil) -> URL? {
        return requestUrl {
            ("key", key[])
            if let sorting = sortBy?.rawValue {
                ("sort", sorting)
            }
        }
    }
    
    static func fetchData(_ sortBy: FontSorting? = nil) throws -> AnyPublisher<Data, URLError> {
        guard let url = requestUrl(sortBy) else { throw URLError(.badURL) }
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}

