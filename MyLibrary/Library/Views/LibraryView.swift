//
//  LibraryView.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 28.02.2025.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var myLibrary: [Book] = []
    
    //    @State private var myLibrary: [Book] = [
    //                                         Book(
    //                                             title: "The Great Gatsby",
    //                                             author: ["F. Scott Fitzgerald"],
    //                                             pages: 180,
    //                                             coverImageURL: URL(string: "https://books.google.com/books/content?id=CixXEAAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
    //                                             isbn: "9780743273565",
    //                                             description: "A story of the fabulously wealthy Jay Gatsby and his love for the beautiful Daisy Buchanan.",
    //                                             publisher: "Scribner",
    //                                             publishedDate: DateFormatter().date(from: "1925-04-10"),
    //                                             categories: ["Fiction", "Classic"],
    //                                             placement: .read
    //                                         ),
    //                                         Book(
    //                                             title: "1984",
    //                                             author: ["George Orwell"],
    //                                             pages: 328,
    //                                             coverImageURL: URL(string: "https://books.google.com/books/content?id=CixXEAAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
    //                                             isbn: "9780451524935",
    //                                             description: "A dystopian novel set in a totalitarian society ruled by the Party and its leader, Big Brother.",
    //                                             publisher: "Secker & Warburg",
    //                                             publishedDate: DateFormatter().date(from: "1949-06-08"),
    //                                             categories: ["Fiction", "Dystopian"],
    //                                             placement: .toBeRead
    //                                         ),
    //                                         Book(
    //                                             title: "To Kill a Mockingbird",
    //                                             author: ["Harper Lee"],
    //                                             pages: 281,
    //                                            coverImageURL: URL(string: "https://books.google.com/books/content?id=CixXEAAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
    //                                             isbn: "9780446310789",
    //                                             description: "A novel about the serious issues of rape and racial inequality, told through the eyes of a young girl.",
    //                                             publisher: "J.B. Lippincott & Co.",
    //                                             publishedDate: DateFormatter().date(from: "1960-07-11"),
    //                                             categories: ["Fiction", "Classic"],
    //                                             placement: .read
    //                                         )
    //                                     ]
    
    @State private var isSearchFromWebPresented = false
    @State private var isManualEntryPresented = false
    @State private var isBarcodeScannerPresented = false
    @State private var isBookDetailPresented = false
    @State private var scannedBarcode = ""
    @State private var isBarcodeFound = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(BookPlacement.allCases) {category in
                    BookScrollView(bookPlacement: category)
                        .padding(.bottom)
                        .dropDestination(for: BookTile.self) { droppedTile, location in
                            for tile in droppedTile {
                                let droppedBook = tile.book
                                print("\(droppedBook.title) was in category \(droppedBook.placement!)")
                                droppedBook.placement = category
                                droppedBook.lastChange = Date()
                                print("\(droppedBook.title) was last changed at \(droppedBook.lastChange)")
                                print("\(droppedBook.title) is now in category \(droppedBook.placement!)")
                                modelContext.insert(droppedBook)
                                saveContext()
                            }
                            return true
                        }
                }
                
            }
            .scrollIndicators(.hidden)
            
            .navigationTitle("My Library")
            
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
        
        .overlay(content: {
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    
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
                        HStack{
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .foregroundStyle(.primary)
                            
                            
                        }
                        
                        .background(.ultraThickMaterial)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        
                        .shadow(color: .black, radius: 5, x: 2.5, y: 2.5)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(40)
            }
        })
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
}

#Preview {
    LibraryView()
}
