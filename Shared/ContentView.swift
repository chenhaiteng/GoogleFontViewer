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
    var body: some View {
        List(model.fonts.items) { font in
            WebView(webView: WKWebView().apply({ web in
                web.loadHTMLString(font.previewHtml(color: Color.black, background: Color.white), baseURL: nil)
            })).frame(height: 50)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
