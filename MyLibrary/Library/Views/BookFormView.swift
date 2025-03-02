//
//  BookFormView.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 01.03.2025.
//

import SwiftUI

struct BookFormView: View {
    var book: Book?
    var isEditable: Bool?
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
    @State private var bookPlacement: BookPlacement = .toBeRead

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }

                Section(header: Text("Author")) {
                    TextField("Enter author", text: $author)
                }
                
                Section(header: Text("Pages")) {
                    TextField("Enter number of pages", text: $pages)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("ISBN")) {
                    TextField("Enter ISBN", text: $isbn)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                }

                Section(header: Text("Publisher")) {
                    TextField("Enter publisher", text: $publisher)
                }

                Section(header: Text("Published Date")) {
                    DatePicker("Select date", selection: $publishedDate, displayedComponents: .date)
                }

                Section(header: Text("Categories")) {
                    TextField("Enter categories", text: $categories)
                }
            }
            .navigationTitle("Book Details")
            .toolbar {
                
                if let editable = isEditable {
                    if editable {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel") {
                                dismiss()
                            }
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Save") {
                                saveChanges()
                                dismiss()
                            }
                        }
                    }
                } else {
                    
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
        }
        .onAppear(){
            if let book {
                title = book.title
                author = book.author?.joined(separator: ", ") ?? ""
                pages = String(book.pages ?? 0)
                isbn = book.isbn ?? ""
                description = book.bookDescription ?? ""
                publisher = book.publisher ?? ""
                categories = book.categories?.joined(separator: ", ") ?? ""
                bookPlacement = book.placement ?? .toBeRead
                coverImageURL = book.coverImageURL
            }
        }
    }
    
    private func saveChanges() {
        book?.title = title
        book?.author = [author]
        book?.pages = Int(pages)
        book?.coverImageURL = coverImageURL
        book?.isbn = isbn
        book?.bookDescription = description
        book?.publisher = publisher
        book?.publishedDate = publishedDate
        book?.categories = [categories]
        saveContext()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    }
        

    private func saveBook(to category: BookPlacement) {
        let authors = author.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let pageCount = Int(pages)
        let categoryList = categories.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }

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
