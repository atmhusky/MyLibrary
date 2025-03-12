//
//  ListView.swift
//  MyLibrary
//


import SwiftUI
import SwiftData
import CodeScanner

struct ListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [Book]
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @State var searchText = ""
    @State var selectedBooks: Set<String> = []
    @State var editMode: EditMode = .inactive
    @State var fetchedBook: Book?
    @State var errorMessage: String? = nil
    @State var isOpenScanner = false
    @State var isShowAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                List(selection: $selectedBooks) {
                    Section("本の追加") {
                        search
                    }
                    
                    Section("蔵書一覧"){
                        
                        if books.isEmpty {
                            VStack(alignment: .center) {
                                Text("書籍が登録されていません")
                                    .fontWeight(.bold)
                                    .font(.title2)
                                    .padding()
                                
                                Text("上の検索バーかバーコードのアイコンをタップして書籍を登録しましょう！")
                                    .foregroundStyle(.secondary)
                                    .padding([.leading, .bottom, .trailing])
                            }
                        }
                        
                        ForEach(books) { book in
                            if editMode == .active {
                                BookOverview(book: book)
                            } else {
                                NavigationLink {
                                    BookDetailView(book: book)
                                } label: {
                                    BookOverview(book: book)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .environment(\.editMode, $editMode)
                .navigationTitle("MyLibraty")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(editMode == .active ? "完了" : "選択") {
                            editMode = editMode == .active ? .inactive : .active
                            selectedBooks = []
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        if editMode == .active {
                            Button("すべて選択") {
                                selectAllBooks()
                            }
                        }
                    }
                    
                    ToolbarItemGroup(placement: .bottomBar) {
                        if editMode == .active && !selectedBooks.isEmpty {
                            if let csvURL = bookViewModel.exportBooksToCSV(selectedBooks: selectedBooks, modelContext: modelContext) {
                                ShareLink(item: csvURL) {
                                    Text("CSVへエクスポート")
                                }
                            }
                            
                            Spacer()
                            
                            Button(role: .destructive) {
                                isShowAlert = true
                            } label: {
                                Text("削除")
                                    .foregroundStyle(.red)
                            }
                            .alert("警告", isPresented: $isShowAlert) {
                                Button("キャンセル", role: .cancel) {}
                                Button("削除", role: .destructive) {
                                    bookViewModel.deleteBooks(selectedBooks: selectedBooks, modelContext: modelContext)
                                    editMode = .inactive
                                }
                            } message: {
                                Text("選択した本を削除します。この操作は取り消せません。")
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $fetchedBook, onDismiss: {
            searchText = ""
        }, content: { book in
            BookDetailView(book: book, isNewBook: true, isEditing: true)
        })
        .sheet(isPresented: $isOpenScanner) {
            BarcodeScanView(isOpenScanner: $isOpenScanner, fetchedBook: $fetchedBook)
        }
    }
}

#Preview {
    
    ListView()
        .modelContainer(for: Book.self, inMemory: true)
        .environmentObject(BookViewModel())
}

extension ListView {
    
    private var search: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("ISBNコードを入力(13桁の数字)", text: $searchText)
                    .onSubmit {
                        print(searchText)
                        
                        guard isValidISBN(searchText) else {
                            errorMessage = "※入力されたのはISBNコードではありません。\n978から始まる13桁の数字を入力してください。"
                            return
                        }
                        
                        errorMessage = nil
                        
                        Task {
                            do {
                                fetchedBook = try await bookViewModel.fetchBook(isbn: searchText)
                            } catch {
                                print("検索したISBNの本は見つかりませんでした：\(error)")
                                fetchedBook = bookViewModel.creareEmptyBook(isbn13: searchText)  // 検索した本が見つからない場合は空の登録フォームを表示する
                            }
                        }
                    }
                
                Button {
                    print("camera")
                    isOpenScanner = true
                } label: {
                    Image(systemName: "barcode.viewfinder")
                        .font(.title2)
                }
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .transition(.opacity)
            }
            
        }
    }
    
    // すべての本を選択する
    private func selectAllBooks() {
        selectedBooks = Set(books.map { $0.id })
    }
    
    // 入力値のチェック (13桁の数字であるかどうかの判定)
    private func isValidISBN(_ searchText: String) -> Bool {
        let regex = #"^\d{13}$"#
        guard searchText.range(of: regex, options: .regularExpression) != nil else {
            return false
        }
        return searchText.hasPrefix("978")
    }
    
}
