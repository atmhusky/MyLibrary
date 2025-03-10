//
//  BookViewModel.swift
//  MyLibrary
//  


import SwiftUI
import SwiftData

class BookViewModel: ObservableObject {
    
//    private var modelContext: ModelContext
    @Environment(\.modelContext) private var modelContext
//    init() {
////        self.modelContext = modelContext
//        Task {
//            do {
//                let book = try await fetchBook(isbn: "9784297112134")
//                addBook(book)
//            } catch {
//                print("本の取得に失敗: \(error)")
//            }
//        }
//    }
    
    func fetchBook(isbn: String) async throws -> Book {
        let urlString = "https://www.googleapis.com/books/v1/volumes?maxResults=1"  // 最上位の検索結果のみ取得
        guard var url = URL(string: urlString) else { throw URLError(.badURL) }
        url.append(queryItems: [.init(name: "q", value: isbn)])  // 公式のパラメータ isbn:は正常に取得できない場合が多かったのでキーワード検索で実施
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(FetchedBook.self, from: data)

            let bookItem = response.items[0]  // 検索結果は配列になるが，1件しか取得していないので0番で固定
            
            // 最上位の検索結果が異なる本であった場合は見つからなかったと判定する (API変更の検討の余地あり)
            if isbn != bookItem.volumeInfo.industryIdentifiers[1].identifier {
                throw NSError(domain: "BookViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "入力と異なる本が取得されました"])
            }
            let book = Book(id: bookItem.id,
                        title: bookItem.volumeInfo.title,
                        subtitle: bookItem.volumeInfo.subtitle ?? "",
                        authors: bookItem.volumeInfo.authors,
                        bookDescription: bookItem.volumeInfo.description ?? "",
                        publishedDate: bookItem.volumeInfo.publishedDate,
                        imageUrlString: bookItem.volumeInfo.imageLinks.thumbnail,  // 高画質のサムネイルのURL
                        pageCount: bookItem.volumeInfo.pageCount,
                        isbn13: bookItem.volumeInfo.industryIdentifiers[1].identifier  // 13桁のISBNコード
            )
            addBook(book)
            return book
        } catch {
            throw error
        }
    }
    
    func addBook(_ book: Book) {
        modelContext.insert(book)
    }
    
    func deleteBook(_ book: Book) {
        modelContext.delete(book)
    }
}
