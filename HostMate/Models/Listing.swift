//
//  Listing.swift
//  HostMate
//
//  Created by Paul Ancajima on 8/6/25.
//

import SwiftData
import Foundation

@Model
class Listing: Identifiable, ObservableObject {
    var id: UUID
    
    // MARK: - User Input
    var name: String
    var propertyType: String
    var location: String
    var vibe: [String]
    var amenities: [String]
    var targetGuests: [String]

    // AI Output
    var listingDescription: String?
    var houseRules: String?
    var localGuide: String?

    // Metadata
    var createdAt: Date = Date()
    var lastUpdated: Date = Date()
    
    init(
        id: UUID = UUID(),
        name: String,
        propertyType: String,
        location: String,
        vibe: [String] = [],
        amenities: [String] = [],
        targetGuests: [String] = []
    ) {
        self.id = id
        self.name = name
        self.propertyType = propertyType
        self.location = location
        self.vibe = vibe
        self.amenities = amenities
        self.targetGuests = targetGuests
    }
}
