//
//  ListView.swift
//  MyLibrary
//


import SwiftUI
import SwiftData
import CodeScanner

struct ListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Book.createdAt, order: .reverse) private var books: [Book]
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @State var searchText = ""
    @State var selectedBooks: Set<String> = []
    @State var editMode: EditMode = .inactive
    @State var fetchedBook: Book?
    @State var errorMessage: String? = nil
    @State var isOpenScanner = false
    @State var isShowAlert = false
    
    @FocusState var keyboardFocus: Bool
    
    var body: some View {
        NavigationStack {
            List(selection: $selectedBooks) {
                Section("本の追加") {
                    search
                }
                
                Section("蔵書一覧"){
                    if books.isEmpty {
                        emptyBook
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
            .navigationTitle("MyLibrary")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(editMode == .active ? "完了" : "選択") {
                        editMode = editMode == .active ? .inactive : .active
                        selectedBooks = []
                    }
                }
                
                if editMode == .active {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("すべて選択") {
                            selectedBooks = Set(books.map { $0.id })
                        }
                    }
                    
                    
                    if !selectedBooks.isEmpty {
                        ToolbarItemGroup(placement: .bottomBar) {
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
        .sheet(item: $fetchedBook, onDismiss: {  // 本の新規登録のモーダル
            searchText = ""
        }, content: { book in
            BookDetailView(book: book, isNewBook: true, isEditing: true)
        })
        .sheet(isPresented: $isOpenScanner) {  // バーコードスキャンのモーダル
            BarcodeScanView(isOpenScanner: $isOpenScanner, fetchedBook: $fetchedBook, errorMessage: $errorMessage)
        }
    }
}

#Preview {
    ListView()
        .modelContainer(for: Book.self, inMemory: true)
        .environmentObject(BookViewModel())
}

extension ListView {
    
    private var emptyBook: some View {
        HStack {
            Spacer()
            VStack {
                Text("書籍が登録されていません")
                    .fontWeight(.bold)
                    .font(.title2)
                    .padding()
                
                Text("上の検索バーかバーコードのアイコンをタップして書籍を登録しましょう！")
                    .foregroundStyle(.secondary)
                    .padding([.leading, .bottom, .trailing])
            }
            Spacer()
        }
    }
    
    private var search: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("ISBNコードを入力(13桁の数字)", text: $searchText)
                    .keyboardType(.numberPad)
                    .focused(self.$keyboardFocus)
                    .onChange(of: searchText) { _, newValue in
                        guard newValue.count == 13 else { return }
                        
                        print(newValue)
                        
                        errorMessage = bookViewModel.checkRegisterableISBN(searchText: newValue, modelContext: modelContext)
                        guard errorMessage == nil else { return }
                        
                        Task {
                            do {
                                fetchedBook = try await bookViewModel.fetchBook(isbn: searchText)
                            } catch {
                                print("検索したISBNの本は見つかりませんでした：\(error)")
                                fetchedBook = bookViewModel.creareEmptyBook(isbn13: searchText)  // 検索した本が見つからない場合は空の登録フォームを表示する
                            }
                        }
                        
                    }
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            HStack {
                                Spacer()
                                
                                Button {
                                    keyboardFocus = false
                                } label: {
                                    Text(Image(systemName: "keyboard.chevron.compact.down"))
                                        .foregroundStyle(Color(uiColor: .label))
                                }
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
}
