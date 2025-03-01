//
//  BookNavigationLinkView.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 01.03.2025.
//

import SwiftUI

struct BookNavigationLinkView: View {
    let book: Book
    
    var body: some View {
        HStack {
            AsyncImage(url: book.coverImageURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 80)
            } placeholder: {
                HStack {
                    if book.coverImageURL != nil {
                        ProgressView()
                           
                    } else {
                        Image(systemName: "questionmark")
                    }
                }
                .frame(maxWidth: 80)
            }
            VStack(alignment: .leading){
                Text(book.title)
                    .padding(.bottom, 5)
                    
                Text("Written By:")
                    .font(.subheadline)
                    .bold()
                Text((book.author?.joined(separator: ", ") ?? "Author unknown"))
                    .font(.subheadline)
                Spacer()
            }
            .padding(3)
            .multilineTextAlignment(.leading)
            .lineLimit(3)
            .minimumScaleFactor(0.85)
        }
        .frame(maxHeight: 100)
    }
}

#Preview {
    BookNavigationLinkView(book: Book(title: "Inheritance and an unrueasonably long title to test if it wraps as it should or not. Lorem Ipsum is simply dummy text of the printing and typesetting industry.", author: ["Christopher Paolini, Christopher Paolini, Christopher Paolini, Christopher Paolini,"], coverImageURL: URL(string: "https://books.google.com/books/content?id=qxsdAgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api")))
}
