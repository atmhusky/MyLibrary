import SwiftUI
import SwiftData

struct BookDetailView: View {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var bookViewModel: BookViewModel
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var book: Book
    
    @State var publishedDateErrorMessage: String?
    @State var isbnErrorMessage: String?
    
    var isNewBook: Bool = false  // 新規登録であるか
    @State var isEditing: Bool = false // 編集中であるか
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    BookOverview(book: book, isEditing: isEditing, canScroll: true)
                }
                
                Section("本の詳細情報") {
                    
                    BookDetailRow(bookDetail: .description, inputText: $book.bookDescription, isEditing: isEditing)
                    
                    BookDetailRow(bookDetail: .isbn, inputText: $book.isbn13, isEditing: isEditing, errorMessage: isbnErrorMessage)
                    
                    BookDetailRow(bookDetail: .pageCount, inputText: $book.pageCount, isEditing: isEditing)
                    
                    BookDetailRow(bookDetail: .publishedDate, inputText: $book.publishedDate, isEditing: isEditing, errorMessage: publishedDateErrorMessage)
                }
                
                Section("メモ") {
                    if isEditing {
                        TextField("好きなことをメモしておこう", text: $book.memo, axis: .vertical)
                            .lineLimit(nil)
                    } else {
                        Text(book.memo)
                            .lineLimit(nil)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle(isEditing ? "本の情報を編集" : "本の情報")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(isEditing)
            .toolbar {
                if isEditing {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("キャンセル") {
                            isNewBook ? dismiss() : isEditing.toggle()
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if isEditing {
                        Button(isNewBook ? "登録" : "保存") {
                            if isNewBook {
                                isbnErrorMessage = bookViewModel.checkRegisterableISBN(searchText: book.isbn13, modelContext: modelContext)
                            }
                            publishedDateErrorMessage = bookViewModel.isValidPublishedDateString(book.publishedDate) ? nil : "入力値が規定通りではありません。"
                            if (isbnErrorMessage == nil) && (publishedDateErrorMessage == nil) {
                                isNewBook ? bookViewModel.addBook(book, modelContext: modelContext) : bookViewModel.updateBook(book, modelContext: modelContext)
                                isNewBook ? dismiss() : isEditing.toggle()
                            }
                        }
                    } else {
                        Button("編集") {
                            isEditing.toggle()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    
    BookDetailView(book:
        Book(
            title: "タイトル",
            subtitle: "サブタイトル",
            authors: ["著者1", "著者2"],
            bookDescription: "本の説明文",
            publishedDate: "2020-11",
            imageUrlString: "https://books.google.com/books/content?id=G9BbLwEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
            pageCount: 123,
            isbn13: "1234567890123"
        )
    )
    .modelContainer(for: Book.self, inMemory: true)
}
