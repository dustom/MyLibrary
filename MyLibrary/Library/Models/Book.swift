//
//  Book.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 01.03.2025.
//

import Foundation
import SwiftData

@Model
final class Book: Equatable, Hashable, Identifiable {
    #Unique<Book>([\.title, \.author])
    
    var title: String
    var author: [String]?
    var pages: Int?
    var coverImageURL: URL?
    var isbn: String?
    var bookDescription: String?
    var publisher: String?
    var publishedDate: Date?
    var categories: [String]?
    var placement: BookPlacement?
    
    init(title: String, author: [String]? = nil, pages: Int? = nil, coverImageURL: URL? = nil, isbn: String? = nil, description: String? = nil, publisher: String? = nil, publishedDate: Date? = nil, categories: [String]? = nil, placement: BookPlacement? = nil) {
        self.title = title
        self.author = author
        self.pages = pages
        self.coverImageURL = coverImageURL
        self.isbn = isbn
        self.bookDescription = description
        self.publisher = publisher
        self.publishedDate = publishedDate
        self.categories = categories
        self.placement = placement
    }
    
}

enum BookPlacement: String, Codable {
    case toBeRead = "To Be Read"
    case reading = "Reading"
    case read = "Read"
}
