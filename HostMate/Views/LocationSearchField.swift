struct LocationSearchField: View {
    @ObservedObject var locationVM: LocationSearchViewModel
    @Binding var selectedLocation: String

    var body: some View {
        VStack(alignment: .leading) {
            TextField("Enter city or address", text: $locationVM.query)
                

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