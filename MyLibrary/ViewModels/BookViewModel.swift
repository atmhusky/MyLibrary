//
//  BookViewModel.swift
//  MyLibrary
//  


import Foundation

class BookViewModel {

    init() {
        Task {
            await fetchBook(isbn: "9784297112134")
        }
    }
    
    private func fetchBook(isbn: String) async {
        let urlString = "https://www.googleapis.com/books/v1/volumes?maxResults=1"
        guard var url = URL(string: urlString) else { return }
        url.append(queryItems: [.init(name: "q", value: isbn)])
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(FetchedBook.self, from: data)

            print(response)
        } catch {
            print("本の取得に失敗: \(error)")
        }
    }
}
