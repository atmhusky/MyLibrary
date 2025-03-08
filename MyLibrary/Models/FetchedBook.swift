//
//  FetchedBook.swift
//  MyLibrary
//  

import Foundation

struct FetchedBook: Codable {
    
    let items: [Item]
    
    struct Item: Codable {
        let id: String
        let volumeInfo: VolumeInfo        
    }
    
    struct VolumeInfo: Codable {
        let title: String
        let subtitle: String
        let authors: [String]
        let publishedDate: String
        let description: String
        let industryIdentifiers: [IndustryIdentifier]
        let imageLinks: ImageLinks
        let pageCount: Int
    }
    
    struct IndustryIdentifier: Codable {
        let type: String
        let identifier: String
    }
    
    struct ImageLinks: Codable {
        let smallThumbnail: String
        let thumbnail: String
    }
}

