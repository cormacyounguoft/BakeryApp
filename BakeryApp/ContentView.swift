//
//  ContentView.swift
//  BakeryApp
//
//  Created by Cormac Young on 2026-06-13.
//

import SwiftUI

struct BakeryItem: Identifiable {
    let id = UUID()
    let name: String
    let shelfLife: String
    let symbol: String
}

struct ContentView: View {
    @State private var searchText = ""

    private let bakeryItems = [
        BakeryItem(
            name: "Sourdough Loaf",
            shelfLife: "3-5 days",
            symbol: "birthday.cake"
        ),
        BakeryItem(
            name: "Butter Croissant",
            shelfLife: "1-2 days",
            symbol: "takeoutbag.and.cup.and.straw"
        ),
        BakeryItem(
            name: "Blueberry Muffin",
            shelfLife: "2-3 days",
            symbol: "cup.and.saucer"
        ),
        BakeryItem(
            name: "Chocolate Cake",
            shelfLife: "3-4 days",
            symbol: "birthday.cake.fill"
        ),
        BakeryItem(
            name: "Cinnamon Roll",
            shelfLife: "2 days",
            symbol: "circle.hexagongrid.fill"
        ),
        BakeryItem(
            name: "Baguette",
            shelfLife: "1-2 days",
            symbol: "leaf.fill"
        ),
        BakeryItem(
            name: "Cheesecake",
            shelfLife: "5-7 days",
            symbol: "birthday.cake.fill"
        ),
        BakeryItem(
            name: "Chocolate Chip Cookie",
            shelfLife: "5-7 days",
            symbol: "circle.grid.cross.fill"
        )
    ]

    private var filteredItems: [BakeryItem] {
        guard !searchText.isEmpty else {
            return bakeryItems
        }

        return bakeryItems.filter { item in
            item.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        TabView {
            Tab("Items", systemImage: "birthday.cake") {
                NavigationStack {
                    BakeryItemList(items: bakeryItems)
                        .navigationTitle("Bakery Shelf Life")
                }
            }

            Tab(role: .search) {
                NavigationStack {
                    BakeryItemList(items: filteredItems, searchText: searchText)
                        .navigationTitle("Search")
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search bakery items")
        .tabViewSearchActivation(.searchTabSelection)
    }
}

private struct BakeryItemList: View {
    let items: [BakeryItem]
    var searchText = ""

    var body: some View {
        if items.isEmpty {
            ContentUnavailableView.search(text: searchText)
        } else {
            List(items) { item in
                BakeryItemRow(item: item)
            }
            .listStyle(.insetGrouped)
        }
    }
}

private struct BakeryItemRow: View {
    let item: BakeryItem

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: item.symbol)
                .font(.title2)
                .foregroundStyle(.brown)
                .frame(width: 44, height: 44)
                .background(.brown.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 5) {
                Text(item.name)
                    .font(.headline)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text("Shelf life")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(item.shelfLife)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.brown)
            }
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ContentView()
}
