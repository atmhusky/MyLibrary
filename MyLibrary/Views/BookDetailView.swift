import SwiftUI
import SwiftData

struct BookDetailView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [Book]
    @EnvironmentObject var bookViewModel: BookViewModel
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var book: Book
    
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
                    
                    // 出版日
                    HStack(spacing: 10) {
                        Image(systemName: "calendar")
                            .imageScale(.large)
                        
                        Text("出版日")
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
//                        if isEditing {
//                            DatePicker("", selection: Binding(
//                                get: { book.publishedDate ?? Date() },
//                                set: { newDate in book.publishedDate = newDate }
//                            ), displayedComponents: .date)
//                            .datePickerStyle(.compact)
//                            
//                        } else {
//                            Text(book.publishedDate != nil ? formattedDate(book.publishedDate!) : "未指定")
//                                .lineLimit(nil)
//                                .foregroundStyle(.secondary)
//                        }
                    }
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
                            isNewBook ? bookViewModel.addBook(book) : updateBook(book)
                            isNewBook ? dismiss() : isEditing.toggle()
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
            id: "111",
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

extension BookDetailView {
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    func updateBook(_ book: Book) {
        try? modelContext.save()
        print("更新成功")
    }
}
