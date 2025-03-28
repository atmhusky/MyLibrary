//
//  SortOption.swift
//  MyLibrary
//  


import Foundation

enum SortOption: CaseIterable, Identifiable {
    case createdAscending
    case createdDescending
    case titleAscending
    case titleDescending
    case publishedAscending
    case publishedDescending
}

extension SortOption {
    
    var id: String {
        switch self {
        case .createdAscending: return "追加日(昇順)"
        case .createdDescending: return "追加日(降順)"
        case .titleAscending: return "タイトル(昇順)"
        case .titleDescending: return "タイトル(降順)"
        case .publishedAscending: return "出版日(昇順)"
        case .publishedDescending: return "出版日(降順)"
        }
    }
    
    var descriptor: SortDescriptor<Book> {
        switch self {
        case .createdAscending:
            return SortDescriptor(\.createdAt, order: .forward)
        case .createdDescending:
            return SortDescriptor(\.createdAt, order: .reverse)
        case .titleAscending:
            return SortDescriptor(\.title, comparator: .localizedStandard, order: .forward)
        case .titleDescending:
            return SortDescriptor(\.title, comparator: .localizedStandard, order: .reverse)
        case .publishedAscending:
            return SortDescriptor(\.publishedDate, order: .forward)
        case .publishedDescending:
            return SortDescriptor(\.publishedDate, order: .reverse)
        }
    }
}
