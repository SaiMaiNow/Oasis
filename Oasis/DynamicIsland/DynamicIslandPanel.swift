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
            Spacer(minLength: 5)
            equalizer
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .frame(width: 280, height: 32.75)
        .background(Color.black, in: IslandShape())
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

struct IslandShape: Shape {
    var topRadius: CGFloat = 12
    var bottomRadius: CGFloat = 16
    func path(in rect: CGRect) -> Path {
        let w = rect.width, h = rect.height
        let r = min(topRadius, h / 2, w / 2)
        let b = min(bottomRadius, h - r, (w - 2 * r) / 2)
        var p = Path()

        p.move(to: CGPoint(x: 0, y: 0))
        p.addLine(to: CGPoint(x: w, y: 0))

        p.addQuadCurve(to: CGPoint(x: w - r, y: r), control: CGPoint(x: w - r, y: 0))

        p.addLine(to: CGPoint(x: w - r, y: h - b))

        p.addQuadCurve(to: CGPoint(x: w - r - b, y: h), control: CGPoint(x: w - r, y: h))

        p.addLine(to: CGPoint(x: r + b, y: h))

        p.addQuadCurve(to: CGPoint(x: r, y: h - b), control: CGPoint(x: r, y: h))

        p.addLine(to: CGPoint(x: r, y: r))

        p.addQuadCurve(to: CGPoint(x: 0, y: 0), control: CGPoint(x: r, y: 0))

        p.closeSubpath()
        return p
    }
}

#Preview {
    DynamicIslandPanel()
        .padding(40)
        .background(Color.gray.opacity(0.3))
}
