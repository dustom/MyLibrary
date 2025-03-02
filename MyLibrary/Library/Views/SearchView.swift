//
//  ContentView.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 28.02.2025.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = LibraryViewModel()
    @State var searchText: String = ""
    @State private var typingLocation: Bool = false
    @State private var searchResult: [Book] = []
    
    var barcode: String?
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.status {
                case .notStarted:
                    ContentUnavailableView("Search Books", systemImage: "magnifyingglass", description: Text("Search books by title, author or ISBN."))
                case .fetching:
                    ProgressView()
                case .success:
                    mainView
                case .failed:
                    ContentUnavailableView("No Books Found", systemImage: "exclamationmark.magnifyingglass", description: Text("There are no books matching your search. Try a different search."))
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                }
            }
        }
        
        .searchable(text: $searchText, isPresented: $typingLocation, prompt: "Search Books" )
        .onSubmit(of: .search) {
            //set typing location to false to go back to the default state of the view without the searchbar selected
            typingLocation = false
            Task{
                await viewModel.getBooksForSearch(search: searchText)
                searchResult = viewModel.books
                searchText = ""
            }
        }
        .onAppear{
            if let barcode = barcode{
                if barcode != ""{
                    Task{
                        await viewModel.getBooksForBarCode(barcode: barcode)
                        searchResult = viewModel.books
                        searchText = ""
                    }
                }
            }
        }
    }
    
    private var mainView: some View {
        List {
            ForEach (searchResult, id:\.self) { book in
                NavigationLink(destination: BookDetailView(book: book)) {
                    BookNavigationLinkView(book: book)
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
