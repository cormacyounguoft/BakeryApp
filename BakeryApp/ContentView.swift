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

            Tab("Buns", systemImage: "takeoutbag.and.cup.and.straw") {
                NavigationStack {
                    BunCountView()
                }
            }

            Tab("Thaw", systemImage: "snowflake") {
                NavigationStack {
                    ThawCountView()
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

private struct BunProduct: Identifiable {
    let id: String
    let name: String
    let targetQuantity: Int
    var targetDescription: String?
}

private struct BunCountView: View {
    private let products = [
        BunProduct(id: "portuguese-buns", name: "Portuguese Buns", targetQuantity: 10, targetDescription: "1 box (10 in a box)"),
        BunProduct(id: "rustic-italian", name: "Rustic Italian", targetQuantity: 12, targetDescription: "1 box (12 in a box)"),
        BunProduct(id: "portuguese-sweet", name: "Portuguese Sweet", targetQuantity: 15, targetDescription: "1 box (15 in a box)"),
        BunProduct(id: "croissant-bun", name: "Croissant Bun", targetQuantity: 5),
        BunProduct(id: "pretzel-bun", name: "Pretzel Bun", targetQuantity: 4),
        BunProduct(id: "pretzel-twists", name: "Pretzel Twists", targetQuantity: 5),
        BunProduct(id: "cheese-bun", name: "Cheese Bun", targetQuantity: 4),
        BunProduct(id: "cheese-sticks", name: "Cheese Sticks", targetQuantity: 10),
        BunProduct(id: "everything-bagels", name: "Everything Bagels", targetQuantity: 8),
        BunProduct(id: "plain-bagels", name: "Plain Bagels", targetQuantity: 6),
        BunProduct(id: "sesame-bagels", name: "Sesame Bagels", targetQuantity: 6),
        BunProduct(id: "cheese-bagels", name: "Cheese Bagels", targetQuantity: 4),
        BunProduct(id: "jalapeno-bagels", name: "Jalapeno Bagels", targetQuantity: 4),
        BunProduct(id: "cinnamon-bagels", name: "Cinnamon Bagels", targetQuantity: 4)
    ]

    @State private var currentIndex = 0
    @State private var counts: [String: Int] = [:]
    @State private var isShowingList = false

    private var bunProducts: [BunProduct] {
        Array(products.prefix(8))
    }

    private var bagelProducts: [BunProduct] {
        Array(products.dropFirst(8))
    }

    private var totalSteps: Int {
        bunProducts.count + 1
    }

    private var isBagelStep: Bool {
        currentIndex == bunProducts.count
    }

    private func countBinding(for product: BunProduct) -> Binding<Int> {
        Binding(
            get: { counts[product.id, default: 0] },
            set: { counts[product.id] = $0 }
        )
    }

    var body: some View {
        Group {
            if isShowingList {
                bunList
            } else {
                countEntry
            }
        }
        .navigationTitle(isShowingList ? "Buns List" : "Buns")
    }

    private var countEntry: some View {
        VStack(spacing: 16) {
            ProgressView(value: Double(currentIndex + 1), total: Double(totalSteps))

            Text("Step \(currentIndex + 1) of \(totalSteps)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if isBagelStep {
                bagelEntry
            } else {
                bunEntry(for: bunProducts[currentIndex])
            }

            HStack {
                Button("Back") {
                    currentIndex -= 1
                }
                .disabled(currentIndex == 0)

                Spacer()

                Button(isBagelStep ? "Show Buns List" : "Next") {
                    if isBagelStep {
                        isShowingList = true
                    } else {
                        currentIndex += 1
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.brown)
            }
        }
        .padding()
    }

    private func bunEntry(for product: BunProduct) -> some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "takeoutbag.and.cup.and.straw")
                .font(.system(size: 48))
                .foregroundStyle(.brown)

            Text(product.name)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)

            VStack(spacing: 4) {
                Text("Target: \(product.targetQuantity)")
                    .font(.headline)

                if let targetDescription = product.targetDescription {
                    Text(targetDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            countStepper(for: product)

            Spacer()
        }
    }

    private var bagelEntry: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Bagels")
                    .font(.largeTitle.bold())

                Text("Enter the count for each bagel variety.")
                    .foregroundStyle(.secondary)

                ForEach(bagelProducts) { product in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(product.name)
                                .font(.headline)
                            Spacer()
                            Text("Target: \(product.targetQuantity)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        countStepper(for: product)
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }

    private func countStepper(for product: BunProduct) -> some View {
        let count = countBinding(for: product)

        return Stepper(value: count, in: 0...999) {
            HStack {
                Text("Count")
                Spacer()
                Text("\(count.wrappedValue)")
                    .font(.title2.monospacedDigit().bold())
                    .foregroundStyle(.brown)
            }
        }
        .padding()
        .background(.brown.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
    }

    private var bunList: some View {
        List {
            Section("Amount Needed") {
                ForEach(products) { product in
                    let enteredCount = counts[product.id, default: 0]
                    let amountNeeded = max(product.targetQuantity - enteredCount, 0)

                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(product.name)
                                .font(.headline)
                            Text("\(product.targetQuantity) target - \(enteredCount) counted")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text("\(amountNeeded)")
                            .font(.title3.monospacedDigit().bold())
                            .foregroundStyle(.brown)
                    }
                    .padding(.vertical, 3)
                }
            }
        }
        .listStyle(.insetGrouped)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Edit Counts") {
                    isShowingList = false
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Reset", role: .destructive) {
                    counts.removeAll()
                    currentIndex = 0
                    isShowingList = false
                }
            }
        }
    }
}

