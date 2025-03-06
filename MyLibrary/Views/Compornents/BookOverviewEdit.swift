//
//  BookListEdit.swift
//  MyLibrary
//


import SwiftUI

struct BookOverviewEdit: View {
    
    @Binding var title: String
    @Binding var subTitle: String
    @Binding var author: String
    var thumbnailURL: URL? = nil
    
    var body: some View {
        
        HStack {
            
            if let thumbnailURL = thumbnailURL {
                AsyncImage(url: thumbnailURL) { response in
                    response.image?
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 80)
                }
            } else {
                Image("no_image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 80)
            }
            
            VStack(alignment: .leading) {
                TextField("タイトルを入力", text: $title, axis: .vertical)
                    .font(.body)
                
                TextField("サブタイトルを入力", text: $subTitle, axis: .vertical)
                    .font(.footnote)
                
                TextField("著者を入力", text: $author, axis: .vertical)
                    .font(.footnote)
            }
            .padding(.leading)
        }
    }
}

#Preview {
    
    @Previewable @State var title: String = "本のタイトル"
    @Previewable @State var subTitle: String = ""
    @Previewable @State var author: String = "本の著者"
    
    BookOverviewEdit(title: $title, subTitle: $subTitle, author: $author)
}
