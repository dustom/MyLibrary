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
    @Published var books: BookSearch
    @Published var status: FetchStatus = .notStarted
    
    init() {
        let decoder = JSONDecoder()
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "search", withExtension: "json")!)
        books = try! decoder.decode(BookSearch.self, from: data)
    }
    
    func coverURL(for bookCode: Double) -> URL{
        let id = Int(bookCode)
        let url = URL(string: "https://covers.openlibrary.org/b/id/" + String(id) + "-M.jpg")!
        return url
    }
    
    func getBooks(for search: String) async {
        status = .fetching
        
        do {
            books = try await fetcher.fetchBooks(for: search)
            status = .success
        } catch {
            status = .failed(error: error)
        }
    }
}
