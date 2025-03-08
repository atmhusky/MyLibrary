//
//  BookViewModel.swift
//  MyLibrary
//  


import Foundation

class BookViewModel {

    init() {
        Task {
            do {
                try await fetchBook(isbn: "9784297112134")
            } catch {
                print("本の取得に失敗: \(error)")
            }
        }
    }
    
    private func fetchBook(isbn: String) async throws -> Book {
        let urlString = "https://www.googleapis.com/books/v1/volumes?maxResults=1"  // 最上位の検索結果のみ取得
        guard var url = URL(string: urlString) else { throw URLError(.badURL) }
        url.append(queryItems: [.init(name: "q", value: isbn)])  // 公式のパラメータ isbn:は正常に取得できない場合が多かったのでキーワード検索で実施
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(FetchedBook.self, from: data)

            let bookItem = response.items[0]  // 検索結果は配列になるが，1件しか取得していないので0番で固定
            let book = Book(id: bookItem.id,
                            title: bookItem.volumeInfo.title,
                            subtitle: bookItem.volumeInfo.subtitle,
                            authors: bookItem.volumeInfo.authors,
                            bookDescription: bookItem.volumeInfo.description,
                            publishedDate: bookItem.volumeInfo.publishedDate,
                            imageUrlString: bookItem.volumeInfo.imageLinks.thumbnail,
                            pageCount: bookItem.volumeInfo.pageCount,
                            isbn13: bookItem.volumeInfo.industryIdentifiers[1].identifier
            )
            
            print(book.title)
            print(book.isbn13)
            print(book.imageUrl ?? "画像URL無し")
            
            return book
        } catch {
            throw error
        }
    }
}