private enum ThawDayType: String, CaseIterable, Identifiable {
    case weekday = "Weekday"
    case weekend = "Weekend"

    var id: Self { self }
}

private struct ThawProduct: Identifiable {
    let id: String
    let name: String
    let weekdayTarget: Int
    let weekendTarget: Int
    var targetDescription: String?
    var packDivisor: Int?

    func target(for dayType: ThawDayType) -> Int {
        dayType == .weekday ? weekdayTarget : weekendTarget
    }
}

private struct ThawGroup: Identifiable {
    let id: String
    let name: String
    let products: [ThawProduct]
}

private struct ThawCountView: View {
    private let groups = [
        ThawGroup(id: "bagels", name: "Bagels", products: [
            ThawProduct(id: "thaw-asiago-bagels", name: "Asiago", weekdayTarget: 12, weekendTarget: 12, targetDescription: "1 box (12)"),
            ThawProduct(id: "thaw-everything-bagels", name: "Everything", weekdayTarget: 12, weekendTarget: 12, targetDescription: "1 box (12)"),
            ThawProduct(id: "thaw-plain-bagels", name: "Plain", weekdayTarget: 8, weekendTarget: 8),
            ThawProduct(id: "thaw-sesame-bagels", name: "Sesame", weekdayTarget: 8, weekendTarget: 8),
            ThawProduct(id: "thaw-multigrain-bagels", name: "Multigrain", weekdayTarget: 6, weekendTarget: 6),
            ThawProduct(id: "thaw-whole-wheat-bagels", name: "Whole Wheat", weekdayTarget: 6, weekendTarget: 6),
            ThawProduct(id: "thaw-cinnamon-bagels", name: "Cinnamon", weekdayTarget: 4, weekendTarget: 4)
        ]),
        ThawGroup(id: "new-buns", name: "New Buns", products: [
            ThawProduct(id: "golden-buns", name: "Golden", weekdayTarget: 3, weekendTarget: 3),
            ThawProduct(id: "sourdough-buns", name: "Sourdough", weekdayTarget: 3, weekendTarget: 3),
            ThawProduct(id: "brioche-buns", name: "Brioche", weekdayTarget: 3, weekendTarget: 3)
        ]),
        ThawGroup(id: "dinner-rolls", name: "Dinner Rolls", products: [
            ThawProduct(id: "milk-rolls", name: "Milk", weekdayTarget: 4, weekendTarget: 5),
            ThawProduct(id: "potato-rolls", name: "Potato", weekdayTarget: 4, weekendTarget: 5)
        ]),
        ThawGroup(id: "hamburger-hotdog", name: "Hamburger & Hotdog", products: [
            ThawProduct(id: "hamburger", name: "Hamburger", weekdayTarget: 6, weekendTarget: 8),
            ThawProduct(id: "hotdog", name: "Hotdog", weekdayTarget: 6, weekendTarget: 8)
        ]),
        ThawGroup(id: "pan-loaf", name: "Pan Loaf", products: [
            ThawProduct(id: "buttery-sourdough-pan", name: "Buttery Sourdough", weekdayTarget: 1, weekendTarget: 2),
            ThawProduct(id: "multigrain-pan", name: "Multigrain", weekdayTarget: 1, weekendTarget: 2)
        ]),
        ThawGroup(id: "half-loaf", name: "Half Loaf", products: [
            ThawProduct(id: "marble-half", name: "Marble", weekdayTarget: 3, weekendTarget: 3),
            ThawProduct(id: "sourdough-half", name: "Sourdough", weekdayTarget: 4, weekendTarget: 4),
            ThawProduct(id: "tuscan-half", name: "Tuscan", weekdayTarget: 4, weekendTarget: 4),
            ThawProduct(id: "multigrain-half", name: "Multigrain", weekdayTarget: 6, weekendTarget: 6)
        ]),
        ThawGroup(id: "mini-muffins", name: "Mini Muffins", products: [
            ThawProduct(id: "chocolate-mini-muffins", name: "Chocolate", weekdayTarget: 8, weekendTarget: 10),
            ThawProduct(id: "blueberry-mini-muffins", name: "Blueberry", weekdayTarget: 4, weekendTarget: 5)
        ]),
        ThawGroup(id: "jumbo-muffins", name: "Jumbo Muffins", products: [
            ThawProduct(id: "chocolate-jumbo", name: "Chocolate", weekdayTarget: 6, weekendTarget: 6),
            ThawProduct(id: "cranberry-jumbo", name: "Cranberry", weekdayTarget: 2, weekendTarget: 2),
            ThawProduct(id: "mixed-berry-jumbo", name: "Mixed Berry", weekdayTarget: 4, weekendTarget: 4),
            ThawProduct(id: "double-berry-jumbo", name: "Double Berry", weekdayTarget: 2, weekendTarget: 2),
            ThawProduct(id: "apple-jumbo", name: "Apple", weekdayTarget: 4, weekendTarget: 4)
        ]),
        ThawGroup(id: "butter-tarts", name: "Butter Tarts", products: [
            ThawProduct(id: "mini-butter-tarts", name: "Mini", weekdayTarget: 6, weekendTarget: 8),
            ThawProduct(id: "classic-butter-tarts", name: "Classic", weekdayTarget: 3, weekendTarget: 4),
            ThawProduct(id: "pecan-butter-tarts", name: "Pecan", weekdayTarget: 3, weekendTarget: 4),
            ThawProduct(id: "raisin-butter-tarts", name: "Raisin", weekdayTarget: 3, weekendTarget: 4),
            ThawProduct(id: "maple-butter-tarts", name: "Maple", weekdayTarget: 3, weekendTarget: 4)
        ]),
        ThawGroup(id: "swiss-rolls", name: "Swiss Rolls", products: [
            ThawProduct(id: "chocolate-swiss", name: "Chocolate", weekdayTarget: 4, weekendTarget: 6),
            ThawProduct(id: "strawberry-swiss", name: "Strawberry", weekdayTarget: 4, weekendTarget: 6),
            ThawProduct(id: "black-forest-swiss", name: "Black Forest", weekdayTarget: 4, weekendTarget: 6),
            ThawProduct(id: "maple-swiss", name: "Maple", weekdayTarget: 4, weekendTarget: 6)
        ]),
        ThawGroup(id: "simply-five", name: "Simply Five", products: [
            ThawProduct(id: "garlic-simply-five", name: "Garlic", weekdayTarget: 1, weekendTarget: 2),
            ThawProduct(id: "mozzarella-simply-five", name: "Mozzarella", weekdayTarget: 1, weekendTarget: 2),
            ThawProduct(id: "basil-simply-five", name: "Basil", weekdayTarget: 1, weekendTarget: 2),
            ThawProduct(id: "white-simply-five", name: "White", weekdayTarget: 2, weekendTarget: 2),
            ThawProduct(id: "whole-wheat-simply-five", name: "Whole Wheat", weekdayTarget: 2, weekendTarget: 2),
            ThawProduct(id: "everything-simply-five", name: "Everything", weekdayTarget: 2, weekendTarget: 2)
        ]),
        ThawGroup(id: "cinnamon", name: "Cinnamon", products: [
            ThawProduct(id: "cinnamon-rolls", name: "Rolls", weekdayTarget: 12, weekendTarget: 12, targetDescription: "Order in packs of 4", packDivisor: 4),
            ThawProduct(id: "cinnamon-twists", name: "Twists", weekdayTarget: 12, weekendTarget: 12, targetDescription: "Order in packs of 3", packDivisor: 3)
        ]),
        ThawGroup(id: "florentine", name: "Florentine", products: [
            ThawProduct(id: "coconut-florentine", name: "Coconut", weekdayTarget: 10, weekendTarget: 10),
            ThawProduct(id: "hazelnut-florentine", name: "Hazelnut", weekdayTarget: 10, weekendTarget: 10)
        ])
    ]

