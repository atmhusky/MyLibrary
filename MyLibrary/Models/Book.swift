//
//  Book.swift
//  MyLibrary
//  


import Foundation
import SwiftData

@Model
class Book: Identifiable {
    var id: String
    var title: String
    var subtitle: String
    var authors: String
    var bookDescription: String
    var publishedDate: String
    var imageUrl: URL?
    var pageCount: String
    var isbn13: String
    var memo: String
    var createdAt: Date
    
    init(title: String, subtitle: String, authors: [String], bookDescription: String, publishedDate: String, imageUrlString: String?, pageCount: Int, isbn13: String, memo: String = "") {
        self.id = UUID().uuidString
        self.title = title
        self.subtitle = subtitle
        self.authors = authors.joined(separator: ", ")
        self.bookDescription = bookDescription
        self.publishedDate = publishedDate
        self.pageCount = String(pageCount)
        self.isbn13 = isbn13
        self.memo = memo
        self.createdAt = Date()
        
        // "http" を "https" に置き換え (こうしないと画像が表示されない)
        if let imageUrlString = imageUrlString {
            if imageUrlString.hasPrefix("http://") {
                self.imageUrl = URL(string: imageUrlString.replacingOccurrences(of: "http://", with: "https://"))
            } else {
                self.imageUrl = URL(string: imageUrlString)
            }
        } else {
            self.imageUrl = nil
        }
    }
}
