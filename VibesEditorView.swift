//
//  VibesEditorView.swift
//  HostMate
//
//  Created by Paul Ancajima on 9/16/25.
//

import SwiftUI

// MARK: - Editors
struct VibeEditorView: View {
    @Binding var vibes: [String]
    @State private var draft = ""
    private let suggestions = ["Cozy", "Modern", "Minimalist", "Rustic", "Family-friendly", "Boho", "Luxury"]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section("Current") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 8)], spacing: 8) {
                    ForEach(vibes, id: \.self) { v in
                        Chip(text: v, removable: true) {
                            vibes.removeAll { $0 == v }
                        }
                        .gridCellAnchor(.leading)
                    }
                }
                .listRowInsets(EdgeInsets())
                .padding(.vertical, 8)
            }
            Section("Add") {
                HStack {
                    TextField("Add vibe…", text: $draft)
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
                                if !vibes.contains(s) { vibes.append(s) }
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
        .navigationTitle("Edit Vibe")
        .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } } }
    }

    private func addDraft() {
        let t = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }
        if !vibes.contains(t) { vibes.append(t) }
        draft = ""
    }
}
