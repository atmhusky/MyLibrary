//
//  BookListRow.swift
//  MyLibrary
//  


import SwiftUI

struct BookOverviewRow: View {
    
    let title: String
    var subTitle: String = ""
    let author: String
    var thumbnailURL: URL? = nil
    var permitNewline: Bool = false
    
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
            .padding(.leading)
        }
    }
}

#Preview {
//    BookOverviewRow(title: "本のタイトル", subTitle: "本のサブタイトル", author: "本の著者")
    BookOverviewRow(title: "本のタイトル", subTitle: "本のサブタイトル", author: "本の著者", thumbnailURL: URL(string: "https://books.google.com/books/content?id=G9BbLwEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"))
}
