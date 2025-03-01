//
//  ContentViewModel.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 28.02.2025.
//

import Foundation

@MainActor
class LibraryViewModel: ObservableObject {
    
    enum FetchStatus {
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }
    
    private let fetcher = FetchBooks()
    @Published var books: [Book] = []
    @Published var bookSearch: BookSearch
    @Published var status: FetchStatus = .notStarted
    
    init() {
        let decoder = JSONDecoder()
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "search", withExtension: "json")!)
        bookSearch = try! decoder.decode(BookSearch.self, from: data)
    }
    
    private func convertBookSearchToBooks(from bookSearch: BookSearch) {
        books = []
        for item in bookSearch.items {
            let httpsURL = item.volumeInfo.imageLinks?.thumbnail.replacingOccurrences(of: "http://", with: "https://") as String?
            let convertedBook = Book(
                title: item.volumeInfo.title,
                author: item.volumeInfo.authors,
                pages: item.volumeInfo.pageCount,
                coverImageURL: URL(string: httpsURL ?? ""),
                isbn: item.volumeInfo.industryIdentifiers?.first?.identifier,
                description: item.volumeInfo.description,
                publisher: item.volumeInfo.publisher,
                publishedDate: DateFormatter().date(from: item.volumeInfo.publishedDate ?? ""))
            self.books.append(convertedBook)
        }
        print(books)
    }
    
    func getBooksForSearch(search: String) async {
        status = .fetching
        
        do {
            bookSearch = try await fetcher.fetchBooks(for: search, barcode: false)
            convertBookSearchToBooks(from: bookSearch)
            status = .success
        } catch {
            status = .failed(error: error)
        }
    }
    
    func getBooksForBarCode(barcode: String) async {
        status = .fetching
        
        do {
            bookSearch = try await fetcher.fetchBooks(for: barcode, barcode: true)
            convertBookSearchToBooks(from: bookSearch)
            status = .success
        } catch {
            status = .failed(error: error)
        }
    }
}
