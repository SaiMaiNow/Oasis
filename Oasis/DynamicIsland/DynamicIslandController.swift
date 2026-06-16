//
//  DynamicIslandController.swift
//
//  Created by Rachanon on 16/6/2569 BE.
//

import SwiftUI
import AppKit

// Intercepts mouse events only over the pill area; everything else falls through to windows below.
private final class PillHostingView: NSHostingView<DynamicIslandPanel> {
    var pillRectProvider: (() -> NSRect)?

    override func hitTest(_ point: NSPoint) -> NSView? {
        guard let rect = pillRectProvider?() else { return nil }
        return rect.contains(point) ? self : nil
    }

    override var mouseDownCanMoveWindow: Bool { false }
}

final class DynamicIslandController {
    private var panel: NSPanel?
    private var hostingView: PillHostingView?
    private let model = IslandModel()
    private var mouseMonitor: Any?
    private var clickMonitor: Any?
    private var idleTimer: Timer?

    func toggle() {
        if panel?.isVisible == true {
            panel?.orderOut(nil)
        } else {
            show()
        }
    }

    func show() {
        let panel = panel ?? makePanel()
        self.panel = panel
        position(panel)
        panel.orderFrontRegardless()
        startHoverTracking()
        startClickTracking()
    }

    func songDidStart() {
        idleTimer?.invalidate()
        idleTimer = nil
        model.hasActiveSong = true
        guard model.state == .idle else { return }
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
            model.state = .playing
        }
    }

    func songDidStop() {
        model.hasActiveSong = false
        if model.state == .playing {
            idleTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [weak self] _ in
                withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                    self?.model.state = .idle
                }
            }
        }
        // if .full: stay in full, UI switches to no-song view via hasActiveSong
    }

    private func startHoverTracking() {
        guard mouseMonitor == nil else { return }
        mouseMonitor = NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { [weak self] _ in
            self?.updateHover()
        }
    }

    private func updateHover() {
        guard let screen = NSScreen.main else { return }
        let rect: CGRect
        switch model.state {
        case .idle:
            rect = screenRect(for: .idle, screen: screen)
        case .playing:
            let s = playingHoverSize
            rect = CGRect(x: screen.frame.midX - s.width / 2,
                          y: screen.frame.maxY - s.height,
                          width: s.width, height: s.height)
        case .full:
            if model.hovering {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { model.hovering = false }
            }
            return
        }
        let inside = rect.contains(NSEvent.mouseLocation)
        guard inside != model.hovering else { return }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            model.hovering = inside
        }
    }

    private func startClickTracking() {
        guard clickMonitor == nil else { return }
        clickMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { [weak self] _ in
            self?.handleClick()
        }
    }

    private func handleClick() {
        // playing→full is handled by SwiftUI tap gesture via PillHostingView
        // only dismiss-from-full needs the global monitor (click outside card → other app)
        guard model.state == .full else { return }
        guard let screen = NSScreen.main else { return }
        if !screenRect(for: .full, screen: screen).contains(NSEvent.mouseLocation) {
            dismissFull()
        }
    }

    private func dismissFull() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
            model.state = model.hasActiveSong ? .playing : .idle
        }
    }

    private func screenRect(for state: PlaybackState, screen: NSScreen) -> CGRect {
        CGRect(
            x: screen.frame.midX - state.width / 2,
            y: screen.frame.maxY - state.height,
            width: state.width,
            height: state.height
        )
    }

    private func makePanel() -> NSPanel {
        let hosting = PillHostingView(rootView: DynamicIslandPanel(model: model))
        hosting.pillRectProvider = { [weak self] in self?.currentPillRect() ?? .zero }
        self.hostingView = hosting

        let panel = NSPanel(
            contentRect: NSRect(origin: .zero, size: islandStageSize),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = false
        panel.level = .statusBar
        panel.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        panel.isMovable = false
        panel.contentView = hosting
        return panel
    }

    // Pill rect in NSView coordinates (y from bottom) — used by PillHostingView.hitTest
    private func currentPillRect() -> NSRect {
        let w = islandStageSize.width
        let h = islandStageSize.height
        let pillW: CGFloat
        let pillH: CGFloat
        switch model.state {
        case .idle:
            pillW = model.hovering ? PlaybackState.playing.width : PlaybackState.idle.width
            pillH = PlaybackState.idle.height
        case .playing:
            pillW = model.hovering ? playingHoverSize.width : PlaybackState.playing.width
            pillH = model.hovering ? playingHoverSize.height : PlaybackState.playing.height
        case .full:
            pillW = PlaybackState.full.width
            pillH = PlaybackState.full.height
        }
        return NSRect(x: (w - pillW) / 2, y: h - pillH, width: pillW, height: pillH)
    }

    private func position(_ panel: NSPanel) {
        guard let screen = NSScreen.main else { return }
        let frame = screen.frame
        let x = frame.midX - islandStageSize.width / 2
        let y = frame.maxY - islandStageSize.height
        panel.setFrameOrigin(NSPoint(x: x, y: y))
    }
}
