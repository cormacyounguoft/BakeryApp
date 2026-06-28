//
//  ContentView.swift
//  BakeryApp
//
//  Created by Cormac Young on 2026-06-13.
//

import SwiftUI

private let bakeryDataCSVURL = URL(string: "https://api.github.com/repos/cormacyounguoft/BakeryApp/contents/BakeryApp/BakeryData.csv?ref=main")!

struct BakeryItem: Identifiable {
    var id: String { "\(merchandisingCategory)-\(name)" }
    let merchandisingCategory: String
    let name: String
    let shelfLife: String
}

private struct BakeryData {
    var shelfLifeItems: [BakeryItem] = []
    var bunProducts: [BunProduct] = []
    var thawGroups: [ThawGroup] = []
    var skidItems: [SkidItem] = []

    var isComplete: Bool {
        !shelfLifeItems.isEmpty && !bunProducts.isEmpty && !thawGroups.isEmpty && !skidItems.isEmpty
    }

    var hasAnyData: Bool {
        !shelfLifeItems.isEmpty || !bunProducts.isEmpty || !thawGroups.isEmpty || !skidItems.isEmpty
    }
}

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var searchText = ""
    @State private var bakeryData = BakeryDataLoader.loadBundledData()
    @State private var dataLoadError: String?

    private var bakeryItems: [BakeryItem] {
        bakeryData.shelfLifeItems
    }

    private var filteredItems: [BakeryItem] {
        let matchingItems: [BakeryItem]

        if searchText.isEmpty {
            matchingItems = bakeryItems
        } else {
            matchingItems = bakeryItems.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText)
                    || item.merchandisingCategory.localizedCaseInsensitiveContains(searchText)
            }
        }

        return matchingItems.sorted {
            let categoryComparison = $0.merchandisingCategory.localizedStandardCompare($1.merchandisingCategory)

            if categoryComparison == .orderedSame {
                return $0.name.localizedStandardCompare($1.name) == .orderedAscending
            }

            return categoryComparison == .orderedAscending
        }
    }

    var body: some View {
        TabView {
            Tab("Items", systemImage: "birthday.cake") {
                NavigationStack {
                    BakeryItemList(items: filteredItems, searchText: searchText)
                        .navigationTitle("Bakery Shelf Life")
                        .refreshable {
                            await refreshData()
                        }
                }
                .searchable(text: $searchText, prompt: "Search products or categories")
            }

            Tab("Buns", systemImage: "takeoutbag.and.cup.and.straw") {
                NavigationStack {
                    BunCountView(products: bakeryData.bunProducts)
                }
            }

            Tab("Thaw", systemImage: "snowflake") {
                NavigationStack {
                    ThawCountView(groups: bakeryData.thawGroups)
                }
            }

            Tab("Skids", systemImage: "shippingbox") {
                NavigationStack {
                    SkidsView(availableItems: bakeryData.skidItems)
                }
            }
        }
        .tint(.blue)
        .task {
            await refreshData()
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active else { return }

            Task {
                await refreshData()
            }
        }
    }

    private func refreshData() async {
        do {
            bakeryData = try await BakeryDataLoader.loadRemoteData()
            dataLoadError = nil
        } catch {
            dataLoadError = "Using saved data"
        }
    }
}

private struct BunProduct: Identifiable {
    let id: String
    let name: String
    let targetQuantity: Int
    var targetDescription: String?
}

private struct BunCountView: View {
    let products: [BunProduct]

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
    let groups: [ThawGroup]

    @State private var dayType: ThawDayType = .weekday
    @State private var currentIndex = 0
    @State private var counts: [String: Int] = [:]
    @State private var isShowingList = false

    private var currentGroup: ThawGroup {
        groups[currentIndex]
    }

