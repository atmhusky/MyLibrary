import SwiftUI

struct BookDetailView: View {
    var isNewBook: Bool = false  // 新規登録であるか
    @State var isEditing: Bool // 編集中であるか
    
    // 表示確認用
    @State var title: String = "本のタイトル"
    @State var subTitle: String = "本のサブタイトル本のサブタイトル本のサブタイトル"
    @State var author: String = "本の著者"
    @State var thumbnailURL: URL? = URL(string: "https://books.google.com/books/content?id=G9BbLwEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api")
    
    @State private var description: String = "本の説明文をここに記述．本の説明文をここに記述．本の説明文をここに記述．本の説明文をここに記述．本の説明文をここに記述．"
    @State private var isbn: String = "1234567890123"
    @State private var pageCount: String = "0"
    @State private var publishedDate: Date? = nil
    @State private var memo: String = "好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．"
    
    @Environment(\.dismiss) private var dismiss
    
    init(isNewBook: Bool) {
        self.isNewBook = isNewBook
        _isEditing = State(initialValue: isNewBook) // 新規登録なら編集を有効化した状態に
    }
    
    var body: some View {
        NavigationStack {
            List {
                // 本の基本情報
                Section {
                    if isEditing {
                        BookOverviewEdit(title: $title, subTitle: $subTitle, author: $author, thumbnailURL: thumbnailURL)
                    } else {
                        BookOverviewRow(title: title, subTitle: subTitle, author: author,thumbnailURL: thumbnailURL, permitNewline: true)
                    }
                }
                
                // 本の詳細情報
                Section("本の詳細情報") {
                    
                    BookDetailRow(bookDetail: .description, inputText: $description, isEditing: isEditing)
                    
                    BookDetailRow(bookDetail: .isbn, inputText: $isbn, isEditing: isEditing)
                    
                    BookDetailRow(bookDetail: .pageCount, inputText: $pageCount, isEditing: isEditing)
                    
                    // 出版日
                    HStack(spacing: 10) {
                        Image(systemName: "calendar")
                            .imageScale(.large)
                        
                        Text("出版日")
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        if isEditing {
                            DatePicker("", selection: Binding(
                                get: { publishedDate ?? Date() },
                                set: { newDate in publishedDate = newDate }
                            ), displayedComponents: .date)
                            .datePickerStyle(.compact)

                        } else {
                            Text(publishedDate != nil ? formattedDate(publishedDate!) : "未指定")
                                .lineLimit(nil)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                // 自由に記録を残す用のメモ欄
                Section("メモ") {
                    if isEditing {
                        TextField("好きなことをメモしておこう", text: $memo, axis: .vertical)
                            .lineLimit(nil)
                    } else {
                        Text(memo)
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
                            print("登録/保存")
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
    NavigationStack {
        BookDetailView(isNewBook: false)
    }
}

extension BookDetailView {
    
    private func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            return formatter.string(from: date)
    }
    
    
}
