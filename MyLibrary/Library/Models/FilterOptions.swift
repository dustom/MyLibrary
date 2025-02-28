//
//  FilterOptions.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 28.02.2025.
//

import Foundation

enum FilterOptions: String, CaseIterable, Identifiable {
    case reading = "Reading"
    case toBeRead = "To Be Read"
    case read = "Read"
//    case favorite = "Only Favorite"
    var id: Self { self }
}
