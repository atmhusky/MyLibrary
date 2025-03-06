//
//  BookDetailRow.swift
//  MyLibrary
//  


import SwiftUI

struct BookDetailRow: View {
    
    let bookDetail: BookDetail
    @Binding var inputText: String
    let isEditing: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: bookDetail.symbol)
                .imageScale(.large)
            
            Text("説明")
                .foregroundStyle(.primary)
            
            Spacer()
            
            if isEditing {
                TextField("本の説明文", text: $inputText, axis: .vertical)
                    .lineLimit(bookDetail.permitNewline ? nil : 1)
            } else {
                Text(inputText)
                    .lineLimit(bookDetail.permitNewline ? nil : 1)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    @Previewable @State var inputText: String = "テキスト"
    BookDetailRow(bookDetail: .description, inputText: $inputText, isEditing: false)
}
