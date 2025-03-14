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
            guard let isbn13Identifier = bookItem.volumeInfo.industryIdentifiers.first(where: { $0.type == "ISBN_13" && $0.identifier == isbn })?.identifier else {
                throw NSError(domain: "BookViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "入力と異なる本が取得されました"])
            }
            
            let book = Book(
                title: bookItem.volumeInfo.title,
                subtitle: bookItem.volumeInfo.subtitle ?? "",
                authors: bookItem.volumeInfo.authors ?? [],
                bookDescription: bookItem.volumeInfo.description ?? "",
                publishedDate: bookItem.volumeInfo.publishedDate,
                imageUrlString: bookItem.volumeInfo.imageLinks?.thumbnail ?? nil,
                pageCount: bookItem.volumeInfo.pageCount,
                isbn13: isbn13Identifier
            )
            return book
        } catch {
            throw error
        }
    }
    
    // 出版日の形式が正しいかを判定する
    func isValidPublishedDateString(_ publishedDate: String) -> Bool {
        if publishedDate.isEmpty {
            return true // 空文字はOK
        }

        // 年月日 or 年月 or 年 のどれかにマッチしているか
        let datePatterns = [
            "yyyy-MM-dd",
            "yyyy-MM",
            "yyyy"
        ]

        for pattern in datePatterns {
            let formatter = DateFormatter()
            formatter.dateFormat = pattern
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.isLenient = false

            if formatter.date(from: publishedDate) != nil{
                return true
            }
        }

        return false
    }
    
    // 空のBookを生成する
    func creareEmptyBook(isbn13: String) -> Book {
        Book(title: "", subtitle: "", authors: [], bookDescription: "", publishedDate: "", imageUrlString: "", pageCount: 0, isbn13: isbn13)
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
    
    // 選択した本の情報をCSV形式に変換し，URLを返す
    func exportBooksToCSV(selectedBooks: Set<String> ,modelContext: ModelContext) -> URL? {
        if let csvString = generateCSV(selectedBooks: selectedBooks, modelContext: modelContext) {
            let fileName = "MyLibrary.csv"
            let tmpURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            do {
                try csvString.write(to: tmpURL, atomically: true, encoding: .utf8)
                return tmpURL
            } catch {
                print("CSVの保存に失敗しました：\(error)")
                return nil
            }
        } else {
            return nil
        }
    }
    
    // 選択した本をCSV形式の文字列として生成する
    private func generateCSV(selectedBooks: Set<String> ,modelContext: ModelContext) -> String? {
        print("エクスポートする本: \(selectedBooks)")
        
        if let books = fetchBooksById(ids: selectedBooks, modelContext: modelContext), !books.isEmpty {
            var csvString = "ID,Title,Subtitle,Authors,Description,PublishedDate,PageCount,ISBN13\n"
            
            for book in books {
                // authorsはカンマ区切りなので，セミコロンに変換する
                let authorsSemicolon = book.authors
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .joined(separator: ";")
                // CSVでダブルクォーテーションを扱えるように変換
                let escapedDescription = book.bookDescription.replacingOccurrences(of: "\"", with: "\"\"")
                
                csvString += """
                "\(book.id)","\(book.title)","\(book.subtitle)","\(authorsSemicolon)","\(escapedDescription)","\(book.publishedDate)",\(book.pageCount),\(book.isbn13)\n
                """
            }
            
            return csvString
        } else {
            return nil
        }
    }
    
    // 指定したIDの本を取得して返す
    private func fetchBooksById(ids: Set<String>, modelContext: ModelContext) -> [Book]? {
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
    
    // 入力されたコードがISBNコードであり，ユニークであるかをチェック
    func isRegisterableISBN(searchText: String, modelContext: ModelContext) -> String? {
        guard isValidISBN(searchText) else {
            return "※入力されたのはISBNコードではありません。\n978から始まる13桁の数字を入力してください。"
        }
        
        guard hasDuplicateBook(isbn: searchText, modelContext: modelContext) else {
            return "※入力されたISBNコードの書籍は既に登録済みです。"
        }
        
        return nil
    }
    
    // 入力値のチェック (13桁の数字であるかどうかの判定)
    func isValidISBN(_ searchText: String) -> Bool {
        let regex = #"^\d{13}$"#
        guard searchText.range(of: regex, options: .regularExpression) != nil else {
            return false
        }
        return searchText.hasPrefix("978")
    }
    
    // 登録しようとしている本のISBNコードが重複しているかを判定
    func hasDuplicateBook(isbn: String, modelContext: ModelContext) -> Bool {
        let descriptor = FetchDescriptor<Book>(
            predicate: #Predicate { $0.isbn13 == isbn }
        )
        
        do {
            let existingBooks = try modelContext.fetch(descriptor)
            return existingBooks.isEmpty
        } catch {
            print("重複チェックに失敗しました：\(error)")
            return false
        }
    }
}