    var body: some View {
        Group {
            if groups.isEmpty {
                ContentUnavailableView("No Thaw Data", systemImage: "snowflake")
            } else {
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
    let availableItems: [SkidItem]

    @State private var receivedItems: [String: Int] = [:]
    @State private var searchText = ""
    @State private var summarySearchText = ""
    @State private var customItemName = ""
    @State private var customQuantity = 1
    @State private var isShowingSummary = false

    private let categoryOrder = [
        "Bread",
        "Buns",
        "Cake",
        "Cookies",
        "Croissants",
        "Custom",
        "Macarons",
        "Pies",
        "Sweets",
        "Thaw and Serve",
        "Upstairs Thaw and Serve"
    ]

    private var filteredAvailableItems: [SkidItem] {
        let matchingItems: [SkidItem]

        if searchText.isEmpty {
            matchingItems = availableItems
        } else {
            matchingItems = availableItems.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText)
                    || item.category.localizedCaseInsensitiveContains(searchText)
            }
        }

        return matchingItems.sorted {
            $0.name.localizedStandardCompare($1.name) == .orderedAscending
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
        filteredAvailableItems
            .filter { $0.category == category }
            .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
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

private enum BakeryDataLoader {
    enum DataError: Error {
        case invalidCSV
        case incompleteData
    }

    static func loadBundledData() -> BakeryData {
        guard let url = Bundle.main.url(forResource: "BakeryData", withExtension: "csv"),
              let csv = try? String(contentsOf: url, encoding: .utf8),
              let data = try? parse(csv),
              data.isComplete else {
            return BakeryData()
        }

        return data
    }

    static func loadRemoteData() async throws -> BakeryData {
        let url = freshDataURL()
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.setValue("application/vnd.github.raw", forHTTPHeaderField: "Accept")
        request.setValue("BakeryApp", forHTTPHeaderField: "User-Agent")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode,
              let csv = String(data: data, encoding: .utf8) else {
            throw DataError.invalidCSV
        }

        let bakeryData = try parse(csv)
        guard bakeryData.hasAnyData else {
            throw DataError.incompleteData
        }

        return bakeryData
    }

    private static func freshDataURL() -> URL {
        var components = URLComponents(url: bakeryDataCSVURL, resolvingAgainstBaseURL: false)
        var queryItems = components?.queryItems ?? []
        queryItems.append(URLQueryItem(name: "cacheBust", value: String(Int(Date().timeIntervalSince1970))))
        components?.queryItems = queryItems

        return components?.url ?? bakeryDataCSVURL
    }

    private static func parse(_ csv: String) throws -> BakeryData {
        let rows = parseRows(csv)
        guard let rawHeader = rows.first else {
            throw DataError.invalidCSV
        }

        let header = rawHeader.map(normalizedHeaderValue)
        var data = BakeryData()
        var thawGroups: [String: [ThawProduct]] = [:]
        var thawGroupOrder: [String] = []

        for row in rows.dropFirst() {
            let section = value("section", in: row, header: header)
            let id = value("id", in: row, header: header)
            let category = value("category", in: row, header: header)
            let group = value("group", in: row, header: header)
            let name = value("name", in: row, header: header)
            let shelfLife = value("shelf_life", in: row, header: header)
            let targetQuantity = Int(value("target_quantity", in: row, header: header))
            let weekdayTarget = Int(value("weekday_target", in: row, header: header))
            let weekendTarget = Int(value("weekend_target", in: row, header: header))
            let targetDescription = optionalValue("target_description", in: row, header: header)
            let trayDivisor = Int(value("tray_divisor", in: row, header: header))

            switch section {
            case "Shelf Life" where !category.isEmpty && !name.isEmpty && !shelfLife.isEmpty:
                data.shelfLifeItems.append(BakeryItem(merchandisingCategory: category, name: name, shelfLife: shelfLife))
            case "Buns" where !id.isEmpty && !name.isEmpty:
                data.bunProducts.append(BunProduct(id: id, name: name, targetQuantity: targetQuantity ?? 0, targetDescription: targetDescription))
            case "Thaw" where !id.isEmpty && !group.isEmpty && !name.isEmpty:
                if thawGroups[group] == nil {
                    thawGroups[group] = []
                    thawGroupOrder.append(group)
                }

                thawGroups[group]?.append(
                    ThawProduct(
                        id: id,
                        name: name,
                        weekdayTarget: weekdayTarget ?? 0,
                        weekendTarget: weekendTarget ?? 0,
                        targetDescription: targetDescription,
                        trayDivisor: trayDivisor
                    )
                )
            case "Skids" where !id.isEmpty && !category.isEmpty && !name.isEmpty:
                data.skidItems.append(SkidItem(id: id, category: category, name: name))
            default:
                continue
            }
        }

        data.thawGroups = thawGroupOrder.map { group in
            ThawGroup(id: slug(for: group), name: group, products: thawGroups[group, default: []])
        }

        return data
    }

    private static func value(_ key: String, in row: [String], header: [String]) -> String {
        guard let index = header.firstIndex(of: key), row.indices.contains(index) else {
            return ""
        }

        return row[index].trimmingCharacters(in: .whitespacesAndNewlines)
    }

    nonisolated private static func normalizedHeaderValue(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines.union(CharacterSet(charactersIn: "\u{feff}")))
    }

    private static func optionalValue(_ key: String, in row: [String], header: [String]) -> String? {
        let text = value(key, in: row, header: header)
        return text.isEmpty ? nil : text
    }

    private static func parseRows(_ csv: String) -> [[String]] {
        var rows: [[String]] = []
        var row: [String] = []
        var field = ""
        var isInsideQuotes = false
        var index = csv.startIndex

        while index < csv.endIndex {
            let character = csv[index]

            if character == "\"" {
                let nextIndex = csv.index(after: index)
                if isInsideQuotes && nextIndex < csv.endIndex && csv[nextIndex] == "\"" {
                    field.append(character)
                    index = nextIndex
                } else {
                    isInsideQuotes.toggle()
                }
            } else if character == "," && !isInsideQuotes {
                row.append(field)
                field = ""
            } else if character.isNewline && !isInsideQuotes {
                row.append(field)
                rows.append(row)
                row = []
                field = ""
            } else {
                field.append(character)
            }

            index = csv.index(after: index)
        }

        if !field.isEmpty || !row.isEmpty {
            row.append(field)
            rows.append(row)
        }

        return rows
    }

    private static func slug(for text: String) -> String {
        text.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: "-")
    }
}

#Preview {
    ContentView()
}
