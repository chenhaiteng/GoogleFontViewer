//
//  SegmentedPicker.swift
//  GoogleFontViewer
//
//  Created by Chen Hai Teng on 8/8/21.
//

import SwiftUI

struct SegmentedPicker: ViewModifier {
    func body(content: Content) -> some View {
        #if os(watchOS)
        content
        #else
        content.pickerStyle(SegmentedPickerStyle()).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 7))
        #endif
    }
}

extension Picker {
    func segmented() -> some View {
        modifier(SegmentedPicker())
    }
}

