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
    @ObservedObject var locationVM: LocationSearchViewModel
   
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var name: String = ""
    @State var propertyType: String = ""
    @State private var selectedPropertyType: PropertyType? = nil
    @State private var vibeItems: [String] = []
    @State private var amenityItems: [String] = []
    @State private var targetGuestItems: [String] = []
    @State var vibe: String = ""
    @State var amenities: String = ""
    @State var targetGuests: String = ""
    @State var selectedLocation: String
    
    var editingListing: Listing? = nil
    var viewModel: ListingsViewModel?
   
    init(viewModel: ListingsViewModel? = nil, locationVM: LocationSearchViewModel, selectedLocation: String = "", editingListing: Listing? = nil) {
        self.viewModel = viewModel
        self.locationVM = locationVM
        self._selectedLocation = State(initialValue: selectedLocation)
        self.editingListing = editingListing
        // Prefill from editing listing if provided
        if let listing = editingListing {
            self._name = State(initialValue: listing.name)
            self._propertyType = State(initialValue: listing.propertyType)
            self._selectedPropertyType = State(initialValue: PropertyType.allCases.first { $0.displayName == listing.propertyType })
            self._vibeItems = State(initialValue: listing.vibe)
            self._amenityItems = State(initialValue: listing.amenities)
            self._targetGuestItems = State(initialValue: listing.targetGuests)
            self._selectedLocation = State(initialValue: listing.location)
        }
    }
    
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
            Section(header: Text("Vibe")) {
                HStack {
                    Text("\(vibeItems.count) selected")
                        .foregroundStyle(.secondary)
                    Spacer()
                    NavigationLink("Manage") {
                        VibeEditorView(vibes: $vibeItems)
                    }
                }
            }
            Section(header: Text("Amenities")) {
                HStack {
                    Text("\(amenityItems.count) selected")
                        .foregroundStyle(.secondary)
                    Spacer()
                    NavigationLink("Manage") {
                        AmenitiesEditorView(amenities: $amenityItems)
                    }
                }
            }
            Section(header: Text("Target Guests")) {
                HStack {
                    Text("\(targetGuestItems.count) selected")
                        .foregroundStyle(.secondary)
                    Spacer()
                    NavigationLink("Manage") {
                        GuestsEditorView(guests: $targetGuestItems)
                    }
                }
            }

            Section {
                Button(action: {
                    // Ensure propertyType string mirrors selection for persistence
                    self.propertyType = selectedPropertyType?.displayName ?? self.propertyType

                    if let listing = editingListing {
                        // Update existing listing
                        listing.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        listing.propertyType = propertyType.trimmingCharacters(in: .whitespacesAndNewlines)
                        listing.location = selectedLocation.trimmingCharacters(in: .whitespacesAndNewlines)
                        listing.vibe = vibeItems
                        listing.amenities = amenityItems
                        listing.targetGuests = targetGuestItems
                        listing.lastUpdated = Date()
                        viewModel?.update(listing)
                    } else {
                        // Create new listing
                        let newListing = Listing(
                            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                            propertyType: propertyType.trimmingCharacters(in: .whitespacesAndNewlines),
                            location: selectedLocation.trimmingCharacters(in: .whitespacesAndNewlines),
                            vibe: vibeItems,
                            amenities: amenityItems,
                            targetGuests: targetGuestItems
                        )
                        viewModel?.addListing(newListing)
                    }
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


struct AmenitiesEditorView: View {
    @Binding var amenities: [String]
    @State private var draft = ""
    private let suggestions = ["Wi‑Fi", "Parking", "Kitchen", "Washer", "Dryer", "Air conditioning", "Heating", "TV", "Pool", "Hot tub"]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section("Current") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 8)], spacing: 8) {
                    ForEach(amenities, id: \.self) { a in
                        Chip(text: a, removable: true) {
                            amenities.removeAll { $0 == a }
                        }
                        .gridCellAnchor(.leading)
                    }
                }
                .listRowInsets(EdgeInsets())
                .padding(.vertical, 8)
            }
            Section("Add") {
                HStack {
                    TextField("Add amenity…", text: $draft)
                        .onSubmit(addDraft)
                    Button("Add") { addDraft() }
                        .buttonStyle(.borderedProminent)
                        .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            Section("Suggestions") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(suggestions, id: \.self) { s in
                            Button {
                                if !amenities.contains(s) { amenities.append(s) }
                            } label: {
                                Chip(text: s)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Edit Amenities")
        .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } } }
    }

    private func addDraft() {
        let t = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }
        if !amenities.contains(t) { amenities.append(t) }
        draft = ""
    }
}

struct GuestsEditorView: View {
    @Binding var guests: [String]
    @State private var draft = ""
    private let suggestions = ["Families", "Remote workers", "Couples", "Pet owners", "Business travelers", "Long-term stays"]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section("Current") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 8)], spacing: 8) {
                    ForEach(guests, id: \.self) { g in
                        Chip(text: g, removable: true) {
                            guests.removeAll { $0 == g }
                        }
                        .gridCellAnchor(.leading)
                    }
                }
                .listRowInsets(EdgeInsets())
                .padding(.vertical, 8)
            }
            Section("Add") {
                HStack {
                    TextField("Add target guest…", text: $draft)
                        .onSubmit(addDraft)
                    Button("Add") { addDraft() }
                        .buttonStyle(.borderedProminent)
                        .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            Section("Suggestions") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(suggestions, id: \.self) { s in
                            Button {
                                if !guests.contains(s) { guests.append(s) }
                            } label: {
                                Chip(text: s)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Edit Target Guests")
        .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } } }
    }

    private func addDraft() {
        let t = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }
        if !guests.contains(t) { guests.append(t) }
        draft = ""
    }
}

// Lightweight chip reused by editors
struct Chip: View {
    let text: String
    var removable: Bool = false
    var onRemove: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 6) {
            Text(text)
                .font(.footnote)
            if removable, let onRemove {
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.footnote)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Remove \(text)")
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(.thinMaterial, in: Capsule())
    }
}

