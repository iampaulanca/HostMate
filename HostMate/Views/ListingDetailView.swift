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
    var body: some View {
        Text("\(listing.name)")
    }
}

