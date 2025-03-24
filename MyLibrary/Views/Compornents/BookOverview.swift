//
//  BookOverview.swift
//  MyLibrary
//


import SwiftUI

struct BookOverview: View {
    
    @Bindable var book: Book
    
    var isEditing: Bool = false
    var canScroll: Bool = false
    
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
                    if canScroll {
                        ScrollView(.horizontal) {
                            Text(book.title)
                                .font(.body)
                                .lineLimit(1)
                        }
                        
                        ScrollView(.horizontal) {
                            if book.subtitle != "" {
                                Text(book.subtitle)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                        }
                        .padding(.top, -5)
                        
                        ScrollView(.horizontal) {
                            Text(book.authors)
                                .font(.caption)
                                .lineLimit(1)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, -3)
                    } else {
                        Text(book.title)
                            .font(.body)
                            .lineLimit(1)
                        
                        if book.subtitle != "" {
                            Text(book.subtitle)
                                .font(.caption)
                                .lineLimit(1)
                                .padding(.top, -5)
                        }

                        Text(book.authors)
                            .font(.caption)
                            .lineLimit(1)
                            .foregroundStyle(.secondary)
                            .padding(.top, -3)
                    }
                }
            }
            .padding(.leading)
        }
    }
}

#Preview {
    let sampleBook = Book(
        title: "タイトルタイトルタイトルタイトルタイトルタイトル",
        subtitle: "サブタイトルサブタイトルサブタイトルサブタイトルサブタイトル",
        authors: ["著者1", "著者2"],
        bookDescription: "本の説明文",
        publishedDate: "2020-11",
        imageUrlString: "https://books.google.com/books/content?id=G9BbLwEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
        pageCount: 123,
        isbn13: "1234567890123"
    )
    BookOverview(book: sampleBook)
}
