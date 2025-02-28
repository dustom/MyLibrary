//
//  Book.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 28.02.2025.
//

import Foundation

struct BookSearch: Codable {
    let docs: [Book]
    
    struct Book: Codable, Hashable {
        let authorKey: [String]?
        let authorName: [String]?
        let cover: Double?
        let firstPublishYear: Double?
        let title: String
        
        enum CodingKeys: String, CodingKey {
            case authorKey = "author_key"
            case authorName = "author_name"
            case cover = "cover_i"
            case firstPublishYear = "first_publish_year"
            case title
        }
    }
}
