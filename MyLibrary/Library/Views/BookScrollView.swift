//
//  BookScrollView.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 02.03.2025.
//

import SwiftUI
import SwiftData

struct BookScrollView: View {
    
    var bookPlacement: BookPlacement
    @Query var libraryQuery: [Book] = []
    @State var bookToPresent: Book?
    @State private var isBookDetailPresented = false
    
    var body: some View {
        NavigationStack{
            HStack{
                Text(bookPlacement.rawValue)
                    .font(.title3)
                
                Spacer()
                
                NavigationLink{
                    ShowAllBookPlacementView(placement: bookPlacement, library: libraryQuery)
                } label:
                {
                    Text("Show All")
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    let sortedLibrary = libraryQuery.sorted { $0.lastChange > $1.lastChange }
                    ForEach(sortedLibrary.filter { $0.placement == bookPlacement}) { book in
                        Button {
                            bookToPresent = book
                        } label: {
                            BookTile(book: book)
                                .buttonStyle(.plain)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 5)
                                .draggable(BookTile(book: book))
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                }
                
                .padding(.horizontal)
            }
        }
        .fullScreenCover(item: $bookToPresent) { book in
            BookDetailView(book: book, isEditable: true)
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
    
    let placement: BookPlacement = .reading
    BookScrollView(bookPlacement: placement)
}
