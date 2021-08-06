//
//  FontsModel.swift
//  GoogleFontViewer
//
//  Created by Chen Hai Teng on 8/6/21.
//

import Foundation
import Combine

class FontsModel: ObservableObject {
    @Published var fonts: WebFontList = WebFontList(kind: "", items: [])
    
    private var fetchCancellable: AnyCancellable? = nil
    
    func fetchFonts() {
        do {
            fetchCancellable = try FontService.fetchData()
                .decode(type: WebFontList.self, decoder: WebFontList.decoder())
                .replaceError(with: WebFontList(kind: "", items: []))
                .eraseToAnyPublisher()
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { list in
                    self.fonts = list
                })
        } catch {
            fetchCancellable?.cancel()
            fetchCancellable = nil
        }
    }
    
    init() {
        fetchFonts()
    }
}
