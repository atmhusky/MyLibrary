import SwiftUI

struct BookDetailView: View {
    var isNewBook: Bool = false  // 新規登録であるか
    @State var isEditing: Bool = false // 編集中であるか
    
    // 表示確認用
    @Binding var title: String
    @Binding var subTitle: String
    @Binding var author: String
    var thumbnailURL: URL? = URL(string: "https://books.google.com/books/content?id=G9BbLwEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api")
    
    @Binding var description: String
    @Binding var isbn: String
    @Binding var pageCount: String
    @Binding var publishedDate: Date?
    @Binding var memo: String
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                // 本の基本情報
                Section {
                    BookOverview(title: $title, subTitle: $subTitle, author: $author, thumbnailURL: thumbnailURL, isEditing: isEditing)
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
    
    // 表示確認用
    @Previewable @State var title: String = "本のタイトル"
    @Previewable @State var subTitle: String = "本のサブタイトル本のサブタイトル本のサブタイトル"
    @Previewable @State var author: String = "本の著者"
    @Previewable @State var thumbnailURL: URL? = URL(string: "https://books.google.com/books/content?id=G9BbLwEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api")
    
    @Previewable @State var description: String = "本の説明文をここに記述．本の説明文をここに記述．本の説明文をここに記述．本の説明文をここに記述．本の説明文をここに記述．"
    @Previewable @State var isbn: String = "1234567890123"
    @Previewable @State var pageCount: String = "0"
    @Previewable @State var publishedDate: Date? = nil
    @Previewable @State var memo: String = "好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．好きなことをここにメモとして記録できる．"
    
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

extension BookDetailView {
    
    private func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            return formatter.string(from: date)
    }
    
    
}
