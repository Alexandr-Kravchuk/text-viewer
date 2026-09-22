//
//  PrivacySettingsView.swift
//  md-preview
//

import SwiftUI

// MARK: - Privacy

struct PrivacySettingsView: View {
    var body: some View {
        Form {
            Section {
                Label(L("Private by design"), systemImage: "hand.raised")
                    .font(.headline)
            } footer: {
                Text(L("Text Viewer does not collect usage analytics or crash reports. Files stay on your Mac."))
            }
        }
        .formStyle(.grouped)
    }
}
