//
//  BarcodeScanView.swift
//  MyLibrary
//


import SwiftUI
import CodeScanner

struct BarcodeScanView: View {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @Binding var isOpenScanner: Bool
    @Binding var fetchedBook: Book?
    @Binding var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            VStack{
                Text("ISBNコードをスキャンしてください")
                    .foregroundStyle(.primary)
                
                CodeScannerView(codeTypes: [.ean13]) { response in
                    switch response {
                    case .success(let result):
                        print("スキャンしたコード：\(result.string)")
                        let scannedCode = result.string
                        isOpenScanner = false
                        
                        errorMessage = bookViewModel.isRegisterableISBN(searchText: scannedCode, modelContext: modelContext)
                        
                        if errorMessage != nil {
                            return
                        }
                        
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
                        errorMessage = "バーコードスキャンに失敗しました。"
                        isOpenScanner = false
                    }
                }
                .frame(width: 350, height: 120)
                .border(.primary, width: 5)
                
                ISBNHelpMessage()
                
                Spacer()
            }
            .padding(.top, 50)
            .navigationTitle("バーコードスキャン")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        isOpenScanner = false
                    }
                }
            }
        }
    }
}
