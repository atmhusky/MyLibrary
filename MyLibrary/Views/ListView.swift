//
//  ListView.swift
//  MyLibrary
//


import SwiftUI

struct ListView: View {
    
    @State var searchText = ""
    @State var isShowBookDetailView: Bool = false
    @State var selectedItems: Set<Int> = []
    @State var editMode: EditMode = .inactive
    
    // BookDetailViewに渡す表示確認用
    @State var title: String = "本のタイトル"
    @State var subTitle: String = "本のサブタイトル本のサブタイトル本のサブタイトル"
    @State var author: String = "本の著者"
    @State var thumbnailURL: URL? = URL(string: "https://books.google.com/books/content?id=G9BbLwEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api")
    
    @State var description: String = "本の説明文をここに記述．本の説明文をここに記述．本の説明文をここに記述．本の説明文をここに記述．本の説明文をここに記述．"
    @State var isbn: String = "1234567890123"
    @State var pageCount: String = "0"
    @State var publishedDate: Date? = nil
    @State var memo: String = "好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                List(selection: $selectedItems) {
                    Section("本の追加") {
                        search
                    }
                    
                    Section("蔵書一覧"){
                        ForEach(1..<10, id: \.self) { item in
                            NavigationLink {
                                BookDetailView(
                                    title: $title,
                                    subTitle: $subTitle,
                                    author: $author,
                                    thumbnailURL: thumbnailURL,
                                    description: $description,
                                    isbn: $isbn,
                                    pageCount: $pageCount,
                                    publishedDate: $publishedDate,
                                    memo: $memo
                                )
                            } label: {
                                BookOverview(
                                    title: $title,
                                    subTitle: $subTitle,
                                    author: $author,
                                    thumbnailURL: thumbnailURL
                                )
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
            // 表示確認用・あとで消す
            BookDetailView(
                title: $title,
                subTitle: $subTitle,
                author: $author,
                thumbnailURL: thumbnailURL,
                description: $description,
                isbn: $isbn,
                pageCount: $pageCount,
                publishedDate: $publishedDate,
                memo: $memo
            )
        }
    }
}

#Preview {
    ListView()
}

extension ListView {
    
    private var search: some View {
        HStack {
            TextField("ISBNコードを直接入力", text: $searchText)
                .onSubmit {
                    print(searchText)
                    isShowBookDetailView = true
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
}
