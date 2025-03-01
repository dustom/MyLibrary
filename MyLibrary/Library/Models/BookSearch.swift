//
//  Book.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 28.02.2025.
//

import Foundation

import Foundation

struct BookSearch: Codable {
    let items: [Item]
}

struct Item: Codable, Hashable {
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable, Hashable {
    let title: String
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let industryIdentifiers: [IndustryIdentifier]?
    let pageCount: Int?
    let imageLinks: ImageLinks?
}

struct IndustryIdentifier: Codable, Hashable {
    let type: String
    let identifier: String
}

struct ImageLinks: Codable, Hashable {
    let thumbnail: String
}
