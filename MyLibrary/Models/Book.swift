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
    var authors: [String]
    var bookDescription: String
    var publishedDate: String
    var imageUrl: URL?
    var pageCount: Int
    var isbn13: String
    
    init(id: String, title: String, subtitle: String, authors: [String], bookDescription: String, publishedDate: String, imageUrlString: String, pageCount: Int, isbn13: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.authors = authors
        self.bookDescription = bookDescription
        self.publishedDate = publishedDate
        self.imageUrl = URL(string: imageUrlString)
        self.pageCount = pageCount
        self.isbn13 = isbn13
    }
}
