//
//  DynamicIslandPanel.swift
//
//
//  Created by Rachanon on 14/6/2569 BE.
//

import SwiftUI

struct DynamicIslandPanel: View {
    // mockup
    private let songTitle = "Wonderwall"
    private let artist = "Oasis"

    var body: some View {
        HStack(spacing: 12) {
            albumArt
            Spacer(minLength: 8)
            equalizer
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .frame(width: 250, height: 32.75)
        .background(Color.black, in: Capsule())
    }

    private var albumArt: some View {
        RoundedRectangle(cornerRadius: 6, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [.pink, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 24, height: 24)
            .overlay(
                Image(systemName: "music.note")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white)
            )
    }

    private var equalizer: some View {
        HStack(spacing: 2.5) {
            ForEach([0.5, 1.0, 0.7, 0.35], id: \.self) { scale in
                Capsule()
                    .fill(Color.green)
                    .frame(width: 2, height: 18 * scale)
            }
        }
        .frame(height: 18)
    }
}

#Preview {
    DynamicIslandPanel()
        .padding(40)
        .background(Color.gray.opacity(0.3))
}
