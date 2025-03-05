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
                    
                    Section(header: Text("蔵書一覧")){
                        ForEach(1..<10, id: \.self) { item in
                            NavigationLink {
                                BookDetailView()
                            } label: {
                                HStack {
                                    Image("no_image")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 80)
                                    
                                    VStack(alignment: .leading) {
                                        Text("本のタイトル")
                                            .font(.body)
                                            .lineLimit(1)
                                        
                                        Text("本の著者")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
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
                        Button(editMode == .active ? "完了" : "編集") {
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
                            Spacer()
                            Button {
                                exportItems()
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                            }
                            Spacer()
                            Button {
                                removeItems()
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(.red)
                            }
                            Spacer()
        
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isShowBookDetailView) {
            BookDetailView()
        }
    }
    
    
}

#Preview {
    ListView()
}

extension ListView {
    
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
