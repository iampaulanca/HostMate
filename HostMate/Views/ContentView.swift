//
//  ContentView.swift
//  HostMate
//
//  Created by Paul Ancajima on 8/6/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var listingsViewModel: ListingsViewModel
    @StateObject private var locationVM = LocationSearchViewModel()
    @State private var selectedLocation: String = ""
    init(modelContext: ModelContext) {
        _listingsViewModel = StateObject(wrappedValue: ListingsViewModel(modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading) {
                    Text("HostMate - AI Assistant for Airbnb Hosts")
                        .font(.title)
                        .bold()
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding()
                    
                    if listingsViewModel.listings.isEmpty {
                        Text("No listings yet. Add one by tapping the plus button in the bottom right corner.")
                    } else {
                        List {
                            ForEach(listingsViewModel.listings) { listing in
                                NavigationLink(destination: ListingDetailView(listing: listing)) {
                                    Text(listing.name)
                                }
                            }
                            .onDelete(perform: listingsViewModel.deleteListing)
                        }
                        .listStyle(.plain)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal)
                
                NavigationLink {
                    AddListingView(viewModel: listingsViewModel, locationVM: locationVM, selectedLocation: selectedLocation)
                } label: {
                    Image(systemName: "plus")
                        .bold()
                        .foregroundStyle(.white)
                        .padding()
                        .background(.blue)
                        .clipShape(.circle)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
        }
    }

}

