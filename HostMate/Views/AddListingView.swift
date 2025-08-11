//
//  AddListingView.swift
//  HostMate
//
//  Created by Paul Ancajima on 8/6/25.
//


import SwiftUI
import SwiftData

import MapKit
import Combine

class LocationSearchViewModel: NSObject, ObservableObject {
    @Published var query = ""
    @Published var results: [MKLocalSearchCompletion] = []
    // used to remove results list on select
    @Published var didSelect: Bool = false
    private var completer = MKLocalSearchCompleter()
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()
        completer.resultTypes = .address
        completer.region = MKCoordinateRegion(.world) // optional: constrain to certain area

        // Listen to search completer updates
        completer.delegate = self

        // Update completer as query changes
        $query
          .removeDuplicates()
          .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
          .sink { [weak self] newValue in
            guard let self else { return }
            if self.didSelect {
              self.results = []
              self.didSelect = false
            } else {
              self.completer.queryFragment = newValue
            }
          }
          .store(in: &cancellables)
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Autocomplete error: \(error.localizedDescription)")
    }
}

struct LocationSearchField: View {
    @ObservedObject var locationVM: LocationSearchViewModel
    @Binding var selectedLocation: String

    var body: some View {
        VStack(alignment: .leading) {
            TextField("Enter city or address", text: $locationVM.query)
                .textFieldStyle(.roundedBorder)

            if !locationVM.results.isEmpty {
                List(locationVM.results, id: \.self) { completion in
                    VStack(alignment: .leading) {
                        Text(completion.title).bold()
                        if !completion.subtitle.isEmpty {
                            Text(completion.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 4)
                    .onTapGesture {
                        selectedLocation = completion.title
                        locationVM.query = completion.title
                        locationVM.didSelect = true
                    }
                }
                .frame(maxHeight: 100) // limit height
            }
        }
    }
}

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
    
    @ObservedObject var locationVM: LocationSearchViewModel
    @State var selectedLocation: String
    
    func disabled() -> Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        propertyType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $name)
            }
            Section(header: Text("Property Type")) {
                TextField("Property Type", text: $propertyType)
            }
            Section(header: Text("Location")) {
//                TextField("Location", text: $location)
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
