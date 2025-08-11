//
//  CapsuleButtonStyle.swift
//  HostMate
//
//  Created by Paul Ancajima on 8/7/25.
//

import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
    var isDisabled: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                isDisabled
                ? Color.gray.opacity(0.6)
                : (configuration.isPressed ? Color.blue.opacity(0.6) : Color.blue)
            )
            .clipShape(Capsule())
    }
}
