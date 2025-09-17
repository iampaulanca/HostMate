//
//  ListingDetailView.swift
//  HostMate
//
//  Created by Paul Ancajima on 8/6/25.
//

import Foundation
import SwiftUI

struct ListingDetailView: View {
    @ObservedObject var listing: Listing
    @State private var showingEdit = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title
                Text(listing.name)
                    .font(.largeTitle)
                    .bold()
                    .accessibilityAddTraits(.isHeader)

                // Property type and location
                HStack(spacing: 8) {
                    if !listing.propertyType.isEmpty {
                        Label(listing.propertyType, systemImage: "house")
                    }
                    if !listing.location.isEmpty {
                        Label(listing.location, systemImage: "mappin.and.ellipse")
                    }
                }
                .foregroundStyle(.secondary)

                // Vibe chips
                if !listing.vibe.isEmpty {
                    GroupBox("Vibe") {
                        VStack(alignment: .leading, spacing: 0) {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 8)], spacing: 8) {
                                ForEach(listing.vibe, id: \.self) { tag in
                                    TagView(text: tag)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                // Amenities chips
                if !listing.amenities.isEmpty {
                    GroupBox("Amenities") {
                        VStack(alignment: .leading, spacing: 0) {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 8)], spacing: 8) {
                                ForEach(listing.amenities, id: \.self) { amenity in
                                    TagView(text: amenity, systemImage: icon(for: amenity))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                // Target guests chips
                if !listing.targetGuests.isEmpty {
                    GroupBox("Great for") {
                        VStack(alignment: .leading, spacing: 0) {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 8)], spacing: 8) {
                                ForEach(listing.targetGuests, id: \.self) { tg in
                                    TagView(text: tg, systemImage: "person.2")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                // Description
                if let description = listing.listingDescription, !description.isEmpty {
                    GroupBox("About this place") {
                        Text(description)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                    }
                }

                // House rules
                if let rules = listing.houseRules, !rules.isEmpty {
                    GroupBox("House rules") {
                        Text(rules)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                    }
                }

                // Local guide
                if let guide = listing.localGuide, !guide.isEmpty {
                    GroupBox("Local guide") {
                        Text(guide)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                    }
                }

                // Metadata
                GroupBox("Metadata") {
                    VStack(alignment: .leading, spacing: 8) {
                        LabeledContent("Created", value: listing.createdAt.formatted(date: .abbreviated, time: .shortened))
                        LabeledContent("Last updated", value: listing.lastUpdated.formatted(date: .abbreviated, time: .shortened))
                    }
                }

                Spacer(minLength: 12)
            }
            .padding()
        }
        .navigationTitle("Listing Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") { showingEdit = true }
            }
        }
        .sheet(isPresented: $showingEdit) {
            NavigationStack {
                AddListingView(
                    viewModel: nil,
                    locationVM: LocationSearchViewModel(),
                    selectedLocation: listing.location,
                    editingListing: listing
                )
            }
        }
    }

    // MARK: - Helpers
    private func icon(for amenity: String) -> String {
        switch amenity.lowercased() {
        case "wifi", "wi-fi": return "wifi"
        case "parking": return "car"
        case "pool": return "water.waves"
        case "kitchen": return "fork.knife"
        case "air conditioning", "ac": return "wind"
        case "tv", "television": return "tv"
        case "washer", "laundry": return "washer"
        case "dryer": return "dryer"
        case "pet friendly", "pets": return "pawprint"
        default: return "checkmark.circle"
        }
    }
}

// MARK: - Lightweight UI helpers
// Simple tag pill
private struct TagView: View {
    let text: String
    var systemImage: String? = nil

    var body: some View {
        HStack(spacing: 6) {
            if let systemImage {
                Image(systemName: systemImage)
            }
            Text(text)
                .fixedSize(horizontal: false, vertical: true)
        }
        .font(.footnote)
        .padding(.vertical, 6)
        .background(.thinMaterial, in: Capsule())
    }
}
