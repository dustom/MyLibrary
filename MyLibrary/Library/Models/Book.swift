//
//  Book.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 01.03.2025.
//

import Foundation
import SwiftData

@Model
final class Book: Codable, Equatable, Hashable, Identifiable, ObservableObject {
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
    
    enum CodingKeys: String, CodingKey {
            case title
            case author
            case pages
            case coverImageURL
            case isbn
            case bookDescription = "description"
            case publisher
            case publishedDate
            case categories
            case placement
        }
    
    func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(title, forKey: .title)
            try container.encodeIfPresent(author, forKey: .author)
            try container.encodeIfPresent(pages, forKey: .pages)
            try container.encodeIfPresent(coverImageURL, forKey: .coverImageURL)
            try container.encodeIfPresent(isbn, forKey: .isbn)
            try container.encodeIfPresent(bookDescription, forKey: .bookDescription)
            try container.encodeIfPresent(publisher, forKey: .publisher)
            try container.encodeIfPresent(publishedDate, forKey: .publishedDate)
            try container.encodeIfPresent(categories, forKey: .categories)
            try container.encodeIfPresent(placement, forKey: .placement)
        }
        
        // Implement init(from:) for decoding
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            title = try container.decode(String.self, forKey: .title)
            author = try container.decodeIfPresent([String].self, forKey: .author)
            pages = try container.decodeIfPresent(Int.self, forKey: .pages)
            coverImageURL = try container.decodeIfPresent(URL.self, forKey: .coverImageURL)
            isbn = try container.decodeIfPresent(String.self, forKey: .isbn)
            bookDescription = try container.decodeIfPresent(String.self, forKey: .bookDescription)
            publisher = try container.decodeIfPresent(String.self, forKey: .publisher)
            publishedDate = try container.decodeIfPresent(Date.self, forKey: .publishedDate)
            categories = try container.decodeIfPresent([String].self, forKey: .categories)
            placement = try container.decodeIfPresent(BookPlacement.self, forKey: .placement)
        }
    
}

enum BookPlacement: String, CaseIterable, Codable, Identifiable {
    case reading = "Reading"
    case toBeRead = "To Be Read"
    case read = "Read"
    var id: Self { self }
}
