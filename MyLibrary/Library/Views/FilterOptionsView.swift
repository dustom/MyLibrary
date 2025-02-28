//
//  FilterOptionsView.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 28.02.2025.
//

import SwiftUI

struct FilterOptionsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedOptions: Set<FilterOptions>
    private var selectAllOptions: Bool {
        selectedOptions == Set(FilterOptions.allCases)
    }
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Text("All")
                    Spacer()
                    Image(systemName: selectAllOptions ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(selectAllOptions ? .blue : .gray)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectAllOptions {
                        selectedOptions = []
                    } else {
                        selectedOptions = Set(FilterOptions.allCases)
                    }
                }
                
                ForEach(FilterOptions.allCases) { option in
                        HStack{
                            Text(option.rawValue)
                            Spacer()
                            Image(systemName: selectedOptions.contains(option) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedOptions.contains(option) ? .blue : .gray)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                if selectedOptions.contains(option) {
                                    selectedOptions.remove(option)
                                } else {
                                    selectedOptions.insert(option)
                                }
                            }
                        }
                    }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Dismiss", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Filter Options")
        }
    }
}

#Preview {
    @Previewable @State var selectedOptions: Set<FilterOptions> = Set(FilterOptions.allCases)
    FilterOptionsView(selectedOptions: $selectedOptions)
}
