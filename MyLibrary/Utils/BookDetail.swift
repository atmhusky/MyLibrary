//
//  BookDetail.swift
//  MyLibrary
//  


import Foundation

enum BookDetail {
    case description
    case isbn
    case pageCount
}

extension BookDetail {
    
    var symbol: String {
        switch self {
        case .description:
            "info.circle"
        case .isbn:
            "barcode"
        case .pageCount:
            "book.pages"
        }
    }
    
    var itemName: String {
        switch self {
        case .description:
            "説明"
        case .isbn:
            "ISBN"
        case .pageCount:
            "ページ数"
        }
    }
    
    var textFieldText: String {
        switch self {
        case .description:
            "本の説明文"
        case .isbn:
            "本のISBNコード"
        case .pageCount:
            "本のページ数"
        }
    }
    
    var permitNewline: Bool {
        switch self {
        case .description:
            true
        case .isbn, .pageCount:
            false
        }
    }
}
