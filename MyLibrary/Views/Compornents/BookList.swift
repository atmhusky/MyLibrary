//
//  BookList.swift
//  MyLibrary
//  


import SwiftUI
import SwiftData

struct BookList: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [Book]
    @EnvironmentObject var bookViewModel: BookViewModel
    @Binding var editMode: EditMode
    @Binding var selectedSortOption: SortOption
    
    init(editMode: Binding<EditMode>, selectedSortOption: Binding<SortOption>) {
        self._editMode = editMode
        self._selectedSortOption = selectedSortOption
        _books = Query(sort: [selectedSortOption.wrappedValue.descriptor])
    }
    
    var body: some View {
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
