import SwiftUI
import SwiftData

struct BookDetailView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [Book]
    @EnvironmentObject var bookViewModel: BookViewModel
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var book: Book
    
    @State var publishedDateErrorMessage: String = ""
    
    var isNewBook: Bool = false  // 新規登録であるか
    @State var isEditing: Bool = false // 編集中であるか
    
    var body: some View {
        NavigationStack {
            List {
                // 本の基本情報
                Section {
                    BookOverview(book: book, isEditing: isEditing)
                }
                
                // 本の詳細情報
                Section("本の詳細情報") {
                    
                    BookDetailRow(bookDetail: .description, inputText: $book.bookDescription, isEditing: isEditing)
                    
                    BookDetailRow(bookDetail: .isbn, inputText: $book.isbn13, isEditing: isEditing)
                    
                    BookDetailRow(bookDetail: .pageCount, inputText: $book.pageCount, isEditing: isEditing)
                    
                    BookDetailRow(bookDetail: .publishedDate, inputText: $book.publishedDate, isEditing: isEditing, errorMessage: publishedDateErrorMessage)
                }
                
                // 自由に記録を残す用のメモ欄
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
                ToolbarItem(placement: .topBarLeading) {
                    if isEditing {
                        Button("キャンセル") {
                            print("キャンセル")
                            isNewBook ? dismiss() : isEditing.toggle()
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if isEditing {
                        Button(isNewBook ? "登録" : "保存") {
                            if bookViewModel.isValidPublishedDateString(book.publishedDate) {
                                publishedDateErrorMessage = ""
                                isNewBook ? bookViewModel.addBook(book, modelContext: modelContext) : bookViewModel.updateBook(book, modelContext: modelContext)
                                isNewBook ? dismiss() : isEditing.toggle()
                                
                            } else {
                                publishedDateErrorMessage = "入力値が不正です。"
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
