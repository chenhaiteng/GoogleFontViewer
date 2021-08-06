//
//  FontService.swift
//  GoogleFontViewer
//
//  Created by Chen Hai Teng on 8/6/21.
//

import Foundation
import Combine

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
            var components = URLComponents()
            components.scheme = scheme[]
            components.host = host[]
            components.path = path[]
            components.query = "key=\(key[])"
            return components.url
        }
    }
    
    static func fetchFonts() throws -> AnyPublisher<WebFontList, Error> {
        guard let url = requestUrl else { throw URLError(.badURL) }
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WebFontList.self, decoder: decoder)
            .eraseToAnyPublisher()
//            .decode(type: T.self, decoder: decoder)
//            .eraseToAnyPublisher()
//            .replaceError(with: DaySchedules())
//            .eraseToAnyPublisher()
//            .receive(on: DispatchQueue.global())
//            .sink { daySchedules in
//                self.rawSchedules = daySchedules.seperateByDate()
//            }
    }
}
