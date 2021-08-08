//
//  ContentView.swift
//  Shared
//
//  Created by Chen Hai Teng on 8/6/21.
//

import SwiftUI
import WebKit
import WebView

struct ContentView: View {
    @EnvironmentObject var model: FontsModel
    @State var sorting: FontSorting = .Popularity
    var body: some View {
        VStack {
            Picker("sort", selection: $sorting) {
                ForEach(FontSorting.allCases, id: \.self) { sort in
                    Text(sort.rawValue).tag(sort)
                }
            }.segmented().onChange(of: sorting) { sort in
                model.fetchFonts(sorting: sort)
            }.frame(alignment: .top).onAppear {
                model.fetchFonts(sorting: sorting)
            }
            if model.isFetching {
                Spacer()
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.red))
                Spacer()
            } else {
                List(model.fonts.items, id: \.id) { font in
                    WebView(webView: WKWebView().apply({ web in
                        web.loadHTMLString(font.previewHtml(color: Color.black, background: Color.white), baseURL: nil)
                    })).frame(height: 50).onTapGesture {
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
