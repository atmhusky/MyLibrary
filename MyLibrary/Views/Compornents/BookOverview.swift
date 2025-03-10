//
//  BookOverview.swift
//  MyLibrary
//  


import SwiftUI

struct BookOverview: View {
    
//    @Binding var title: String
//    @Binding var subTitle: String
//    @Binding var author: String
//    var thumbnailURL: URL? = nil
    
    @Bindable var book: Book
    
    var permitNewline: Bool = false
    var isEditing: Bool = false
    
    var body: some View {
        HStack {
            
            if let thumbnailURL = book.imageUrl {
                AsyncImage(url: thumbnailURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 80)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image("no_image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 80)
            }
            
            VStack(alignment: .leading) {
                if isEditing {
                    TextField("タイトルを入力", text: $book.title, axis: .vertical)
                        .font(.body)
                    
                    TextField("サブタイトルを入力", text: $book.subtitle, axis: .vertical)
                        .font(.caption)
                    
                    TextField("著者を入力", text: $book.authors, axis: .vertical)
                        .font(.caption)
                } else {
                    Text(book.title)
                        .font(.body)
                        .lineLimit(permitNewline ? nil : 1)
                    
                    if book.subtitle != "" {
                        Text(book.subtitle)
                            .font(.caption)
                            .lineLimit(permitNewline ? nil : 1)
                    }
                    
                    Text(book.authors)
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
    let sampleBook = Book(id: "111",
                          title: "タイトル",
                          subtitle: "サブタイトル",
                          authors: ["著者1", "著者2"],
                          bookDescription: "本の説明文",
                          publishedDate: "2020-11",
                          imageUrlString: "https://books.google.com/books/content?id=G9BbLwEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
                          pageCount: 123,
                          isbn13: "1234567890123"
                  )
    BookOverview(book: sampleBook)
}
