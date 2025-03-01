//
//  BookFormView.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 01.03.2025.
//

import SwiftUI

struct BookFormView: View {
    var book: Book?
    @Environment(\.modelContext)  var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var pages: String = ""
    @State private var isbn: String = ""
    @State private var description: String = ""
    @State private var publisher: String = ""
    @State private var publishedDate: Date = Date()
    @State private var categories: String = ""
    @State private var coverImageURL: URL? = nil

    var body: some View {
        NavigationStack {
            Form {
                // Title
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }

                // Author
                Section(header: Text("Author")) {
                    TextField("Enter author (comma-separated)", text: $author)
                }

                // Pages
                Section(header: Text("Pages")) {
                    TextField("Enter number of pages", text: $pages)
                        .keyboardType(.numberPad)
                }

                // ISBN
                Section(header: Text("ISBN")) {
                    TextField("Enter ISBN", text: $isbn)
                        .keyboardType(.numberPad)
                }

                // Description
                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                }

                // Publisher
                Section(header: Text("Publisher")) {
                    TextField("Enter publisher", text: $publisher)
                }

                // Published Date
                Section(header: Text("Published Date")) {
                    DatePicker("Select date", selection: $publishedDate, displayedComponents: .date)
                }

                // Categories
                Section(header: Text("Categories")) {
                    TextField("Enter categories (comma-separated)", text: $categories)
                }

                // Cover Image URL (Display Only)
                if let coverImageURL = coverImageURL {
                    Section(header: Text("Cover Image URL")) {
                        Text(coverImageURL.absoluteString)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Add Book")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Reading") {
                            saveBook(to: .reading)
                            dismiss()
                        }
                        Button("To Be Read") {
                            saveBook(to: .toBeRead)
                            dismiss()
                        }
                        Button("Read") {
                            saveBook(to: .read)
                            dismiss()
                        }
                    } label: {
                        Text("Add")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear(){
            if let book {
                title = book.title
                author = book.author?.joined(separator: ",") ?? ""
                pages = String(book.pages ?? 0)
                isbn = book.isbn ?? ""
                description = book.bookDescription ?? ""
                publisher = book.publisher ?? ""
                categories = book.categories?.joined(separator: ",") ?? ""
                coverImageURL = book.coverImageURL
            }
        }
    }

    private func saveBook(to category: BookPlacement) {
        // Convert input strings to appropriate types
        let authors = author.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let pageCount = Int(pages)
        let categoryList = categories.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        // Create a new Book object
        let newBook = Book(
            title: title,
            author: authors.isEmpty ? nil : authors,
            pages: pageCount,
            coverImageURL: coverImageURL,
            isbn: isbn.isEmpty ? nil : isbn,
            description: description.isEmpty ? nil : description,
            publisher: publisher.isEmpty ? nil : publisher,
            publishedDate: publishedDate,
            categories: categoryList.isEmpty ? nil : categoryList,
            placement: category
        )
        modelContext.insert(newBook)
        saveContext()
        // Print the book (for demonstration)
        print("Saved Book: \(newBook)")
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

struct BookFormView_Previews: PreviewProvider {
    static var previews: some View {
        BookFormView()
    }
}
