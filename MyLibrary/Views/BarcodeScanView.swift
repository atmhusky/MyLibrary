//
//  BarcodeScanView.swift
//  MyLibrary
//  


import SwiftUI
import CodeScanner

struct BarcodeScanView: View {
    
    @Binding var isOpenScanner: Bool
    @Binding var fetchedBook: Book?
    @EnvironmentObject var bookViewModel: BookViewModel
    
    var body: some View {
        CodeScannerView(codeTypes: [.ean13], showViewfinder: true) { response in
            switch response {
            case .success(let result):
                print("スキャンしたコード：\(result.string)")
                let scannedCode = result.string
                isOpenScanner = false
                Task {
                    do {
                        fetchedBook = try await bookViewModel.fetchBook(isbn: scannedCode)
                    } catch {
                        print("検索したISBNの本は見つかりませんでした：\(error)")
                        fetchedBook = bookViewModel.creareEmptyBook(isbn13: scannedCode)  // 検索した本が見つからない場合は空の登録フォームを表示する
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
