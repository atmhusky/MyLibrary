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
    @State var isShowBookDetailView: Bool = false
    @State var selectedItems: Set<Int> = []
    @State var editMode: EditMode = .inactive
    @State var fetchedBook: Book?
    
    // 表示確認用
    let sampleBook1 = Book(id: "G9BbLwEACAAJ", title: "タイポグラフィ・ハンドブック", subtitle: "", authors: ["小泉均"], bookDescription: "欧文組版のすべてが分かるハンドブック", publishedDate: "2012-06",                          imageUrlString: "https://books.google.com/books/content?id=G9BbLwEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api", pageCount: 493, isbn13: "9784327377328")
    let sampleBook2 = Book(id: "wm98zQEACAAJ", title: "Swift実践入門", subtitle: "直感的な文法と安全性を兼ね備えた言語", authors: ["石川洋資", "西山勇世"], bookDescription: "先進的な機能を駆使した簡潔でバグのないコード。Xcodeで動かしながら学ぶ基本、設計指針、実装パターン", publishedDate: "2020-04",                          imageUrlString: "https://books.google.com/books/content?id=wm98zQEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api", pageCount: 453, isbn13: "9784297112134")

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // 動的な表示確認用
                Button("表示用登録") {
                    self.addBook(sampleBook1)
                    self.addBook(sampleBook2)
                }
                
                List(selection: $selectedItems) {
                    Section("本の追加") {
                        search
                    }
                    
                    Section("蔵書一覧"){
                        ForEach(books) { book in
                            NavigationLink {
                                BookDetailView(book: book)
                            } label: {
                                BookOverview(book: book)
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
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        if editMode == .active {
                            Button("すべて選択") {
                                selectAllItems()
                            }
                        }
                    }
                    
                    ToolbarItemGroup(placement: .bottomBar) {
                        if editMode == .active {
                            Button {
                                exportItems()
                            } label: {
                                Text("CSVへエクスポート")
                            }
                            
                            Spacer()
                            
                            Button {
                                removeItems()
                            } label: {
                                Text("削除")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isShowBookDetailView) {
            if let fetchedBook = fetchedBook {
                BookDetailView(book: fetchedBook, isNewBook: true, isEditing: true)
            }
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
        HStack {
            TextField("ISBNコードを直接入力", text: $searchText)
                .onSubmit {
                    print(searchText)
                    Task {
                        do {
                            fetchedBook = try await bookViewModel.fetchBook(isbn: searchText)
                            addBook(fetchedBook!)
//                            isShowBookDetailView = true
                        } catch {
                            print("検索したISBNの本は見つかりませんでした：\(error)")
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
    }
    
    private func removeItems() {
        print("削除するアイテム: \(selectedItems)")
        selectedItems.removeAll()
    }
    
    private func exportItems() {
        print("エクスポートするアイテム: \(selectedItems)")
    }
    
    private func selectAllItems() {
        selectedItems = Set(0..<10)
    }
    
    func addBook(_ book: Book) {
        modelContext.insert(book)
        print("保存完了")
    }
    
}
