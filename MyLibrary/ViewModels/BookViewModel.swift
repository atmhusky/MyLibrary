//
//  BookViewModel.swift
//  MyLibrary
//  


import SwiftUI
import SwiftData

class BookViewModel: ObservableObject {
    
    // Google Books APIで本の情報を取得し，Bookで返す
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
            return book
        } catch {
            throw error
        }
    }
    
    // 本を新しく保存する
    func addBook(_ book: Book ,modelContext: ModelContext) {
        modelContext.insert(book)
        print("保存完了：\(book.id)")
    }
    
    // 本の情報を更新する
    func updateBook(_ book: Book ,modelContext: ModelContext) {
        try? modelContext.save()
        print("更新成功：\(book.id)")
    }
    
    // 選択した本を削除する
    func deleteBooks(selectedBooks: Set<String> ,modelContext: ModelContext) {
        print("削除する本: \(selectedBooks)")
        if let books = fetchBooksById(ids: selectedBooks, modelContext: modelContext) {
            for book in books {
                modelContext.delete(book)
                print("削除完了：\(book.id)")
            }
        }
    }
    
    // 選択した本をCSV形式でエクスポートする
    func exportBooksToCSV(selectedBooks: Set<String> ,modelContext: ModelContext) {
        print("エクスポートする本: \(selectedBooks)")
    }
    
    
    // 指定したIDの本を取得して返す
    func fetchBooksById(ids: Set<String>, modelContext: ModelContext) -> [Book]? {
        let descriptor = FetchDescriptor<Book>(
            predicate: #Predicate { ids.contains($0.id) }
        )
        
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("指定したidの検索に失敗しました：\(error)")
            return nil
        }
    }
}
