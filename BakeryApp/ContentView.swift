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
                    BakeryItemList(items: filteredItems, searchText: searchText)
                        .navigationTitle("Bakery Shelf Life")
                }
                .searchable(text: $searchText, prompt: "Search products or categories")
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

            Tab("Skids", systemImage: "shippingbox") {
                NavigationStack {
                    SkidsView()
                }
            }
        }
        .tint(.blue)
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
                .tint(.blue)
            }
        }
        .padding()
    }

    private func bunEntry(for product: BunProduct) -> some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "takeoutbag.and.cup.and.straw")
                .font(.system(size: 48))
                .foregroundStyle(.blue)

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
                    .foregroundStyle(.blue)
            }
        }
        .padding()
        .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
    }

    private var bunList: some View {
        List {
            bunListSection("Buns", products: bunProducts)
            bunListSection("Bagels", products: bagelProducts)
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

    private func bunListSection(_ title: String, products: [BunProduct]) -> some View {
        Section(title) {
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
                        .foregroundStyle(.blue)
                }
                .padding(.vertical, 3)
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
    var trayDivisor: Int?

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
            ThawProduct(id: "cinnamon-rolls", name: "Rolls", weekdayTarget: 12, weekendTarget: 12, targetDescription: "Order in trays of 4", trayDivisor: 4),
            ThawProduct(id: "cinnamon-twists", name: "Twists", weekdayTarget: 12, weekendTarget: 12, targetDescription: "Order in trays of 3", trayDivisor: 3)
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

        if let divisor = product.trayDivisor {
            amountNeeded = (shortfall + divisor - 1) / divisor
            unit = amountNeeded == 1 ? "tray" : "trays"
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

private struct SkidItem: Identifiable {
    let id: String
    let category: String
    let name: String
}

private struct SkidsView: View {
    private let availableItems = [
        SkidItem(id: "sweets-mini-strudel-apple", category: "Sweets", name: "Mini Strudel - Apple"),
        SkidItem(id: "sweets-mini-strudel-raspberry", category: "Sweets", name: "Mini Strudel - Raspberry"),
        SkidItem(id: "sweets-fruit-stick-apple", category: "Sweets", name: "Fruit Stick - Apple"),
        SkidItem(id: "sweets-fruit-stick-raspberry", category: "Sweets", name: "Fruit Stick - Raspberry"),
        SkidItem(id: "sweets-apple-turnover", category: "Sweets", name: "Apple Turnover"),
        SkidItem(id: "sweets-palm-leaf", category: "Sweets", name: "Palm Leaf"),
        SkidItem(id: "sweets-maple-pecan", category: "Sweets", name: "Maple Pecan"),
        SkidItem(id: "sweets-plant-based-strudel-apple", category: "Sweets", name: "Plant Based Strudel - Apple"),
        SkidItem(id: "sweets-plant-based-strudel-cherry", category: "Sweets", name: "Plant Based Strudel - Cherry"),
        SkidItem(id: "sweets-custard-tarts-regular", category: "Sweets", name: "Custard Tarts - Regular"),
        SkidItem(id: "sweets-custard-tarts-hazelnut", category: "Sweets", name: "Custard Tarts - Hazelnut"),
        SkidItem(id: "sweets-scone-cheddar", category: "Sweets", name: "Scone - Cheddar"),
        SkidItem(id: "sweets-scone-cranberry", category: "Sweets", name: "Scone - Cranberry"),
        SkidItem(id: "sweets-scone-raisin", category: "Sweets", name: "Scone - Raisin"),
        SkidItem(id: "sweets-scone-blueberry", category: "Sweets", name: "Scone - Blueberry"),
        SkidItem(id: "croissants-all-butter", category: "Croissants", name: "All Butter Croissant"),
        SkidItem(id: "croissants-breakfast", category: "Croissants", name: "Breakfast Croissant"),
        SkidItem(id: "croissants-chocolate", category: "Croissants", name: "Chocolate Croissant"),
        SkidItem(id: "croissants-mini-breakfast", category: "Croissants", name: "Mini Breakfast Croissant"),
        SkidItem(id: "croissants-mini-cheese", category: "Croissants", name: "Mini Cheese Croissant"),
        SkidItem(id: "croissants-mini-chocolate", category: "Croissants", name: "Mini Chocolate Croissant"),
        SkidItem(id: "croissants-pain-au-chocolat", category: "Croissants", name: "Pain au Chocolat"),
        SkidItem(id: "croissants-plant-based", category: "Croissants", name: "Plant Based Croissant"),
        SkidItem(id: "thaw-bagels-asiago", category: "Thaw and Serve", name: "7 Bagels - Asiago"),
        SkidItem(id: "thaw-bagels-everything", category: "Thaw and Serve", name: "7 Bagels - Everything"),
        SkidItem(id: "thaw-bagels-plain", category: "Thaw and Serve", name: "7 Bagels - Plain"),
        SkidItem(id: "thaw-bagels-sesame", category: "Thaw and Serve", name: "7 Bagels - Sesame"),
        SkidItem(id: "thaw-bagels-multigrain", category: "Thaw and Serve", name: "7 Bagels - Multigrain"),
        SkidItem(id: "thaw-bagels-whole-wheat", category: "Thaw and Serve", name: "7 Bagels - Whole Wheat"),
        SkidItem(id: "thaw-bagels-cinnamon", category: "Thaw and Serve", name: "7 Bagels - Cinnamon"),
        SkidItem(id: "thaw-new-buns-golden", category: "Thaw and Serve", name: "New Buns - Golden"),
        SkidItem(id: "thaw-new-buns-sourdough", category: "Thaw and Serve", name: "New Buns - Sourdough"),
        SkidItem(id: "thaw-new-buns-brioche", category: "Thaw and Serve", name: "New Buns - Brioche"),
        SkidItem(id: "thaw-dinner-rolls-milk", category: "Thaw and Serve", name: "Dinner Rolls - Milk"),
        SkidItem(id: "thaw-dinner-rolls-potato", category: "Thaw and Serve", name: "Dinner Rolls - Potato"),
        SkidItem(id: "thaw-hamburger", category: "Thaw and Serve", name: "Hamburger"),
        SkidItem(id: "thaw-hotdog", category: "Thaw and Serve", name: "Hotdog"),
        SkidItem(id: "thaw-pan-loaf-buttery-sourdough", category: "Thaw and Serve", name: "Pan Loaf - Buttery Sourdough"),
        SkidItem(id: "thaw-pan-loaf-multigrain", category: "Thaw and Serve", name: "Pan Loaf - Multigrain"),
        SkidItem(id: "thaw-half-loaf-marble", category: "Thaw and Serve", name: "Half Loaf - Marble"),
        SkidItem(id: "thaw-half-loaf-sourdough", category: "Thaw and Serve", name: "Half Loaf - Sourdough"),
        SkidItem(id: "thaw-half-loaf-tuscan", category: "Thaw and Serve", name: "Half Loaf - Tuscan"),
        SkidItem(id: "thaw-half-loaf-multigrain", category: "Thaw and Serve", name: "Half Loaf - Multigrain"),
        SkidItem(id: "thaw-mini-muffins-chocolate", category: "Thaw and Serve", name: "Mini Muffins - Chocolate"),
        SkidItem(id: "thaw-mini-muffins-blueberry", category: "Thaw and Serve", name: "Mini Muffins - Blueberry"),
        SkidItem(id: "thaw-jumbo-muffins-chocolate", category: "Thaw and Serve", name: "Jumbo Muffins - Chocolate"),
        SkidItem(id: "thaw-jumbo-muffins-cranberry", category: "Thaw and Serve", name: "Jumbo Muffins - Cranberry"),
        SkidItem(id: "thaw-jumbo-muffins-mixed-berry", category: "Thaw and Serve", name: "Jumbo Muffins - Mixed Berry"),
        SkidItem(id: "thaw-jumbo-muffins-double-berry", category: "Thaw and Serve", name: "Jumbo Muffins - Double Berry"),
        SkidItem(id: "thaw-jumbo-muffins-apple", category: "Thaw and Serve", name: "Jumbo Muffins - Apple"),
        SkidItem(id: "thaw-butter-tarts-mini", category: "Thaw and Serve", name: "Butter Tarts - Mini"),
        SkidItem(id: "thaw-butter-tarts-classic", category: "Thaw and Serve", name: "Butter Tarts - Classic"),
        SkidItem(id: "thaw-butter-tarts-pecan", category: "Thaw and Serve", name: "Butter Tarts - Pecan"),
        SkidItem(id: "thaw-butter-tarts-raisin", category: "Thaw and Serve", name: "Butter Tarts - Raisin"),
        SkidItem(id: "thaw-butter-tarts-maple", category: "Thaw and Serve", name: "Butter Tarts - Maple"),
        SkidItem(id: "thaw-swiss-rolls-chocolate", category: "Thaw and Serve", name: "Swiss Rolls - Chocolate"),
        SkidItem(id: "thaw-swiss-rolls-strawberry", category: "Thaw and Serve", name: "Swiss Rolls - Strawberry"),
        SkidItem(id: "thaw-swiss-rolls-black-forest", category: "Thaw and Serve", name: "Swiss Rolls - Black Forest"),
        SkidItem(id: "thaw-swiss-rolls-maple", category: "Thaw and Serve", name: "Swiss Rolls - Maple"),
        SkidItem(id: "thaw-simply-five-garlic", category: "Thaw and Serve", name: "Simply Five - Garlic"),
        SkidItem(id: "thaw-simply-five-mozzarella", category: "Thaw and Serve", name: "Simply Five - Mozzarella"),
        SkidItem(id: "thaw-simply-five-basil", category: "Thaw and Serve", name: "Simply Five - Basil"),
        SkidItem(id: "thaw-simply-five-white", category: "Thaw and Serve", name: "Simply Five - White"),
        SkidItem(id: "thaw-simply-five-whole-wheat", category: "Thaw and Serve", name: "Simply Five - Whole Wheat"),
        SkidItem(id: "thaw-simply-five-everything", category: "Thaw and Serve", name: "Simply Five - Everything"),
        SkidItem(id: "thaw-cinnamon-rolls", category: "Thaw and Serve", name: "Cinnamon Rolls"),
        SkidItem(id: "thaw-cinnamon-twist", category: "Thaw and Serve", name: "Cinnamon Twist"),
        SkidItem(id: "thaw-florentine-coconut", category: "Thaw and Serve", name: "Florentine - Coconut"),
        SkidItem(id: "thaw-florentine-hazelnut", category: "Thaw and Serve", name: "Florentine - Hazelnut"),
        SkidItem(id: "upstairs-garlic-bread", category: "Upstairs Thaw and Serve", name: "Garlic Bread"),
        SkidItem(id: "upstairs-gluten-free-tarts", category: "Upstairs Thaw and Serve", name: "Gluten Free Tarts"),
        SkidItem(id: "upstairs-vegan-cupcakes-lemon", category: "Upstairs Thaw and Serve", name: "Vegan Cupcakes - Lemon"),
        SkidItem(id: "upstairs-vegan-cupcakes-carrot", category: "Upstairs Thaw and Serve", name: "Vegan Cupcakes - Carrot"),
        SkidItem(id: "upstairs-vegan-cupcakes-berry", category: "Upstairs Thaw and Serve", name: "Vegan Cupcakes - Berry"),
        SkidItem(id: "upstairs-vegan-cupcakes-chocolate", category: "Upstairs Thaw and Serve", name: "Vegan Cupcakes - Chocolate"),
        SkidItem(id: "upstairs-vegan-muffins-cranberry", category: "Upstairs Thaw and Serve", name: "Vegan Muffins - Cranberry"),
        SkidItem(id: "upstairs-vegan-muffins-blueberry", category: "Upstairs Thaw and Serve", name: "Vegan Muffins - Blueberry"),
        SkidItem(id: "upstairs-vegan-muffins-double-chocolate", category: "Upstairs Thaw and Serve", name: "Vegan Muffins - Double Chocolate"),
        SkidItem(id: "upstairs-vegan-muffins-chocolate-chip", category: "Upstairs Thaw and Serve", name: "Vegan Muffins - Chocolate Chip"),
        SkidItem(id: "upstairs-mini-donuts-red-berry", category: "Upstairs Thaw and Serve", name: "Mini Donuts - Red Berry"),
        SkidItem(id: "upstairs-mini-donuts-chocolate-hazelnut", category: "Upstairs Thaw and Serve", name: "Mini Donuts - Chocolate Hazelnut"),
        SkidItem(id: "upstairs-fb-donuts-cinnamon", category: "Upstairs Thaw and Serve", name: "FB Donuts - Cinnamon"),
        SkidItem(id: "upstairs-fb-donuts-caramel", category: "Upstairs Thaw and Serve", name: "FB Donuts - Caramel"),
        SkidItem(id: "upstairs-fb-donuts-celebration", category: "Upstairs Thaw and Serve", name: "FB Donuts - Celebration"),
        SkidItem(id: "upstairs-coffee-cake-cinnamon", category: "Upstairs Thaw and Serve", name: "Coffee Cake - Cinnamon"),
        SkidItem(id: "upstairs-coffee-cake-wild-berry", category: "Upstairs Thaw and Serve", name: "Coffee Cake - Wild Berry"),
        SkidItem(id: "upstairs-coffee-cake-chocolate", category: "Upstairs Thaw and Serve", name: "Coffee Cake - Chocolate"),
        SkidItem(id: "buns-portuguese-buns", category: "Buns", name: "Portuguese Buns"),
        SkidItem(id: "buns-rustic-italian", category: "Buns", name: "Rustic Italian"),
        SkidItem(id: "buns-portuguese-sweet", category: "Buns", name: "Portuguese Sweet"),
        SkidItem(id: "buns-croissant-bun", category: "Buns", name: "Croissant Bun"),
        SkidItem(id: "buns-pretzel-buns", category: "Buns", name: "Pretzel Buns"),
        SkidItem(id: "buns-pretzel-twist", category: "Buns", name: "Pretzel Twist"),
        SkidItem(id: "buns-cheese-bun", category: "Buns", name: "Cheese Bun"),
        SkidItem(id: "buns-cheese-stick", category: "Buns", name: "Cheese Stick"),
        SkidItem(id: "buns-bagels-everything", category: "Buns", name: "6 Bagels - Everything"),
        SkidItem(id: "buns-bagels-plain", category: "Buns", name: "6 Bagels - Plain"),
        SkidItem(id: "buns-bagels-sesame", category: "Buns", name: "6 Bagels - Sesame"),
        SkidItem(id: "buns-bagels-cheese", category: "Buns", name: "6 Bagels - Cheese"),
        SkidItem(id: "buns-bagels-jalapeno", category: "Buns", name: "6 Bagels - Jalapeno"),
        SkidItem(id: "buns-bagels-cinnamon", category: "Buns", name: "6 Bagels - Cinnamon"),
        SkidItem(id: "pies-8-apple", category: "Pies", name: "8\" Pie - Apple"),
        SkidItem(id: "pies-8-strawberry-rhubarb", category: "Pies", name: "8\" Pie - Strawberry Rhubarb"),
        SkidItem(id: "pies-8-saskatoon-berry", category: "Pies", name: "8\" Pie - Saskatoon Berry"),
        SkidItem(id: "pies-8-cherry", category: "Pies", name: "8\" Pie - Cherry"),
        SkidItem(id: "pies-8-blueberry", category: "Pies", name: "8\" Pie - Blueberry"),
        SkidItem(id: "pies-8-pumpkin", category: "Pies", name: "8\" Pie - Pumpkin"),
        SkidItem(id: "pies-8-pecan", category: "Pies", name: "8\" Pie - Pecan"),
        SkidItem(id: "pies-8-lemon-crunch", category: "Pies", name: "8\" Pie - Lemon Crunch"),
        SkidItem(id: "pies-8-lemon-meringue", category: "Pies", name: "8\" Pie - Lemon Meringue"),
        SkidItem(id: "pies-8-no-sugar-apple", category: "Pies", name: "8\" Pie - No Sugar Apple"),
        SkidItem(id: "pies-8-no-sugar-blueberry", category: "Pies", name: "8\" Pie - No Sugar Blueberry"),
        SkidItem(id: "pies-9-apple", category: "Pies", name: "9\" Pie - Apple"),
        SkidItem(id: "pies-9-cherry", category: "Pies", name: "9\" Pie - Cherry"),
        SkidItem(id: "pies-9-peach", category: "Pies", name: "9\" Pie - Peach"),
        SkidItem(id: "cake-mousse-raspberry", category: "Cake", name: "Mousse Cake - Raspberry"),
        SkidItem(id: "cake-mousse-hazelnut", category: "Cake", name: "Mousse Cake - Hazelnut"),
        SkidItem(id: "cake-mousse-chocolate", category: "Cake", name: "Mousse Cake - Chocolate"),
        SkidItem(id: "cake-mini-tiramisu", category: "Cake", name: "Mini Cake - Tiramisu"),
        SkidItem(id: "cake-mini-apple", category: "Cake", name: "Mini Cake - Apple"),
        SkidItem(id: "cake-mini-raspberry", category: "Cake", name: "Mini Cake - Raspberry"),
        SkidItem(id: "cake-mini-chocolate", category: "Cake", name: "Mini Cake - Chocolate"),
        SkidItem(id: "cake-butter-tarts-chocolate", category: "Cake", name: "Butter Tarts - Chocolate"),
        SkidItem(id: "cake-butter-tarts-pecan", category: "Cake", name: "Butter Tarts - Pecan"),
        SkidItem(id: "cake-butter-tarts-classic", category: "Cake", name: "Butter Tarts - Classic"),
        SkidItem(id: "cake-mini-cheesecake-pecan", category: "Cake", name: "Mini Cheesecake - Pecan"),
        SkidItem(id: "cake-mini-cheesecake-lemon", category: "Cake", name: "Mini Cheesecake - Lemon"),
        SkidItem(id: "cake-6-lemon", category: "Cake", name: "6\" Cake - Lemon"),
        SkidItem(id: "cake-6-red-velvet", category: "Cake", name: "6\" Cake - Red Velvet"),
        SkidItem(id: "cake-6-brownie-chocolate-cheesecake", category: "Cake", name: "6\" Cake - Brownie Chocolate Cheesecake"),
        SkidItem(id: "cake-6-strawberry-dream", category: "Cake", name: "6\" Cake - Strawberry Dream"),
        SkidItem(id: "cake-6-chocolate-truffle", category: "Cake", name: "6\" Cake - Chocolate Truffle"),
        SkidItem(id: "cake-6-chocolate-fudge", category: "Cake", name: "6\" Cake - Chocolate Fudge"),
        SkidItem(id: "cake-8-chocolate-truffle-trio", category: "Cake", name: "8\" Cake - Chocolate Truffle Trio"),
        SkidItem(id: "cake-8-mocha-almond-fudge", category: "Cake", name: "8\" Cake - Mocha Almond Fudge"),
        SkidItem(id: "cake-8-tiramisu", category: "Cake", name: "8\" Cake - Tiramisu"),
        SkidItem(id: "cake-8-red-velvet", category: "Cake", name: "8\" Cake - Red Velvet"),
        SkidItem(id: "cake-8-black-forest", category: "Cake", name: "8\" Cake - Black Forest"),
        SkidItem(id: "cake-8-le-rocher", category: "Cake", name: "8\" Cake - Le Rocher"),
        SkidItem(id: "cake-8-caramel-butter-pecan", category: "Cake", name: "8\" Cake - Caramel Butter Pecan"),
        SkidItem(id: "cake-8-chocolate-birthday", category: "Cake", name: "8\" Cake - Chocolate Birthday"),
        SkidItem(id: "cake-8-vanilla-birthday", category: "Cake", name: "8\" Cake - Vanilla Birthday"),
        SkidItem(id: "cake-8-key-lime", category: "Cake", name: "8\" Cake - Key Lime"),
        SkidItem(id: "cake-bar-strawberry", category: "Cake", name: "Bar Cake - Strawberry"),
        SkidItem(id: "cake-bar-carrot", category: "Cake", name: "Bar Cake - Carrot"),
        SkidItem(id: "cake-bar-tiramisu", category: "Cake", name: "Bar Cake - Tiramisu"),
        SkidItem(id: "cake-bar-smores", category: "Cake", name: "Bar Cake - S'mores"),
        SkidItem(id: "cake-bar-tuxedo", category: "Cake", name: "Bar Cake - Tuxedo"),
        SkidItem(id: "macarons-vanilla", category: "Macarons", name: "Vanilla Macaron"),
        SkidItem(id: "macarons-caramel", category: "Macarons", name: "Caramel Macaron"),
        SkidItem(id: "macarons-bubblegum", category: "Macarons", name: "Bubblegum Macaron"),
        SkidItem(id: "macarons-lemon", category: "Macarons", name: "Lemon Macaron"),
        SkidItem(id: "macarons-chocolate", category: "Macarons", name: "Chocolate Macaron"),
        SkidItem(id: "macarons-strawberry", category: "Macarons", name: "Strawberry Macaron"),
        SkidItem(id: "macarons-tiramisu", category: "Macarons", name: "Tiramisu Macaron"),
        SkidItem(id: "macarons-red-velvet", category: "Macarons", name: "Red Velvet Macaron"),
        SkidItem(id: "macarons-birthday-cake", category: "Macarons", name: "Birthday Cake Macaron"),
        SkidItem(id: "macarons-pistachio", category: "Macarons", name: "Pistachio Macaron"),
        SkidItem(id: "macarons-candy-cane", category: "Macarons", name: "Candy Cane Macaron"),
        SkidItem(id: "cookies-chocolate-chunk", category: "Cookies", name: "Chocolate Chunk Cookie"),
        SkidItem(id: "cookies-caramel-chocolate-chunk", category: "Cookies", name: "Caramel Chocolate Chunk Cookie"),
        SkidItem(id: "cookies-oatmeal-chocolate", category: "Cookies", name: "Oatmeal Chocolate Cookie"),
        SkidItem(id: "cookies-white-macadamia", category: "Cookies", name: "White Macadamia Cookie"),
        SkidItem(id: "cookies-peanut-butter", category: "Cookies", name: "Peanut Butter Cookie"),
        SkidItem(id: "cookies-ginger-molasses", category: "Cookies", name: "Ginger Molasses Cookie"),
        SkidItem(id: "cookies-monster", category: "Cookies", name: "Monster Cookie"),
        SkidItem(id: "cookies-plant-based-chocolate-chip", category: "Cookies", name: "Plant Based Chocolate Chip Cookie"),
        SkidItem(id: "cookies-plant-based-oatmeal-raisin", category: "Cookies", name: "Plant Based Oatmeal Raisin Cookie"),
        SkidItem(id: "bread-art-is-in-frank", category: "Bread", name: "Art-is-in - Frank"),
        SkidItem(id: "bread-art-is-in-whole-wheat-sourdough", category: "Bread", name: "Art-is-in - Whole Wheat Sourdough"),
        SkidItem(id: "bread-dynamic-kalamata-olive", category: "Bread", name: "Dynamic - Kalamata Olive"),
        SkidItem(id: "bread-dynamic-cheddar-cheese", category: "Bread", name: "Dynamic - Cheddar Cheese"),
        SkidItem(id: "bread-dynamic-rosemary", category: "Bread", name: "Dynamic - Rosemary"),
        SkidItem(id: "bread-three-cheese-loaf", category: "Bread", name: "Three Cheese Loaf"),
        SkidItem(id: "bread-baguette", category: "Bread", name: "Baguette"),
        SkidItem(id: "bread-sourdough-baguette", category: "Bread", name: "Sourdough Baguette"),
        SkidItem(id: "bread-belgian", category: "Bread", name: "Belgian"),
        SkidItem(id: "bread-country-round", category: "Bread", name: "Country Round"),
        SkidItem(id: "bread-cranberry-pumpkin-seed", category: "Bread", name: "Cranberry Pumpkin Seed"),
        SkidItem(id: "bread-multigrain-belgian", category: "Bread", name: "Multigrain Belgian"),
        SkidItem(id: "bread-organic-sourdough-boule", category: "Bread", name: "Organic Sourdough Boule"),
        SkidItem(id: "bread-organic-sprout", category: "Bread", name: "Organic Sprout"),
        SkidItem(id: "bread-pane-di-como-italian-loaf", category: "Bread", name: "Pane di Como Italian Loaf"),
        SkidItem(id: "bread-parisian", category: "Bread", name: "Parisian"),
        SkidItem(id: "bread-pumpernickel", category: "Bread", name: "Pumpernickel"),
        SkidItem(id: "bread-rosemary-olive-oil", category: "Bread", name: "Rosemary Olive Oil"),
        SkidItem(id: "bread-sourdough-batard", category: "Bread", name: "Sourdough Batard"),
        SkidItem(id: "bread-multigrain-sourdough-batard", category: "Bread", name: "Multigrain Sourdough Batard"),
        SkidItem(id: "bread-mini-sourdough", category: "Bread", name: "Mini Sourdough"),
        SkidItem(id: "bread-organic-white", category: "Bread", name: "Organic White"),
        SkidItem(id: "bread-calabrese-long", category: "Bread", name: "Calabrese Long"),
        SkidItem(id: "bread-calabrese-round", category: "Bread", name: "Calabrese Round")
    ]

    @State private var receivedItems: [String: Int] = [:]
    @State private var searchText = ""
    @State private var summarySearchText = ""
    @State private var customItemName = ""
    @State private var customQuantity = 1
    @State private var isShowingSummary = false

    private let categoryOrder = [
        "Sweets",
        "Croissants",
        "Thaw and Serve",
        "Upstairs Thaw and Serve",
        "Buns",
        "Pies",
        "Cake",
        "Macarons",
        "Cookies",
        "Bread",
        "Custom"
    ]

    private var filteredAvailableItems: [SkidItem] {
        guard !searchText.isEmpty else {
            return availableItems
        }

        return availableItems.filter { item in
            item.name.localizedCaseInsensitiveContains(searchText)
                || item.category.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var availableCategories: [String] {
        categoryOrder.filter { category in
            filteredAvailableItems.contains { $0.category == category }
        }
    }

    private var receivedItemNames: [String] {
        receivedItems.keys.sorted {
            $0.localizedStandardCompare($1) == .orderedAscending
        }
    }

    private var receivedCategories: [String] {
        categoryOrder.filter { category in
            !receivedItemNames(in: category).isEmpty
        }
    }

    private var filteredReceivedCategories: [String] {
        categoryOrder.filter { category in
            !receivedItemNames(in: category, from: filteredReceivedItemNames).isEmpty
        }
    }

    private var filteredReceivedItemNames: [String] {
        guard !summarySearchText.isEmpty else {
            return receivedItemNames
        }

        return receivedItemNames.filter {
            $0.localizedCaseInsensitiveContains(summarySearchText)
        }
    }

    private var trimmedCustomItemName: String {
        customItemName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        Group {
            if isShowingSummary {
                summaryList
            } else {
                entryList
            }
        }
        .navigationTitle(isShowingSummary ? "Skid List" : "Skids")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isShowingSummary ? "Edit" : "Finish") {
                    isShowingSummary.toggle()
                }
                .disabled(receivedItems.isEmpty)
            }

            if !receivedItems.isEmpty {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset", role: .destructive) {
                        receivedItems.removeAll()
                        searchText = ""
                        summarySearchText = ""
                        customItemName = ""
                        customQuantity = 1
                        isShowingSummary = false
                    }
                }
            }
        }
    }

    private var entryList: some View {
        List {
            if !receivedItems.isEmpty {
                ForEach(receivedCategories, id: \.self) { category in
                    let itemNames = receivedItemNames(in: category)

                    Section("Current Skid - \(category)") {
                        ForEach(itemNames, id: \.self) { itemName in
                            receivedItemRow(itemName: itemName)
                        }
                        .onDelete { offsets in
                            deleteReceivedItems(at: offsets, from: itemNames)
                        }
                    }
                }
            }

            ForEach(availableCategories, id: \.self) { category in
                Section(category) {
                    ForEach(items(in: category)) { item in
                        Button {
                            addReceivedItem(named: item.name)
                        } label: {
                            skidItemPickerRow(item)
                        }
                    }
                }
            }

            Section("Add Custom Item") {
                TextField("Item name", text: $customItemName)
                    .textInputAutocapitalization(.words)

                Stepper(value: $customQuantity, in: 1...999) {
                    HStack {
                        Text("Quantity")
                        Spacer()
                        Text("\(customQuantity)")
                            .font(.headline.monospacedDigit())
                            .foregroundStyle(.blue)
                    }
                }

                Button {
                    addReceivedItem(named: trimmedCustomItemName, quantity: customQuantity)
                    customItemName = ""
                    customQuantity = 1
                } label: {
                    Label("Add Item", systemImage: "plus.circle.fill")
                }
                .disabled(trimmedCustomItemName.isEmpty)
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: $searchText, prompt: "Search skid items")
    }

    private var summaryList: some View {
        List {
            ForEach(filteredReceivedCategories, id: \.self) { category in
                Section(category) {
                    ForEach(receivedItemNames(in: category, from: filteredReceivedItemNames), id: \.self) { itemName in
                        receivedItemRow(itemName: itemName)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: $summarySearchText, prompt: "Search received items")
    }

    private func items(in category: String) -> [SkidItem] {
        filteredAvailableItems.filter { $0.category == category }
    }

    private func receivedItemNames(in category: String, from itemNames: [String]? = nil) -> [String] {
        let names = itemNames ?? receivedItemNames

        return names.filter {
            categoryName(for: $0) == category
        }
    }

    private func categoryName(for itemName: String) -> String {
        availableItems.first { $0.name == itemName }?.category ?? "Custom"
    }

    private func skidItemPickerRow(_ item: SkidItem) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "shippingbox")
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 36, height: 36)
                .background(.blue.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 3) {
                Text(item.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
            }

            Spacer()

            let count = receivedItems[item.name, default: 0]
            if count > 0 {
                Text("\(count)")
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(.blue)
            }

            Image(systemName: "plus.circle.fill")
                .foregroundStyle(.blue)
        }
    }

    private func receivedItemRow(itemName: String) -> some View {
        HStack {
            Text(itemName)
                .font(.headline)

            Spacer()

            Button {
                decrementReceivedItem(named: itemName)
            } label: {
                Image(systemName: "minus.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.red)
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("Remove one \(itemName)")

            Text("\(receivedItems[itemName, default: 0])")
                .font(.title3.monospacedDigit().bold())
                .foregroundStyle(.blue)
                .frame(minWidth: 32, alignment: .trailing)
        }
        .padding(.vertical, 3)
    }

    private func addReceivedItem(named itemName: String, quantity: Int = 1) {
        receivedItems[itemName, default: 0] += quantity
    }

    private func decrementReceivedItem(named itemName: String) {
        let newCount = receivedItems[itemName, default: 0] - 1

        if newCount > 0 {
            receivedItems[itemName] = newCount
        } else {
            receivedItems.removeValue(forKey: itemName)
        }
    }

    private func deleteReceivedItems(at offsets: IndexSet, from itemNames: [String]) {
        for offset in offsets {
            receivedItems.removeValue(forKey: itemNames[offset])
        }
    }
}

private struct BakeryItemList: View {
    let items: [BakeryItem]
    var searchText = ""

    private var categories: [String] {
        Set(items.map(\.merchandisingCategory)).sorted {
            $0.localizedStandardCompare($1) == .orderedAscending
        }
    }

    private func items(in category: String) -> [BakeryItem] {
        items
            .filter { $0.merchandisingCategory == category }
            .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }

    var body: some View {
        if items.isEmpty {
            ContentUnavailableView.search(text: searchText)
        } else {
            List {
                ForEach(categories, id: \.self) { category in
                    Section(category) {
                        ForEach(items(in: category)) { item in
                            BakeryItemRow(item: item)
                        }
                    }
                }
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
                .foregroundStyle(.blue)
                .frame(width: 44, height: 44)
                .background(.blue.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))

            Text(item.name)
                .font(.headline)

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text("Shelf life")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(item.shelfLife)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.blue)
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
