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
//                ForEach(BookPlacement.allCases) {category in
//                    BookScrollView(bookPlacement: category, library: myLibrary)
//                    Divider()
//                }
                
                BookScrollView(bookPlacement: .reading, library: myLibrary)
                    .padding(.bottom)
                    .dropDestination(for: BookTile.self) { droppedBook, location in
                        for book in droppedBook {
                            book.book.placement = .reading
                            print(book.book.title)
                            print("dropnul jsem na reading")
                            modelContext.delete(book.book)
                            modelContext.insert(book.book)
                        }
                        return true
                    }
                
                
                BookScrollView(bookPlacement: .toBeRead, library: myLibrary)
                    .padding(.bottom)
                    .dropDestination(for: BookTile.self) { droppedBook, location in
                        for book in droppedBook {
                            book.book.placement = .toBeRead
                            print(book.book.title)
                            print("dropnul jsem na to be read")
                            modelContext.delete(book.book)
                            modelContext.insert(book.book)
                        }
                        return true
                    }
                
                BookScrollView(bookPlacement: .read, library: myLibrary)
                    .padding(.bottom)
                    .dropDestination(for: BookTile.self) { droppedBook, location in
                        for book in droppedBook {
                            book.book.placement = .read
                            print(book.book.title)
                            print("dropnul jsem na read")
                            modelContext.delete(book.book)
                            modelContext.insert(book.book)
                        }
                        return true
                    }
                
                
            }
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
                                
                        }
                        .background(.white)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                            
                        .shadow(color: .gray, radius: 5, x: 2.5, y: 2.5)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(40)
            }
        })
    }
}

#Preview {
    LibraryView()
}
