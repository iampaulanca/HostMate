//
//  LocationSearchViewModel.swift
//  HostMate
//
//  Created by Paul Ancajima on 9/7/25.
//

import Foundation
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
