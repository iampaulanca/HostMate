//
//  ContentView.swift
//  HostMate
//
//  Created by Paul Ancajima on 8/6/25.
//

import SwiftUI
import SwiftData

struct AddListingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ListingsViewModel
    @State var name: String = ""
    @State var propertyType: String = ""
    @State var location: String = ""
    @State var vibe: String = ""
    @State var amenities: String = ""
    @State var targetGuests: String = ""

    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $name)
            }
            Section(header: Text("Property Type")) {
                TextField("Property Type", text: $propertyType)
            }
            Section(header: Text("Location")) {
                TextField("Location", text: $location)
            }
            Section(header: Text("Vibe (comma separated)")) {
                TextField("e.g. Cozy, Modern", text: $vibe)
            }
            Section(header: Text("Amenities (comma separated)")) {
                TextField("e.g. WiFi, Hot Tub", text: $amenities)
            }
            Section(header: Text("Target Guests (comma separated)")) {
                TextField("e.g. Families, Remote Workers", text: $targetGuests)
            }
            Section {
                Button("Save") {
                    let newListing = Listing(
                        name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                        propertyType: propertyType.trimmingCharacters(in: .whitespacesAndNewlines),
                        location: location.trimmingCharacters(in: .whitespacesAndNewlines),
                        vibe: vibe.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty },
                        amenities: amenities.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty },
                        targetGuests: targetGuests.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
                    )
                    viewModel.addListing(newListing)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                          propertyType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                          location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var listingsViewModel: ListingsViewModel
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
                    AddListingView(viewModel: listingsViewModel)
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

#Preview {
    // Create an in-memory model container for preview
    let schema = Schema([Listing.self])
    let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: [config])
    let context = container.mainContext
    ContentView(modelContext: context)
}
