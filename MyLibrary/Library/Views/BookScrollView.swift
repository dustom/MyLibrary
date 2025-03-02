//
//  BookScrollView.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 02.03.2025.
//

import SwiftUI

struct BookScrollView: View {
    
    @State var bookPlacement: BookPlacement
    @State var library: [Book]
    @State var bookToPresent: Book?
    @State private var isBookDetailPresented = false
    
    var body: some View {
        NavigationStack{
            HStack{
                Text(bookPlacement.rawValue)
                    .font(.title3)
                
                Spacer()
                
                NavigationLink{
                    ShowAllBookPlacementView(placement: bookPlacement, library: library)
                } label:
                {
                    Text("Show All")
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(library.filter { $0.placement == bookPlacement }) { book in
                        HStack{
                            Button {
                                bookToPresent = book
                            } label: {
                                HStack{
                                    BookTile(book: book)
                                        .buttonStyle(.plain)
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 5)
                                        .draggable(BookTile(book: book))
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
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
    let placement: BookPlacement = .reading
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
        placement: .reading
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
        placement: .reading
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
        placement: .reading
    )]
    BookScrollView(bookPlacement: placement, library: library)
}
