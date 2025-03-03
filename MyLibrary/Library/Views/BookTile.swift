//
//  SwiftUIView.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 02.03.2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct BookTile: View, Transferable, Codable, Hashable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .bookTile)
    }
    
    var book: Book
    var body: some View {
        
        VStack{
            AsyncImage(url: book.coverImageURL) { image in
                ZStack{
                    image
                        .resizable()
                        .scaledToFill()
                }
                
                
            } placeholder: {
                HStack {
                    if book.coverImageURL != nil {
                        ProgressView()
                        
                    } else {
                        VStack{
                            
                                Image(systemName: "text.book.closed")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                                    .padding()
                          
                                Text(book.title)
                                    .padding(4)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.85)
                            
                        }
                    }
                }
            }
        }
        .frame(width: 150, height: 225)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .shadow(radius: 5, x: 2.5, y: 2.5)
        
        
    }
}

#Preview {
    let sampleBook = Book(
        title: "The Hobbit and an unreasonably long name",
        author: ["J.R.R. Tolkien"],
        pages: 310,
//        coverImageURL: URL(string: "https://books.google.com/books/content?id=CixXEAAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
        isbn: "9780547928227",
        description: "A classic fantasy novel about Bilbo Baggins and his adventure to reclaim the Lonely Mountain.",
        publisher: "Houghton Mifflin Harcourt",
        publishedDate: Date(),
        categories: ["Fantasy", "Adventure"],
        lastChange: Date()
    )
    BookTile(book: sampleBook)
}

extension UTType {
    static let bookTile = UTType(exportedAs: "com.tomdus.bookTile")
}
