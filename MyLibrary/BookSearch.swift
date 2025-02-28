//
//  Book.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 28.02.2025.
//

import Foundation

struct BookSearch: Codable {
    let docs: [Document]
    
    struct Document: Codable {
        let authorKey: String
        let authorName: String
        let firstPublishYear: Int
        let title: String
        
        enum CodingKeys: String, CodingKey {
            case authorKey = "author_key"
            case authorName = "author_name"
            case firstPublishYear = "first_publish_year"
            case title
        }
    }
}
