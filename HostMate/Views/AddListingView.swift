//
//  AddListingView.swift
//  HostMate
//
//  Created by Paul Ancajima on 8/6/25.
//


import SwiftUI
import SwiftData

enum PropertyType: String, CaseIterable, Identifiable {
    case apartment
    case house
    case guesthouse
    case bedAndBreakfast
    case boutiqueHotel
    case cabin
    case chalet
    case cottage
    case condo
    case loft
    case townhouse
    case villa
    case tinyHome
    case farmStay
    case dome
    case hut
    case cabinBoat
    case treehouse
    case yurt
    case camperRV
    case tent
    case castle
    case ryokan
    case riad
    case cave
    case lighthouse

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .apartment: return "Apartment"
        case .house: return "House"
        case .guesthouse: return "Guesthouse"
        case .bedAndBreakfast: return "Bed & Breakfast"
        case .boutiqueHotel: return "Boutique hotel"
        case .cabin: return "Cabin"
        case .chalet: return "Chalet"
        case .cottage: return "Cottage"
        case .condo: return "Condominium"
        case .loft: return "Loft"
        case .townhouse: return "Townhouse"
        case .villa: return "Villa"
        case .tinyHome: return "Tiny home"
        case .farmStay: return "Farm stay"
        case .dome: return "Dome"
        case .hut: return "Hut"
        case .cabinBoat: return "Houseboat"
        case .treehouse: return "Treehouse"
        case .yurt: return "Yurt"
        case .camperRV: return "Camper/RV"
        case .tent: return "Tent"
        case .castle: return "Castle"
        case .ryokan: return "Ryokan"
        case .riad: return "Riad"
        case .cave: return "Cave"
        case .lighthouse: return "Lighthouse"
        }
    }
}

struct AddListingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ListingsViewModel
    @State var name: String = ""
    @State var propertyType: String = ""
    @State private var selectedPropertyType: PropertyType? = nil
    @State var vibe: String = ""
    @State var amenities: String = ""
    @State var targetGuests: String = ""
    
    @ObservedObject var locationVM: LocationSearchViewModel
    @State var selectedLocation: String
    
    func disabled() -> Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        selectedPropertyType == nil ||
        selectedLocation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $name)
            }
            Section(header: Text("Property Type")) {
                Picker("", selection: Binding(
                    get: { selectedPropertyType },
                    set: { newValue in
                        selectedPropertyType = newValue
                        propertyType = newValue?.displayName ?? ""
                    }
                )) {
                    Text("Select a type").tag(Optional<PropertyType>.none)
                    ForEach(PropertyType.allCases) { type in
                        Text(type.displayName).tag(Optional(type))
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
                .offset(x: -10)
            }
            
            Section(header: Text("Location")) {
                LocationSearchField(locationVM: locationVM, selectedLocation: $selectedLocation)
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
                Button(action: {
                    // Ensure propertyType string mirrors selection for persistence
                    self.propertyType = selectedPropertyType?.displayName ?? self.propertyType
                    let newListing = Listing(
                        name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                        propertyType: propertyType.trimmingCharacters(in: .whitespacesAndNewlines),
                        location: selectedLocation.trimmingCharacters(in: .whitespacesAndNewlines),
                        vibe: vibe.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty },
                        amenities: amenities.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty },
                        targetGuests: targetGuests.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
                    )
                    viewModel.addListing(newListing)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                }
                .listRowInsets(EdgeInsets())
                .buttonStyle(CapsuleButtonStyle(isDisabled: disabled()))
                .disabled(disabled())
            }
        }
    }
}


#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let model: ModelContainer = try! .init(for: Listing.self, configurations: config)
//    AddListingView(viewModel: .init(modelContext: model.mainContext))
}

