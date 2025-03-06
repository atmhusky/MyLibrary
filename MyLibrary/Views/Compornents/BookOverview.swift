//
//  BookOverview.swift
//  MyLibrary
//  


import SwiftUI

struct BookOverview: View {
    
    @Binding var title: String
    @Binding var subTitle: String
    @Binding var author: String
    var thumbnailURL: URL? = nil
    var permitNewline: Bool = false
    var isEditing: Bool = false
    
    var body: some View {
        HStack {
            
            if let thumbnailURL = thumbnailURL {
                AsyncImage(url: thumbnailURL) { response in
                    response.image?
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 80)
                    
                }
            } else {
                Image("no_image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 80)
            }
            
            VStack(alignment: .leading) {
                if isEditing {
                    TextField("タイトルを入力", text: $title, axis: .vertical)
                        .font(.body)
                    
                    TextField("サブタイトルを入力", text: $subTitle, axis: .vertical)
                        .font(.footnote)
                    
                    TextField("著者を入力", text: $author, axis: .vertical)
                        .font(.footnote)
                } else {
                    Text(title)
                        .font(.body)
                        .lineLimit(permitNewline ? nil : 1)
                    
                    if subTitle != "" {
                        Text(subTitle)
                            .font(.caption)
                            .lineLimit(permitNewline ? nil : 1)
                    }
                    
                    Text(author)
                        .font(.caption)
                        .lineLimit(permitNewline ? nil : 1)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.leading)
        }
    }
}

#Preview {
//    BookOverviewRow(title: "本のタイトル", subTitle: "本のサブタイトル", author: "本の著者")
    @Previewable @State var title: String = "本のタイトル"
    @Previewable @State var subTitle: String = ""
    @Previewable @State var author: String = "本の著者"
    BookOverview(title: $title, subTitle: $subTitle, author: $author, thumbnailURL: URL(string: "https://books.google.com/books/content?id=G9BbLwEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"))
}
