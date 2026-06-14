//
//  ContentView.swift
//  BakeryApp
//
//  Created by Cormac Young on 2026-06-13.
//

import SwiftUI

struct BakeryItem: Identifiable {
    let id = UUID()
    let merchandisingCategory: String
    let name: String
    let shelfLife: String
}

struct ContentView: View {
    @State private var searchText = ""

    private let bakeryItems = [
        BakeryItem(merchandisingCategory: "Bagel", name: "Farm Boy Bagels (7 pk)", shelfLife: "6 days"),
        BakeryItem(merchandisingCategory: "Bread Wall", name: "Farm Boy Homestyle Garlic Bread", shelfLife: "5 days"),
        BakeryItem(merchandisingCategory: "Bread Wall", name: "Farm Boy Simply Five Focaccia & Breads", shelfLife: "5 days"),
        BakeryItem(merchandisingCategory: "Cookie", name: "Farm Boy Crispy Cookies 12’s", shelfLife: "21 days"),
        BakeryItem(merchandisingCategory: "Cookie", name: "Farm Boy Vegan Crispy Cookies", shelfLife: "10 days"),
        BakeryItem(merchandisingCategory: "Dietary", name: "Allergy Smart Brownie Cakes & Brownies", shelfLife: "14 days"),
        BakeryItem(merchandisingCategory: "Dietary", name: "Farm Boy Vegan Cupcakes / Muffins", shelfLife: "7 days"),
        BakeryItem(merchandisingCategory: "Dietary", name: "Queen St. Bakery Breads / Buns / Muffins", shelfLife: "12 days"),
        BakeryItem(merchandisingCategory: "Dietary", name: "School Safe Bars, Cakes, Loaves", shelfLife: "21 days"),
        BakeryItem(merchandisingCategory: "Dietary", name: "Strawberry Blonde Cakes (floor)", shelfLife: "7 days"),
        BakeryItem(merchandisingCategory: "Dietary", name: "Strawberry Blonde Cookies (floor)", shelfLife: "7 days"),
        BakeryItem(merchandisingCategory: "Frozen", name: "Chudleigh’s Frozen “No Date”", shelfLife: "Frozen"),
        BakeryItem(merchandisingCategory: "Muffin", name: "Cravingly Good Mini Muffins", shelfLife: "10 days"),
        BakeryItem(merchandisingCategory: "Muffin", name: "Jumbo Muffins (4 pk)", shelfLife: "10 days"),
        BakeryItem(merchandisingCategory: "Muffin", name: "Mini Muffins", shelfLife: "10 days"),
        BakeryItem(merchandisingCategory: "Cakes", name: "Angel & Mini Angel Cakes", shelfLife: "10 days"),
        BakeryItem(merchandisingCategory: "Pie", name: "8\" No Sugar Added", shelfLife: "6 days"),
        BakeryItem(merchandisingCategory: "Pie", name: "Bakerberry’s Pie Ontario Apple", shelfLife: "5 days"),
        BakeryItem(merchandisingCategory: "Pie", name: "Farm Boy 8\" Pies", shelfLife: "6 days"),
        BakeryItem(merchandisingCategory: "PL Thaw and Serve", name: "Farm Boy Swiss Rolls", shelfLife: "21 days"),
        BakeryItem(merchandisingCategory: "PL Thaw and Serve", name: "Farm Boy Butter Tarts", shelfLife: "14 days"),
        BakeryItem(merchandisingCategory: "PL Thaw and Serve", name: "Farm Boy Coffee Cakes", shelfLife: "10 days"),
        BakeryItem(merchandisingCategory: "PL Thaw and Serve", name: "Farm Boy Donuts", shelfLife: "7 days"),
        BakeryItem(merchandisingCategory: "PL Thaw and Serve", name: "Farm Boy Florentine Cookies", shelfLife: "21 days"),
        BakeryItem(merchandisingCategory: "Promise", name: "Promise Gluten Free Pitas, Loaves, Tortillas", shelfLife: "19 days"),
        BakeryItem(merchandisingCategory: "Promise", name: "Promise Gluten Free Baguettes 180 g (2 × 90 g)", shelfLife: "16 days"),
        BakeryItem(merchandisingCategory: "Promise", name: "Promise Gluten Free (all other products)", shelfLife: "19 days"),
        BakeryItem(merchandisingCategory: "Sweets", name: "Farm Boy Plant-Based Strudels (6 pk)", shelfLife: "5 days"),
        BakeryItem(merchandisingCategory: "Sweets", name: "Farm Boy Scones (4 pk)", shelfLife: "4 days"),
        BakeryItem(merchandisingCategory: "Sweets", name: "Sticky Toffee", shelfLife: "5 days"),
        BakeryItem(merchandisingCategory: "Pie", name: "Small Pie", shelfLife: "6 days"),
        BakeryItem(merchandisingCategory: "Pie", name: "Big Pie", shelfLife: "7 days"),
        BakeryItem(merchandisingCategory: "Pie", name: "Lemon Meringue", shelfLife: "7 days"),
        BakeryItem(merchandisingCategory: "Dietary", name: "Gluten Free Tarts", shelfLife: "14 days"),
        BakeryItem(merchandisingCategory: "Cakes", name: "Loaf Cakes", shelfLife: "14 days"),
        BakeryItem(merchandisingCategory: "Dietary", name: "Tortillas", shelfLife: "61 days"),
        BakeryItem(merchandisingCategory: "Cakes", name: "Cakes", shelfLife: "5 days"),
        BakeryItem(merchandisingCategory: "Cakes", name: "Top Shelf", shelfLife: "7 days"),
        BakeryItem(merchandisingCategory: "Cakes", name: "Bar Cake", shelfLife: "10 days"),
        BakeryItem(merchandisingCategory: "Cakes", name: "Slab Cake", shelfLife: "10 days")
    ]

    private var filteredItems: [BakeryItem] {
        guard !searchText.isEmpty else {
            return bakeryItems
        }

        return bakeryItems.filter { item in
            item.name.localizedCaseInsensitiveContains(searchText)
                || item.merchandisingCategory.localizedCaseInsensitiveContains(searchText)
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
        .searchable(text: $searchText, prompt: "Search products or categories")
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
            Image(systemName: "birthday.cake")
                .font(.title2)
                .foregroundStyle(.brown)
                .frame(width: 44, height: 44)
                .background(.brown.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))

            Text(item.name)
                .font(.headline)

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text("Shelf life")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(item.shelfLife)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.brown)
            }
            .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ContentView()
}
