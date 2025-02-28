//
//  FetchBooks.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 28.02.2025.
//

import Foundation
class FetchBooks {
    private enum FetchError: Error {
        case badResponse
        case invalidURL
    }
    
    
    func fetchBooks(for search: String) async throws -> BookSearch  {
        
        let baseURL = URL(string: "https://openlibrary.org/search.json?")!
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "title", value: search)
        ]
        
        guard let fetchURL = components.url else {
            throw FetchError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let decoder = JSONDecoder()
        let book = try decoder.decode(BookSearch.self, from: data)
        
        return book
    }
}

