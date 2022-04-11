//
//  FocusedTextEditorView.swift
//  KardemirYemek
//
//  Created by Oğuz Coşkun on 11.04.2022.
//

import SwiftUI

struct FocusedTextEditorView: View {
    @Binding var text: String
    let height: CGFloat
    
    enum FocusField: Hashable {
        case field
    }
    
    @FocusState private var focusedField: FocusField?
    
    init(text: Binding<String>, height: CGFloat) {
        self._text = text
        self.height = height
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        TextEditor(text: $text)
            .font(.system(size: 15))
            .multilineTextAlignment(.center)
            .lineSpacing(5.0)
            .frame(width: 350, height: self.height)
            .focused($focusedField, equals: .field)
            .onAppear {
                self.focusedField = .field
            }
    }
}
