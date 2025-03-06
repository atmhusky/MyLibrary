import SwiftUI

struct BookDetailView: View {
    var isNewBook: Bool = false  // 新規登録であるか
    @State private var isEditing: Bool // 編集中であるか
    
    // 表示確認用
    @State private var title: String = "本のタイトル"
    @State private var subTitle: String = "本のサブタイトル本のサブタイトル本のサブタイトル"
    @State private var author: String = "本の著者"
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
                    HStack {
                        Image("no_image")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 130)
                        
                        VStack(alignment: .leading) {
                            if isEditing {
                                TextField("タイトルを入力", text: $title, axis: .vertical)
                                    .font(.body)
                                
                                TextField("サブタイトルを入力", text: $subTitle, axis: .vertical)
                                    .font(.footnote)
                                
                                TextField("著者を入力", text: $author, axis: .vertical)
                                    .font(.footnote)
                            } else {
                                Text(title)
                                    .font(.body)
                                    .lineLimit(1)
                                
                                if(subTitle != "") {
                                    Text(subTitle)
                                        .font(.footnote)
                                }
                                
                                Text(author)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                
                // 本の詳細情報
                Section("本の詳細情報") {
                    // 説明
                    HStack(spacing: 10) {
                        Image(systemName: "info.circle")
                            .imageScale(.large)
                        
                        Text("説明")
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        if isEditing {
                            TextField("本の説明文", text: $description, axis: .vertical)
                                .lineLimit(nil)
                        } else {
                            Text(description)
                                .lineLimit(nil)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    // ISBN
                    HStack(spacing: 10) {
                        Image(systemName: "barcode")
                            .imageScale(.large)
                        
                        Text("ISBN")
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        if isEditing {
                            TextField("本の説明文", text: $isbn, axis: .vertical)
                                .lineLimit(nil)
                        } else {
                            Text(isbn)
                                .lineLimit(nil)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    // ページ数
                    HStack(spacing: 10) {
                        Image(systemName: "book.pages")
                            .imageScale(.large)
                        
                        Text("ページ数")
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        if isEditing {
                            TextField("本の説明文", text: $pageCount, axis: .vertical)
                                .lineLimit(nil)
                        } else {
                            Text(pageCount)
                                .lineLimit(nil)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
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
