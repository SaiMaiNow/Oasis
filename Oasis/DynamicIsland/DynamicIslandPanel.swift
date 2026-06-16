//
//  DynamicIslandPanel.swift
//
//
//  Created by Rachanon on 14/6/2569 BE.
//

import SwiftUI

enum PlaybackState {
    case idle
    case playing
    case full

    var width: CGFloat {
        switch self {
        case .idle:    return 150
        case .playing: return 280
        case .full:    return 380
        }
    }

    var height: CGFloat {
        switch self {
        case .idle, .playing: return 33
        case .full:           return 33 * 5
        }
    }

    var bottomRadius: CGFloat {
        switch self {
        case .idle, .playing: return 16
        case .full:           return 40
        }
    }

    var next: PlaybackState {
        switch self {
        case .idle:    return .playing
        case .playing: return .full
        case .full:    return .idle
        }
    }
}

let islandStageSize = CGSize(width: 400, height: 200)
let playingHoverSize = CGSize(width: 300, height: 44)

final class IslandModel: ObservableObject {
    @Published var state: PlaybackState = .full
    @Published var hovering = false
}

struct DynamicIslandPanel: View {
    @ObservedObject var model: IslandModel

    private let songTitle = "Wonderwall"
    private let artist = "Oasis"

    var body: some View {
        pill
            .frame(width: islandStageSize.width,
                   height: islandStageSize.height,
                   alignment: .top)
    }

    private var isHovering: Bool { model.state == .playing && model.hovering }
    private var pillWidth: CGFloat { isHovering ? playingHoverSize.width : model.state.width }
    private var pillHeight: CGFloat { isHovering ? playingHoverSize.height : model.state.height }

    private var pill: some View {
        content
            .frame(width: pillWidth, height: pillHeight)
            .background(Color.black, in: IslandShape(bottomRadius: model.state.bottomRadius))
            .shadow(color: .black.opacity(isHovering ? 0.5 : 0), radius: 14, y: 6)
    }

    @ViewBuilder
    private var content: some View {
        switch model.state {
        case .idle:    idleContent
        case .playing: playingContent.transition(.opacity)
        case .full:    fullContent.transition(.opacity)
        }
    }

    private var playingContent: some View {
        HStack(spacing: 12) {
            albumArt(isHovering ? 30 : 24)
            Spacer(minLength: 5)
            equalizer(.green, height: isHovering ? 24 : 18, barWidth: isHovering ? 3 : 2)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }

    private var idleContent: some View {
        Color.clear
    }

    private var fullContent: some View {
        VStack(spacing: 14) {
            HStack(spacing: 12) {
                albumArt(50)
                VStack(alignment: .leading, spacing: 3) {
                    Text(songTitle)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    Text(artist)
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.6))
                        .lineLimit(1)
                }
                Spacer(minLength: 0)
                equalizer(.white.opacity(0.8))
            }

            progressBar

            HStack {
                Image(systemName: "shuffle")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.6))
                Spacer()
                HStack(spacing: 28) {
                    Image(systemName: "backward.fill")
                    Image(systemName: "pause.fill").font(.system(size: 26))
                    Image(systemName: "forward.fill")
                }
                .font(.system(size: 20))
                .foregroundStyle(.white)
                Spacer()
                Image(systemName: "repeat")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .padding(.horizontal, 35)
        .padding(.top, 20)
        .padding(.bottom, 16)
    }

    private var progressBar: some View {
        VStack(spacing: 5) {
            HStack {
                Text("0:27")
                GeometryReader { geo in
                    let progress = geo.size.width * 0.1
                    Capsule()
                        .fill(.white.opacity(0.25))
                        .overlay(alignment: .leading) {
                            Capsule().fill(.white).frame(width: progress)
                        }
                        .overlay(alignment: .leading) {
                            Circle()
                                .fill(.white)
                                .frame(width: 11, height: 11)
                                .offset(x: progress - 5.5)
                        }
                }
                .frame(height: 6)
                Text("-4:03")
            }
            .font(.system(size: 10))
            .foregroundStyle(.white.opacity(0.5))
        }
    }

    private func albumArt(_ size: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: size * 0.25, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [.pink, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: size, height: size)
            .overlay(
                Image(systemName: "music.note")
                    .font(.system(size: size * 0.45, weight: .bold))
                    .foregroundStyle(.white)
            )
    }

    private func equalizer(_ color: Color, height: CGFloat = 18, barWidth: CGFloat = 2) -> some View {
        HStack(spacing: barWidth * 1.25) {
            ForEach([0.5, 1.0, 0.7, 0.35], id: \.self) { scale in
                Capsule()
                    .fill(color)
                    .frame(width: barWidth, height: height * scale)
            }
        }
        .frame(height: height)
    }
}

struct IslandShape: Shape {
    var topRadius: CGFloat = 12
    var bottomRadius: CGFloat = 16

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(topRadius, bottomRadius) }
        set { topRadius = newValue.first; bottomRadius = newValue.second }
    }

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
    DynamicIslandPanel(model: IslandModel())
        .padding(40)
        .background(Color.gray.opacity(0.3))
}
