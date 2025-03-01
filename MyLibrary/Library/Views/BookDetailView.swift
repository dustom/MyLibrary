//
//  BookDetailView.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 01.03.2025.
//

import SwiftUI

struct BookDetailView: View {
    var book: Book
    @State private var isFormViewPresented = false

    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                 
                    if let coverImageURL = book.coverImageURL {
                        AsyncImage(url: coverImageURL) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 200, maxHeight: 200)
                                    .cornerRadius(8)
                            } else if phase.error != nil {
                                Image(systemName: "questionmark")
                                    .bold()
                                    .frame(maxWidth: 200, maxHeight: 200)
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
        
                    Text(book.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
          
                    if let authors = book.author, !authors.isEmpty {
                        Text("By \(authors.joined(separator: ", "))")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    Divider()
                    
           
                    Group {
                        if let isbn = book.isbn {
                            DetailRow(label: "ISBN", value: isbn)
                        }
                        
                        if let publisher = book.publisher {
                            DetailRow(label: "Publisher", value: publisher)
                        }
                        
                        if let publishedDate = book.publishedDate {
                            DetailRow(label: "Published", value: formattedDate(publishedDate))
                        }
                        
                        if let pages = book.pages {
                            DetailRow(label: "Pages", value: "\(pages)")
                        }
                        
                        if let categories = book.categories, !categories.isEmpty {
                            DetailRow(label: "Categories", value: categories.joined(separator: ", "))
                        }
                    }
                    
                    Divider()
                    
            
                    if let description = book.bookDescription {
                        Text("Description")
                            .font(.headline)
                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("Book Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add"){
                        isFormViewPresented = true
                    }
                }
            }
            .fullScreenCover(isPresented: $isFormViewPresented) {
                BookFormView(book: book)
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

struct DetailRow: View {
    var label: String
    var value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .frame(width: 100, alignment: .leading)
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleBook = Book(
            title: "The Hobbit",
            author: ["J.R.R. Tolkien"],
            pages: 310,
            coverImageURL: URL(string: "https://books.google.com/books/content?id=CixXEAAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
            isbn: "9780547928227",
            description: "A classic fantasy novel about Bilbo Baggins and his adventure to reclaim the Lonely Mountain.",
            publisher: "Houghton Mifflin Harcourt",
            publishedDate: Date(),
            categories: ["Fantasy", "Adventure"]
        )

        BookDetailView(book: sampleBook)
    }
}
