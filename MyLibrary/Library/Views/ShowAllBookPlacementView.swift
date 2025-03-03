//
//  ShowAllBookPlacementView.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 02.03.2025.
//

import SwiftUI

struct ShowAllBookPlacementView: View {
    let placement: BookPlacement
    var library: [Book]
    var body: some View {
        NavigationStack{
            List{
                ForEach(library.filter { $0.placement == placement }) { book in
                    NavigationLink {
                        BookDetailView(book: book, isEditable: true)
                    }label: {
                        BookNavigationLinkView(book: book)
                    }
                }
            }
            .navigationTitle(placement.rawValue)
        }
    }
}

#Preview {
    
    let library: [Book] = [Book(
        title: "The Hobbit",
        author: ["J.R.R. Tolkien"],
        pages: 310,
        coverImageURL: URL(string: "https://books.google.com/books/content?id=CixXEAAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
        isbn: "9780547928227",
        description: "A classic fantasy novel about Bilbo Baggins and his adventure to reclaim the Lonely Mountain.",
        publisher: "Houghton Mifflin Harcourt",
        publishedDate: Date(),
        categories: ["Fantasy", "Adventure"],
        placement: .reading,
        lastChange: Date()
    ), Book(
        title: "The Hobbit",
        author: ["J.R.R. Tolkien"],
        pages: 310,
        coverImageURL: URL(string: "https://books.google.com/books/content?id=CixXEAAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
        isbn: "9780547928227",
        description: "A classic fantasy novel about Bilbo Baggins and his adventure to reclaim the Lonely Mountain.",
        publisher: "Houghton Mifflin Harcourt",
        publishedDate: Date(),
        categories: ["Fantasy", "Adventure"],
        placement: .reading,
        lastChange: Date()
    ),
        Book(
        title: "The Hobbit",
        author: ["J.R.R. Tolkien"],
        pages: 310,
        coverImageURL: URL(string: "https://books.google.com/books/content?id=CixXEAAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
        isbn: "9780547928227",
        description: "A classic fantasy novel about Bilbo Baggins and his adventure to reclaim the Lonely Mountain.",
        publisher: "Houghton Mifflin Harcourt",
        publishedDate: Date(),
        categories: ["Fantasy", "Adventure"],
        placement: .reading,
        lastChange: Date()
    )]
    
    ShowAllBookPlacementView(placement: .reading, library: library)
}
