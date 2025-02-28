//
//  ContentView.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 28.02.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var searchText: String = ""
    @State private var typingLocation: Bool = false
    @State private var searchResult: [BookSearch.Book] = []
    
    var body: some View {
        NavigationStack {
            List {
                if searchResult != [] {
                    ForEach (searchResult, id:\.self) { book in
                        HStack {
                            AsyncImage(url: viewModel.coverURL(for: book.cover ?? 0)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                            } placeholder: {
                                if book.cover != nil {
                                    ProgressView()
                                } else {
                                    Image(systemName: "questionmark.circle.dashed")
                                        .font(.title)
                                        .frame(width: 120, height: 120)
                                }
                                
                            }
                            Text(book.title)
                                .font(.headline)
                            Spacer()
                            Text(book.authorName?.first! ?? "No author")
                        }
                    }
                }
            }
            .searchable(text: $searchText, isPresented: $typingLocation, prompt: "Search Books" )
            .onSubmit(of: .search) {
                //set typing location to false to go back to the default state of the view without the searchbar selected
                typingLocation = false
                Task{
                    await viewModel.getBooks(for: searchText)
                    searchResult = viewModel.books.docs
                    searchText = ""
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
