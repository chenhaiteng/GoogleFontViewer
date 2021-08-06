//
//  GoogleFontViewerApp.swift
//  Shared
//
//  Created by Chen Hai Teng on 8/6/21.
//

import SwiftUI

@main
struct GoogleFontViewerApp: App {
    @StateObject var model = FontsModel()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(model)
        }
    }
}
