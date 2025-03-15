//
//  ISBNHelpMessage.swift
//  MyLibrary
//  


import SwiftUI

struct ISBNHelpMessage: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("書籍のバーコードについて")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            Text(
            """
            日本で出版される書籍には、通常2種類のバーコードが印刷されています。
            
            1つ目は [ISBN（国際標準図書番号）](https://ja.wikipedia.org/wiki/ISBN) で、書籍を識別するための固有のコードです。基本的には「978」から始まります。
            
            2つ目は [日本図書コード](https://ja.wikipedia.org/wiki/日本図書コード) で、Cコードと呼ばれる書籍の分類情報と価格情報が含まれています。
            
            このアプリでは**ISBNのみをサポート**しており、「日本図書コード」をスキャンした場合は正しく読み取れません。
            """)
            .padding(.top, 7)
            
            Text("※日本図書コードを指で隠してスキャンすると読み取りやすいです。")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.top)
            
            Text("※書籍によっては情報が取得できないものもあります。")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ISBNHelpMessage()
}