    @State private var dayType: ThawDayType = .weekday
    @State private var currentIndex = 0
    @State private var counts: [String: Int] = [:]
    @State private var isShowingList = false

    private var currentGroup: ThawGroup {
        groups[currentIndex]
    }

    var body: some View {
        VStack(spacing: 12) {
            Picker("Day type", selection: $dayType) {
                ForEach(ThawDayType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            if isShowingList {
                thawList
            } else {
                countEntry
            }
        }
        .navigationTitle(isShowingList ? "Thaw List" : "Thaw")
        .toolbar {
            if isShowingList {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Edit Counts") {
                        isShowingList = false
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Reset", role: .destructive) {
                        counts.removeAll()
                        currentIndex = 0
                        isShowingList = false
                    }
                }
            }
        }
    }

    private var countEntry: some View {
        VStack(spacing: 12) {
            ProgressView(value: Double(currentIndex + 1), total: Double(groups.count))
                .padding(.horizontal)

            Text("Step \(currentIndex + 1) of \(groups.count)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ScrollView {
                VStack(spacing: 16) {
                    Text(currentGroup.name)
                        .font(.largeTitle.bold())

                    ForEach(currentGroup.products) { product in
                        productCounter(product)
                    }
                }
                .padding()
            }

            HStack {
                Button("Back") {
                    currentIndex -= 1
                }
                .disabled(currentIndex == 0)

                Spacer()

                Button(currentIndex == groups.count - 1 ? "Show Thaw List" : "Next") {
                    if currentIndex == groups.count - 1 {
                        isShowingList = true
                    } else {
                        currentIndex += 1
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding([.horizontal, .bottom])
        }
    }

    private func productCounter(_ product: ThawProduct) -> some View {
        let count = countBinding(for: product)
        let target = product.target(for: dayType)

        return VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(product.name)
                    .font(.headline)

                Spacer()

                Text("Target: \(target)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if let targetDescription = product.targetDescription {
                Text(targetDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Stepper(value: count, in: 0...999) {
                HStack {
                    Text("Count")
                    Spacer()
                    Text("\(count.wrappedValue)")
                        .font(.title2.monospacedDigit().bold())
                        .foregroundStyle(.blue)
                }
            }
            .padding()
            .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
        }
    }

    private var thawList: some View {
        List {
            ForEach(groups) { group in
                Section(group.name) {
                    ForEach(group.products) { product in
                        thawListRow(product)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private func thawListRow(_ product: ThawProduct) -> some View {
        let target = product.target(for: dayType)
        let enteredCount = counts[product.id, default: 0]
        let shortfall = max(target - enteredCount, 0)
        let amountNeeded: Int
        let unit: String

        if let divisor = product.packDivisor {
            amountNeeded = (shortfall + divisor - 1) / divisor
            unit = amountNeeded == 1 ? "pack" : "packs"
        } else {
            amountNeeded = shortfall
            unit = "needed"
        }

        return HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(product.name)
                    .font(.headline)
                Text("\(target) target - \(enteredCount) counted")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(amountNeeded)")
                    .font(.title3.monospacedDigit().bold())
                    .foregroundStyle(.blue)
                Text(unit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 3)
    }

    private func countBinding(for product: ThawProduct) -> Binding<Int> {
        Binding(
            get: { counts[product.id, default: 0] },
            set: { counts[product.id] = $0 }
        )
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
