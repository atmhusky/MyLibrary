//
//  BookDetailRow.swift
//  MyLibrary
//  


import SwiftUI

struct BookDetailRow: View {
    
    let bookDetail: BookDetail
    @Binding var inputText: String
    let isEditing: Bool
    var errorMessage = ""
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: bookDetail.symbol)
                .imageScale(.large)
            
            Text(bookDetail.itemName)
                .foregroundStyle(.primary)
            
            Spacer()
            
            if isEditing {
                VStack(alignment: .leading) {
                    TextField(bookDetail.textFieldText, text: $inputText, axis: .vertical)
                        .lineLimit(bookDetail.permitNewline ? nil : 1)
                        .multilineTextAlignment(bookDetail.permitNewline ? .leading : .trailing)
                    
                    if bookDetail == .publishedDate {
                        Text("※日付は yyyy-MM-dd, yyyy-MM, yyyy 形式のいずれかで入力")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }
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
    BookDetailRow(bookDetail: .publishedDate, inputText: $inputText, isEditing: true)
}
