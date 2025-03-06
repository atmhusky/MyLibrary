//
//  ListView.swift
//  MyLibrary
//


import SwiftUI

struct ListView: View {
    
    @State private var searchText = ""
    @State private var isShowBookDetailView: Bool = false
    @State private var selectedItems: Set<Int> = []
    @State private var editMode: EditMode = .inactive
    
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
                                BookDetailView(isNewBook: false)
                            } label: {
                                BookOverviewRow(title: "本のタイトル", subTitle: "本のサブタイトル", author: "本の著者", thumbnailURL: URL(string: "https://books.google.com/books/content?id=G9BbLwEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"))
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
            BookDetailView(isNewBook: true)
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
