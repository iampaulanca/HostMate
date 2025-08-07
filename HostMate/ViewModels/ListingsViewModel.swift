//
//  ListingsViewModel.swift
//  HostMate
//
//  Created by Paul Ancajima on 8/6/25.
//

import Foundation
import SwiftData

class ListingsViewModel: ObservableObject {
    @Published var listings: [Listing] = []
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchListings()
    }

    func fetchListings() {
        let descriptor = FetchDescriptor<Listing>()
        if let results = try? modelContext.fetch(descriptor) {
            listings = results
        }
    }

    func addListing(_ listing: Listing) {
        modelContext.insert(listing)
        try? modelContext.save()
        fetchListings()
    }

    func deleteListing(at offsets: IndexSet) {
        for index in offsets {
            let listing = listings[index]
            modelContext.delete(listing)
        }
        try? modelContext.save()
        fetchListings()
    }

    func loadDemoData() {
        let demoListings = [
            Listing(name: "Cozy Tahoe Cabin", propertyType: "Cabin", location: "South Lake Tahoe, CA"),
            Listing(name: "Urban Loft", propertyType: "Apartment", location: "San Diego, CA")
        ]
        for listing in demoListings {
            modelContext.insert(listing)
        }
        try? modelContext.save()
        fetchListings()
    }
}
