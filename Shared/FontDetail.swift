//
//  FontDetail.swift
//  GoogleFontViewer
//
//  Created by Chen Hai Teng on 8/9/21.
//

import SwiftUI
import WebKit
import WebView

struct FontDetail: View {
    let font:WebFont
    var body: some View {
        Form {
            WebView(webView: WKWebView().apply({ web in
                web.loadHTMLString(font.previewHtml(color: Color.black, background: Color.white), baseURL: nil)
            })).frame(height: 80)
            Text("version:\(font.version)")
            Text("modified:\(font.lastModified)")
            Section(header: Text("variants")) {
                ForEach(0..<font.variants.count) { i in
                    Text(font.variants[i])
                }
            }
            Section(header: Text("subsets")) {
                ForEach(0..<font.subsets.count) { i in
                    Text(font.subsets[i])
                }
            }
            
//            List(font.variants, id: \.self) { item ->
//                Text("\(item)")
//            }
        }
    }
    
    init(_ font: WebFont) {
        self.font = font
    }
}

//struct FontDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        FontDetail()
//    }
//}
