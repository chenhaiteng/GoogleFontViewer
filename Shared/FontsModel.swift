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
    @Published var isFetching: Bool = false
    
    private var fetchCancellable: AnyCancellable? = nil
    
    func fetchFonts(sorting: FontSorting? = nil) {
        do {
            isFetching = true
            fetchCancellable = try FontService.fetchData(sorting)
                .decode(type: WebFontList.self, decoder: WebFontList.decoder)
                .replaceError(with: WebFontList(kind: "", items: []))
                .eraseToAnyPublisher()
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { list in
                    self.isFetching = false
                    self.fonts = list
                })
        } catch {
            fetchCancellable?.cancel()
            fetchCancellable = nil
        }
    }
}
