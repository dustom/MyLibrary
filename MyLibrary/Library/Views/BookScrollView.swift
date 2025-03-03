//
//  BookScrollView.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 02.03.2025.
//

import SwiftUI
import SwiftData

struct BookScrollView: View {
    
    var bookPlacement: BookPlacement
    @Query var libraryQuery: [Book] = []
    @State var bookToPresent: Book?
    @State private var isBookDetailPresented = false
    
    var body: some View {
        NavigationStack{
            HStack{
                Text(bookPlacement.rawValue)
                    .font(.title3)
                
                Spacer()
                
                NavigationLink{
                    ShowAllBookPlacementView(placement: bookPlacement, library: libraryQuery)
                } label:
                {
                    Text("Show All")
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    let sortedLibrary = libraryQuery.sorted { $0.lastChange > $1.lastChange }
                    ForEach(sortedLibrary.filter { $0.placement == bookPlacement}) { book in
                        Button {
                            bookToPresent = book
                        } label: {
                            BookTile(book: book)
                                .buttonStyle(.plain)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 5)
                                .draggable(BookTile(book: book))
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                }
                
                .padding(.horizontal)
            }
        }
        .fullScreenCover(item: $bookToPresent) { book in
            BookDetailView(book: book, isEditable: true)
        }
        
    }
}

#Preview {
    let placement: BookPlacement = .reading
    BookScrollView(bookPlacement: placement)
}
