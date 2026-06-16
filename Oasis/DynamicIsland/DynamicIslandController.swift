//
//  DynamicIslandController.swift
//
//  Created by Rachanon on 16/6/2569 BE.
//

import SwiftUI
import AppKit

final class DynamicIslandController {
    private var panel: NSPanel?
    private let model = IslandModel()
    private var mouseMonitor: Any?

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
    }

    private func startHoverTracking() {
        guard mouseMonitor == nil else { return }
        mouseMonitor = NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { [weak self] _ in
            self?.updateHover()
        }
    }

    private func updateHover() {
        guard let screen = NSScreen.main else { return }
        let size = playingHoverSize
        let rect = CGRect(x: screen.frame.midX - size.width / 2,
                          y: screen.frame.maxY - size.height,
                          width: size.width, height: size.height)
        let inside = rect.contains(NSEvent.mouseLocation)
        guard inside != model.hovering else { return }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            model.hovering = inside
        }
    }

    func toggleState() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
            model.state = model.state.next
        }
    }

    private func makePanel() -> NSPanel {
        let hosting = NSHostingView(rootView: DynamicIslandPanel(model: model))

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
        panel.ignoresMouseEvents = true
        panel.contentView = hosting
        return panel
    }

    private func position(_ panel: NSPanel) {
        guard let screen = NSScreen.main else { return }
        let frame = screen.frame
        let x = frame.midX - islandStageSize.width / 2
        let y = frame.maxY - islandStageSize.height
        panel.setFrameOrigin(NSPoint(x: x, y: y))
    }
}
