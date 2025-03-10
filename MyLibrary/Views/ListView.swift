//
//  ListView.swift
//  MyLibrary
//


import SwiftUI
import SwiftData

struct ListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [Book]
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @State var searchText = ""
    @State var selectedBooks: Set<String> = []
    @State var editMode: EditMode = .inactive
    @State var fetchedBook: Book?
    @State var errorMessage: String? = nil
    
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
                            NavigationLink {
                                BookDetailView(book: book)
                            } label: {
                                BookOverview(book: book)
                            }
                            .tag(book.id)
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
                        if editMode == .active {
                            Button {
                                bookViewModel.exportBooksToCSV(selectedBooks: selectedBooks ,modelContext: modelContext)
                            } label: {
                                Text("CSVへエクスポート")
                            }
                            
                            Spacer()
                            
                            Button {
                                bookViewModel.deleteBooks(selectedBooks: selectedBooks, modelContext: modelContext)
                                editMode = .inactive
                            } label: {
                                Text("削除")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $fetchedBook) { book in
            BookDetailView(book: book, isNewBook: true, isEditing: true)
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
                            errorMessage = "※ISBNコードは13桁の数字で入力してください"
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
        return searchText.range(of: regex, options: .regularExpression) != nil
    }
    
}
