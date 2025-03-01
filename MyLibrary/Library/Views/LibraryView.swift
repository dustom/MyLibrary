//
//  LibraryView.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 28.02.2025.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.modelContext)  var modelContext
    @Query private var myLibrary: [Book] = []
    @State private var isFilterOptionsPresented = false
    @State private var selectedFilter: Set<FilterOptions> = Set(FilterOptions.allCases)
    @State private var isSearchFromWebPresented = false
    @State private var isManualEntryPresented = false
    @State private var isBarcodeScannerPresented = false
    @State private var scannedBarcode = ""
    @State private var isBarcodeFound = false
    
    var body: some View {
        NavigationStack {
            Group{
                List{
                    if selectedFilter.contains(.reading) {
                        Section(header: Text("Reading")) {
                            ForEach(myLibrary.filter { $0.placement == .reading }) { book in
                                NavigationLink(destination: BookDetailView(book: book)) {
                                    BookNavigationLinkView(book: book)
                                }
                            }
                            .onDelete(perform: deleteItems)
                            
//                            Text("Hello, World!")
//                            Text("Hello, World!")
//                            Text("Hello, World!")
                        }
                        
                    }
                    if selectedFilter.contains(.toBeRead) {
                        Section(header: Text("To Be Read")) {
                            ForEach(myLibrary.filter { $0.placement == .toBeRead }) { book in
                                NavigationLink(destination: BookDetailView(book: book)) {
                                    BookNavigationLinkView(book: book)
                                }
                            }
                            .onDelete(perform: deleteItems)
                            
//                            Text("Hello, World!")
//                            Text("Hello, World!")
//                            Text("Hello, World!")
                        }
                    }
                    if selectedFilter.contains(.read) {
                        Section(header: Text("Read")) {
                            ForEach(myLibrary.filter { $0.placement == .read }) { book in
                                NavigationLink(destination: BookDetailView(book: book)) {
                                    BookNavigationLinkView(book: book)
                                }
                            }
                            .onDelete(perform: deleteItems)
//                            Text("Hello, World!")
//                            Text("Hello, World!")
//                            Text("Hello, World!")
                        }
                    }
                }
                
            }
            .navigationTitle("My Library")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Sort and Filter", systemImage: "line.3.horizontal.decrease"){
                        isFilterOptionsPresented = true
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Web Search", systemImage: "globe") {
                            isSearchFromWebPresented = true
                        }
                        Button("Manual Entry", systemImage: "square.and.pencil") {
                            isManualEntryPresented = true
                        }
                        Button("Scan Barcode", systemImage: "barcode.viewfinder") {
                            isBarcodeScannerPresented = true
                        }
                    } label: {
                        Label("Add New Book", systemImage: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isFilterOptionsPresented) {
            FilterOptionsView(selectedOptions: $selectedFilter)
                .presentationDetents([.medium])
        }
        .fullScreenCover(isPresented: $isSearchFromWebPresented) {
                SearchView(barcode: scannedBarcode)
        }
        .fullScreenCover(isPresented: $isBarcodeFound) {
                SearchView(barcode: scannedBarcode)
        }
        .fullScreenCover(isPresented: $isBarcodeScannerPresented) {
            BarcodeScannerView(barcode: $scannedBarcode, isBarcodeFound: $isBarcodeFound)
        }
        .fullScreenCover(isPresented: $isManualEntryPresented) {
            BookFormView()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
            withAnimation {
                for index in offsets {
                    modelContext.delete(myLibrary[index])
                }
            }
        }
    
}

#Preview {
    LibraryView()
}
